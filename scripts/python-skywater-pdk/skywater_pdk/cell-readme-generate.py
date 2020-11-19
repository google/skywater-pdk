#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright 2020 The SkyWater PDK Authors.
#
# Use of this source code is governed by the Apache 2.0
# license that can be found in the LICENSE file or at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0

''' This is a prototype of cell documentation generation script.
    WORK IN PROGRESS
'''


import csv
import json
import os
import sys
import argparse
import pathlib
import glob
import subprocess
import textwrap

def write_readme(cellpath, define_data):
    ''' Generates README for a given cell.
    '''
    netlist_json = os.path.join(cellpath, define_data['file_prefix']+'.json')
    assert os.path.exists(netlist_json), netlist_json
    outpath = os.path.join(cellpath, 'README.rst')

    header = define_data['name'] + ' cell description'
    headline = '-' * len(header)

    prefix = define_data['file_prefix'] 
    
    sym1 = prefix + '.symbol.svg'
    sym2 = prefix + '.pp.symbol.svg'
    sche = prefix + '.schematic.svg'

    
    with open(outpath, 'w') as f:
        f.write (f'{header}\n')
        f.write (f'{headline}\n')
        f.write ('\nThis is a stub of cell descrition file.\n\n')

        f.write (f" * Name: {define_data['name']}\n")
        f.write (f" * Type: {define_data['type']}\n")
        f.write (f" * Verilog name: {define_data['verilog_name']}\n")
        desc = textwrap.indent(define_data['description'], '       ').lstrip(),
        f.write (f" * Description: {desc}\n")
        
        f.write ('\nSome sample images:\n')

        f.write (f'\n.. image:: {sym1}\n   :align: center\n   :alt: Symbol\n')
        f.write (f'\n.. image:: {sym2}\n   :align: center\n   :alt: SymbolPP\n')
        f.write (f'\n.. image:: {sche}\n   :align: center\n   :alt: Schematic\n')


def process(cellpath):
    ''' Processes cell indicated by path.
        Opens cell definiton and calls further processing

    Args:
        cellpath - path to a cell [str of pathlib.Path]
    '''

    print()
    print(cellpath)
    define_json = os.path.join(cellpath, 'definition.json')
    if not os.path.exists(define_json):
        print("No definition.json in", cellpath)
    assert os.path.exists(define_json), define_json
    define_data = json.load(open(define_json))

    if define_data['type'] == 'cell':
        write_readme(cellpath, define_data)

    return


def main():
    ''' Generates README.rst for cell.'''

    prereq_txt = ''
    output_txt = 'output:\n  generates README.rst'
    allcellpath = '../../../libraries/*/latest/cells/*'

    parser = argparse.ArgumentParser(
            description = main.__doc__,
            epilog = prereq_txt +'\n\n'+ output_txt,
            formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
            "--all_libs",
            help="process all cells in "+allcellpath,
            action="store_true")
    parser.add_argument(
            "cell_dir",
            help="path to the cell directory",
            type=pathlib.Path,
            nargs="*")

    args = parser.parse_args()

    if args.all_libs:
        path = pathlib.Path(allcellpath).expanduser()
        parts = path.parts[1:] if path.is_absolute() else path.parts
        paths = pathlib.Path(path.root).glob(str(pathlib.Path("").joinpath(*parts)))
        args.cell_dir = list(paths)

    cell_dirs = [d.resolve() for d in args.cell_dir if d.is_dir()]

    errors = 0
    for d in cell_dirs:
        try:
            process(d)
        except KeyboardInterrupt:
            sys.exit(1)
        except (AssertionError, FileNotFoundError, ChildProcessError) as ex:
            print (f'Error: {type(ex).__name__}')
            print (f'{ex.args}')
            errors +=1
    print (f'\n{len(cell_dirs)} files processed, {errors} errors.')
    return 0 if errors else 1

if __name__ == "__main__":
    sys.exit(main())

