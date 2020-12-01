#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright 2020 SkyWater PDK Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

"""
Module for generating cell layouts for given technology files and GDS files.

Creates cell layout SVG files from GDS cell files using `magic` tool.
"""

import sys
import os
import re
import argparse

sys.path.insert(0, os.path.abspath(__file__ + '/../../'))

from skywater_pdk.tools import magic, draw  # noqa: E402


def convert_gds_to_svg(
        input_gds,
        input_techfile,
        output_svg=None,
        tmp_tcl=None,
        keep_temporary_files=False) -> int:
    """
    Converts GDS file to SVG cell layout diagram.

    Generates TCL script for drawing a cell layout in `magic` tool and creates
    a SVG file with the diagram.

    Parameters
    ----------
    input_gds : str
        Path to input GDS file
    input_techfile : str
        Path to input technology definition file (.tech)
    output_svg : str
        Path to output SVG file
    keep_temporary_files : bool
        Determines if intermediate TCL script should be kept

    Returns
    -------
    int : 0 if finished successfully, error code from `magic` otherwise
    """
    input_gds = os.path.abspath(input_gds)
    if output_svg:
        output_svg = os.path.abspath(output_svg)
        destdir, _ = os.path.split(output_svg)
    else:
        destdir, name = os.path.split(input_gds)
        output_svg = os.path.join(destdir, f'{name}.svg')
    input_techfile = os.path.abspath(input_techfile)

    workdir, _ = os.path.split(input_techfile)

    if output_svg:
        filename, _ = os.path.splitext(output_svg)
        if not tmp_tcl:
            tmp_tcl = f'{filename}.tcl'
    try:
        tmp_tcl, output_svg = magic.create_tcl_plot_script_for_gds(
            input_gds,
            tmp_tcl,
            output_svg)
        magic.run_magic(
            tmp_tcl,
            input_techfile,
            workdir,
            display_workstation='XR')

        if not keep_temporary_files:
            if os.path.exists(tmp_tcl):
                os.unlink(tmp_tcl)
        assert os.path.exists(output_svg), f'Magic did not create {output_svg}'
    except magic.MagicError as err:
        if not keep_temporary_files:
            if os.path.exists(tmp_tcl):
                os.unlink(tmp_tcl)
        print(err)
        return err.errorcode
    except Exception:
        if not keep_temporary_files:
            if os.path.exists(tmp_tcl):
                os.unlink(tmp_tcl)
        raise
    return 0


def cleanup_gds_diagram(input_svg, output_svg) -> int:
    """
    Crops and cleans up GDS diagram.

    Parameters
    ----------
    input_svg : str
        Input SVG file with cell layout
    output_svg : str
        Output SVG file with cleaned cell layout

    Returns
    -------
    int : 0 if successful, error code from Inkscape otherwise
    """
    with open(input_svg, 'r') as f:
        data = f.read()
    data = re.sub(
        '<rect[^>]* style="[^"]*fill-opacity:1;[^"]*"/>',
        '',
        data
    )
    with open(output_svg, 'w') as f:
        f.write(data)
    result = draw.run_inkscape([
            "--verb=FitCanvasToDrawing",
            "--verb=FileSave",
            "--verb=FileClose",
            "--verb=FileQuit",
            output_svg
        ],
        3)
    if result[-1] != 0:
        return result[-1]

    result = draw.run_inkscape([
            f'--export-plain-svg={output_svg}',
            '--existsport-background-opacity=1.0',
            output_svg
        ],
        3)
    return result[-1]


def main(argv):
    parser = argparse.ArgumentParser(
        prog=argv[0],
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument(
        'input_gds',
        help="Path to the input .gds file"
    )
    parser.add_argument(
        'input_tech',
        help="Path to the input .tech file"
    )
    parser.add_argument(
        '--output-svg',
        help='Path to the output .svg file'
    )
    parser.add_argument(
        '--output-tcl',
        help='Path to temporary TCL file'
    )
    parser.add_argument(
        '--keep-temporary-files',
        help='Keep the temporary files in the end',
        action='store_true'
    )
    args = parser.parse_args(argv[1:])

    if args.output_svg:
        filename, _ = os.path.splitext(args.output_svg)
        tmp_svg = f'{filename}.tmp.svg'
    else:
        filename, _ = os.path.splitext(args.input_gds)
        tmp_svg = f'{filename}.tmp.svg'
        args.output_svg = f'{filename}.svg'

    result = convert_gds_to_svg(
        args.input_gds,
        args.input_tech,
        tmp_svg,
        args.output_tcl,
        args.keep_temporary_files
    )

    if result != 0:
        return result

    result = cleanup_gds_diagram(tmp_svg, args.output_svg)

    if not args.keep_temporary_files:
        os.unlink(tmp_svg)

    return result


if __name__ == '__main__':
    sys.exit(main(sys.argv))
