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


# prerequisities:   netlistsvg
# input:            paths to cell dirs, containing Yosys netlist 
# output:           generates [cell_prefix].schematic.svg
# example usage 1:  ./netlistsvg-generate.py \
#                   ../../../libraries/sky130_fd_sc_ms/latest/cells/a2111o \
#                   ../../../libraries/sky130_fd_sc_ms/latest/cells/a2111oi
# example usage 2:  ./netlistsvg-generate.py ALLLIBS

def outfile(cellpath, define_data, ftype='', extra='', exists=False):
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
    netlist_json = os.path.join(cellpath, define_data['file_prefix']+'.json')
    if not os.path.exists(netlist_json):
        print("No " + define_data['file_prefix'] + ".json in", cellpath)
    assert os.path.exists(netlist_json), netlist_json
    outpath = outfile(cellpath, define_data, 'schematic')
    oscmd = 'netlistsvg ' + netlist_json + ' -o ' + outpath
    r = os.system(oscmd)>>8
    assert r == 0
    return r 


def process(cellpath):
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


def main(args):
    if len(args) and args[0] == 'ALLLIBS':
        scrpath = os.path.dirname(os.path.realpath(__file__))
        relpath = '/../../../libraries/*/latest/cells/*'
        #relpath = '/../../../libraries/*ms/latest/cells/x*' # DBG: limited
        args = os.popen('ls -d ' + scrpath + relpath).read().strip().split('\n')
    errors = 0
    for a in args:
        try:
            process(os.path.realpath(a))
        except:
            errors +=1
    print (f'\n{len(args)} files processed, {errors} errors.') 

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

