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
import argparse
from pathlib import Path
import errno
import contextlib
import traceback
import subprocess


def main(argv):
    parser = argparse.ArgumentParser(prog=argv[0])
    parser.add_argument(
        'libraries_dir',
        help='Path to the libraries directory of skywater-pdk',
        type=Path
    )
    parser.add_argument(
        'output_dir',
        help='Path to the output directory',
        type=Path
    )
    parser.add_argument(
        '--libname',
        help='Library name to generate the Symbolator diagrams for',
        type=str
    )
    parser.add_argument(
        '--version',
        help='Version for which the Symbolator diagrams should be generated',
        type=str
    )
    parser.add_argument(
        '--create-dirs',
        help='Create directories for output when not present',
        action='store_true'
    )
    parser.add_argument(
        '--failed-inputs',
        help='Path to files for which Symbolator failed to generate diagram',
        type=Path
    )
    parser.add_argument(
        '--overwrite-existing',
        help='If present, the script will overwrite existing symbol.svg files',
        action='store_true'
    )

    args = parser.parse_args(argv[1:])

    libraries_dir = args.libraries_dir

    symbol_v_files = libraries_dir.rglob('*.symbol.v')

    nc = contextlib.nullcontext()

    with open(args.failed_inputs, 'w') if args.failed_inputs else nc as err:
        for symbol_v_file in symbol_v_files:
            if args.libname and args.libname != symbol_v_file.parts[1]:
                continue
            if args.version and args.version != symbol_v_file.parts[2]:
                continue

            print(f'===> {str(symbol_v_file)}')
            libname = symbol_v_file.parts[1]
            out_filename = (args.output_dir /
                            symbol_v_file.resolve()
                            .relative_to(libraries_dir.resolve()))
            out_filename = out_filename.with_suffix('.svg')
            out_dir = out_filename.parent

            if not out_dir.exists():
                if args.create_dirs:
                    out_dir.mkdir(parents=True)
                else:
                    print(f'The output directory {str(out_dir)} is missing')
                    print('Run the script with --create-dirs')
                    return errno.ENOENT

            if out_filename.exists() and not args.overwrite_existing:
                print(f'The {out_filename} already exists')
                return errno.EEXIST

            program = ('symbolator' +
                       f' --libname {libname} --title -t -o {out_filename}' +
                       f' --output-as-filename -i {str(symbol_v_file)}' +
                       ' --format svg')
            res = subprocess.run(
                program.split(' '),
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT
            )
            if res.returncode != 0:
                print(
                    f'Failed to run: {program}',
                    file=sys.stderr
                )
                print('STDOUT:\n', file=sys.stderr)
                print(res.stdout.decode())
                err.write(f'{symbol_v_file}\n')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
