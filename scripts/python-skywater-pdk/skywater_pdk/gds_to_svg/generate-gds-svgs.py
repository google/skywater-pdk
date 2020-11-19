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

import argparse
from pathlib import Path
import sys
import contextlib
import traceback
import errno

from gds_to_svg import convert_to_svg


def main(argv):
    parser = argparse.ArgumentParser(prog=argv[0])
    parser.add_argument(
        'libraries_dir',
        help='Path to the libraries directory of skywater-pdk',
        type=Path
    )
    parser.add_argument(
        'tech_file',
        help='Path to the .tech file',
        type=Path
    )
    parser.add_argument(
        'output_dir',
        help='Path to the output directory',
        type=Path
    )
    parser.add_argument(
        '--libname',
        help='Library name to generate cell layouts for from GDS files',
        type=str
    )
    parser.add_argument(
        '--version',
        help='Version to generate cell layouts for from GDS files',
        type=str
    )
    parser.add_argument(
        '--create-dirs',
        help='Create directories for output when not present',
        action='store_true'
    )
    parser.add_argument(
        '--failed-inputs',
        help='Path to GDS files for which Magic failed to generate SVG files',
        type=Path
    )

    args = parser.parse_args(argv[1:])

    gdsfiles = list(args.libraries_dir.rglob('*.gds'))

    nc = contextlib.nullcontext()

    with open(args.failed_inputs, 'w') if args.failed_inputs else nc as err:
        for gdsfile in gdsfiles:
            outdir = (args.output_dir /
                      gdsfile.parent.resolve()
                      .relative_to(args.libraries_dir.resolve()))
            library = outdir.relative_to(args.output_dir).parts[0]
            ver = outdir.relative_to(args.output_dir).parts[1]
            if args.libname and args.libname != library:
                continue
            if args.version and args.version != ver:
                continue
            print(f'===> {str(gdsfile)}')
            try:
                if not outdir.exists():
                    if args.create_dirs:
                        outdir.mkdir(parents=True)
                    else:
                        print(f'The output directory {str(outdir)} is missing')
                        print('Run the script with --create-dirs')
                        return errno.ENOENT
                outfile = outdir / gdsfile.with_suffix('.svg').name
                convert_to_svg(gdsfile, args.tech_file, outfile)
            except Exception:
                print(
                    f'Failed to generate cell layout for {str(gdsfile)}',
                    file=sys.stderr
                )
                traceback.print_exc()
                err.write(f'{gdsfile}\n')

    print('Finished generating cell layouts')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
