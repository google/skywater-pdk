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

import sys
import os
import re
import subprocess
import argparse

FATAL_ERROR = re.compile('((Error parsing)|(No such file or directory)|(couldn\'t be read))')  # noqa: E501
READING_REGEX = re.compile('Reading "([^"]*)".')

debug = True
superdebug = True


def _magic_tcl_header(ofile, gdsfile):
    """
    Adds a header to TCL file.

    Parameters
    ----------
    ofile: output file stream
    gdsfile: path to GDS file
    """
    print('#!/bin/env wish',         file=ofile)
    print('drc off',                 file=ofile)
    print('scalegrid 1 2',           file=ofile)
    print('cif istyle vendorimport', file=ofile)
    print('gds readonly true',       file=ofile)
    print('gds rescale false',       file=ofile)
    print('tech unlock *',           file=ofile)
    print('cif warning default',     file=ofile)
    print('set VDD VPWR',            file=ofile)
    print('set GND VGND',            file=ofile)
    print('set SUB SUBS',            file=ofile)
    print('gds read ' + gdsfile,     file=ofile)


def run_magic(destdir, tcl_path, input_techfile, d="null"):
    """
    Runs magic to generate layout files.

    Parameters
    ----------
    destdir: destination directory
    tcl_path: path to input TCL file
    input_techfile: path to the technology file
    d: Workstation type, can be NULL, X11, OGL or XWIND
    """
    cmd = [
        'magic',
        '-nowrapper',
        '-d'+d,
        '-noconsole',
        '-T', input_techfile,
        os.path.abspath(tcl_path)
    ]
    with open(tcl_path.replace(".tcl", ".sh"), "w") as f:
        f.write("#!/bin/sh\n")
        f.write(" ".join(cmd))
    mproc = subprocess.run(
        cmd,
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        cwd=destdir,
        universal_newlines=True)
    assert mproc.stdout
    max_cellname_width = 0
    output_by_cells = [('', [])]
    fatal_errors = []
    for line in mproc.stdout.splitlines():
        cifwarn = ('CIF file read warning: Input off lambda grid by 1/2; ' +
                   'snapped to grid')
        if line.startswith(cifwarn):
            continue
        m = FATAL_ERROR.match(line)
        if m:
            fatal_errors.append(line)
        m = READING_REGEX.match(line)
        if m:
            cell_name = m.group(1)
            max_cellname_width = max(max_cellname_width, len(cell_name))
            output_by_cells.append((cell_name, []))
        output_by_cells[-1][-1].append(line)
    for cell, lines in output_by_cells:
        prefix = "magic " + cell.ljust(max_cellname_width) + ':'
        for line in lines:
            is_error = 'rror' in line
            if superdebug or (debug and is_error):
                print(prefix, line)
    assert not mproc.stderr, mproc.stderr
    if mproc.returncode != 0 or fatal_errors:
        if fatal_errors:
            msg = ['ERROR: Magic had fatal errors in output:'] + fatal_errors
        else:
            msg = ['ERROR: Magic exited with status ' + str(mproc.returncode)]
        msg.append("")
        msg.append(" ".join(cmd))
        msg.append('='*75)
        msg.append(mproc.stdout)
        msg.append('='*75)
        msg.append(destdir)
        msg.append(tcl_path)
        msg.append('-'*75)
        msg.append(msg[0])
        raise SystemError('\n'.join(msg))
    return output_by_cells


def convert_to_svg(input_gds, input_techfile, output=None):
    """
    Converts GDS file to a SVG layout image.

    Parameters
    ----------
    input_gds: path to input GDS file
    input_techfile: path to the technology file
    output: optional path to the final SVG file
    """
    input_gds = os.path.abspath(input_gds)
    input_techfile = os.path.abspath(input_techfile)
    destdir, gdsfile = os.path.split(input_gds)
    basename, ext = os.path.splitext(gdsfile)
    if output:
        output_svg = output
    else:
        output_svg = os.path.join(destdir, "{}.svg".format(basename))
    assert not os.path.exists(output_svg), output_svg + " already exists!?"
    tcl_path = os.path.join(destdir, "{}.gds2svg.tcl".format(basename))
    with open(tcl_path, 'w') as ofile:
        _magic_tcl_header(ofile, input_gds)
        ofile.write("load " + basename + "\n")
        ofile.write("box 0 0 0 0\n")
        ofile.write("select top cell\n")
        ofile.write("expand\n")
        ofile.write("view\n")
        ofile.write("select clear\n")
        ofile.write("box position -1000 -1000\n")
        ofile.write("plot svg " + basename + ".tmp1.svg\n")
        ofile.write("quit -noprompt\n")
    run_magic(destdir, tcl_path, input_techfile, " XR")
    tmp1_svg = os.path.join(destdir, "{}.tmp1.svg".format(basename))
    tmp2_svg = os.path.join(destdir, "{}.tmp2.svg".format(basename))
    assert os.path.exists(tmp1_svg), tmp1_svg + " doesn't exist!?"
    os.unlink(tcl_path)
    for i in range(0, 3):
        # Remove the background
        with open(tmp1_svg) as f:
            data = f.read()
        data = re.sub(
            '<rect[^>]* style="[^"]*fill-opacity:1;[^"]*"/>',
            '',
            data
        )
        with open(tmp2_svg, 'w') as f:
            f.write(data)
        # Use inkscape to crop
        retcode = run_inkscape([
            "--verb=FitCanvasToDrawing",
            "--verb=FileSave",
            "--verb=FileClose",
            "--verb=FileQuit",
            tmp2_svg])
        if retcode == 0:
            break
    for i in range(0, 3):
        # Convert back to plain SVG
        retcode = run_inkscape([
            "--export-plain-svg=%s" % (tmp2_svg),
            "--export-background-opacity=1.0",
            tmp2_svg])
        if retcode == 0:
            break
    os.unlink(tmp1_svg)
    # Move into the correct location
    os.rename(tmp2_svg, output_svg)
    print("Created", output_svg)


def run_inkscape(args):
    """
    Run Inkscape with given arguments.

    Parameters
    ----------
    args: List of arguments to be passed to Inkscape
    """
    p = subprocess.Popen(["inkscape"] + args)
    try:
        p.wait(timeout=60)
    except subprocess.TimeoutExpired:
        print("ERROR: Inkscape timed out! Sending SIGTERM")
        p.terminate()
        try:
            p.wait(timeout=60)
        except subprocess.TimeoutExpired:
            print("ERROR: Inkscape timed out! Sending SIGKILL")
            p.kill()
        p.wait()
    return p.returncode


def main(argv):
    parser = argparse.ArgumentParser(argv[0])
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
    args = parser.parse_args(argv[1:])
    convert_to_svg(args.input_gds, args.input_tech, args.output_svg)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
