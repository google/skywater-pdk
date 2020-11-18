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


import csv
import json
import os
import sys
import argparse
import pathlib
import glob
import subprocess

def outfile(cellpath, define_data, ftype='', extra='', exists=False):
    ''' Determines output file path and name.

    Args:
        cellpath - path to a cell [str of pathlib.Path]
        define_data - cell definition data [dic]
        ftype - file type suffix [str]
        extra - extra suffix [str]
        exist - optional check if file exists [bool or None]

    Returns:
        outpath - output file namepath [str]
   '''

    fname = define_data['name'].lower().replace('$', '_')
    if ftype:
        ftype = '.'+ftype
    outpath = os.path.join(cellpath, f'{define_data["file_prefix"]}{extra}{ftype}.svg')
    if exists is None:
        pass
    elif not exists:
        #assert not os.path.exists(outpath), "Refusing to overwrite existing file:"+outpath
        print("Creating", outpath)
    elif exists:
        assert os.path.exists(outpath), "Missing required:"+outpath
    return outpath


def write_netlistsvg(cellpath, define_data):
    ''' Generates netlistsvg for a given cell.

    Args:
        cellpath - path to a cell [str of pathlib.Path]
        define_data - cell definition data [dic]
    '''

    netlist_json = os.path.join(cellpath, define_data['file_prefix']+'.json')
    if not os.path.exists(netlist_json):
        print("No netlist in", cellpath)
    assert os.path.exists(netlist_json), netlist_json
    outpath = outfile(cellpath, define_data, 'schematic')
    if subprocess.call(['netlistsvg', netlist_json, '-o', outpath]):
      raise ChildProcessError("netlistsvg execution failed")

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
        write_netlistsvg(cellpath, define_data)

    return


def main():
    ''' Generates netlistsvg schematic from cell netlist.'''

    prereq_txt = 'prerequisities:\n  netlistsvg'
    output_txt = 'output:\n  generates [cell_prefix].schematic.svg'
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

