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

''' This is a cell VCD waveform generation script.
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
import re


def write_vcd (cellpath, define_data, use_power_pins=False):
    ''' Generates vcd for a given cell.

    Args:
        cellpath - path to a cell [str of pathlib.Path]
        define_data - cell data from json [dic]
        use_power_pins - include power pins toggling in simulation [bool]
    '''

    # collect power port names
    pp = []
    for p in define_data['ports']:
        if len(p)>2 and p[0]=='power':
                pp.append(p[1])

    # define output file(s)
    ppsuffix = '.pp' if use_power_pins else ''
    outfile = os.path.join(cellpath, define_data['file_prefix'] + ppsuffix + '.vcd')
    vppfile = os.path.join(cellpath, define_data['file_prefix'] + '.vpp.tmp')
    tmptestbed  = os.path.join(cellpath, define_data['file_prefix'] + '.tb.v.tmp')

    # find and patch Verilog testbed file
    testbedfile = os.path.join(cellpath, define_data['file_prefix'] + '.tb.v')
    assert os.path.exists(testbedfile), testbedfile
    insertppdefine = use_power_pins
    insertdumpvars = True
    insertfinish   = True
    prvline=''
    with open(tmptestbed,'w') as ttb:
        with open(testbedfile,'r') as tbf:
            for line in tbf:
                # add use_power_pins define
                if insertppdefine and line.startswith('`include'):
                    line = '`define USE_POWER_PINS\n' + line
                    insertppdefine = False 
                # add dumpfile define                 
                if insertdumpvars and prvline.strip(' \n\r')=='begin':
                    line = line[:-len(line.lstrip())] + \
                           '$dumpfile("' + outfile + '");\n' + \
                           line[:-len(line.lstrip())] + \
                           '$dumpvars(1,top);\n' + \
                           line
                    insertdumpvars = False
                # add finish command, to stop paraller threads
                if insertfinish and line.strip(' \n\r')=='end' and not '$finish' in prvline:
                    line = prvline[:-len(prvline.lstrip())] + '$finish;\n' + line
                    insertfinish = False
                # remove power pins from reg - optinal, but makes output more readable
                if not use_power_pins:
                    for p in pp:
                        if re.search( 'reg\s+'+p, line ) is not None or \
                           re.search( p+'\s+\=', line )  is not None :
                             line=''
                             break
                # remove power pins from dut 
                if not use_power_pins and define_data['file_prefix']+' dut' in line:
                    for p in pp:
                        line = line.replace(f'.{p}({p}),','')
                        line = line.replace(f'.{p}({p}))',')')
                prvline = line    
                ttb.write(line)

    # generate vpp code and vcd recording
    if subprocess.call(['iverilog', '-o', vppfile, tmptestbed], cwd=cellpath):
      raise ChildProcessError("Icarus Verilog compilation failed")
    if subprocess.call(['vvp', vppfile], cwd=cellpath):
      raise ChildProcessError("Icarus Verilog runtime failed")

    # remove temporary files
    os.remove(tmptestbed)
    os.remove(vppfile)


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
        write_vcd(cellpath, define_data, use_power_pins = False)
        write_vcd(cellpath, define_data, use_power_pins = True)

    return


def main():
    ''' Generates VCD waveform for cell.'''

    prereq_txt = ''
    output_txt = 'output:\n  generates [fullcellname].vcd'
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

