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
from docutils import nodes
from docutils.parsers.rst import Directive
from docutils.statemachine import ViewList
from sphinx.util.nodes import nested_parse_with_titles

verbose = False

readme_template ="""\
{header}

**{description}**

*This is a stub of cell description file*

-  **Cell name**: {name}
-  **Type**: {deftype}
-  **Verilog name**: {verilog_name}
-  **Library**: {library}
-  **Inputs**:  {inputs}
-  **Outputs**: {outputs}

{subheader_sym}

.. list-table:: 

    * - .. figure:: {symbol1}
      -
      - .. figure:: {symbol2}

{subheader_sch}

.. figure:: {schematic}
    :align: center

{subheader_gds}

"""

figure_template ="""

.. figure:: {fig}
    :align: center
    :width: 50%

    {name}
"""

def write_readme(cellpath, define_data):
    ''' Generates README for a given cell.

    Args:
        cellpath - path to a cell [str of pathlib.Path]
        define_data - cell data from json [dic]

    '''
    outpath = os.path.join(cellpath, 'README.rst')
    prefix = define_data['file_prefix'] 
    header = f':cell:`{prefix}`'
    subheader_sym = header + ' symbols'
    subheader_sch = header + ' schematic'
    subheader_gds = header + ' GDSII layouts'

    header += '\n' + '=' * len(header)
    subheader_sym += '\n' + '-' * len(subheader_sym)
    subheader_sch += '\n' + '-' * len(subheader_sch)
    subheader_gds += '\n' + '-' * len(subheader_gds)


    symbol1 = prefix + '.symbol.svg'
    symbol2 = prefix + '.pp.symbol.svg'
    schematic = prefix + '.schematic.svg'
    inputs = []
    outputs = []
    for p in define_data['ports']:
        try:
            if p[0]=='signal' and p[2]=='input':
                inputs.append(p[1])
            if p[0]=='signal' and p[2]=='output':
                outputs.append(p[1])
        except: 
            pass
    gdssvg = []       
    svglist = list(pathlib.Path(cellpath).glob('*.svg'))
    for s in svglist:
        gdsfile = pathlib.Path(os.path.join(cellpath, s.stem +'.gds'))
        if gdsfile.is_file():
            gdssvg.append(s)

    with open(outpath, 'w') as f:
        f.write (readme_template.format (
            header = header,
            subheader_sym = subheader_sym,
            subheader_sch = subheader_sch,
            subheader_gds = subheader_gds,
            description = define_data['description'].rstrip('.'),
            name = ':cell:`' + prefix +'`',
            deftype = define_data['type'],
            verilog_name = define_data['verilog_name'],
            library = define_data['library'],
            inputs  = f'{len(inputs)} ('  + ', '.join(inputs) + ')',
            outputs = f'{len(outputs)} (' + ', '.join(outputs) + ')',
            symbol1 = symbol1,
            symbol2 = symbol2,
            schematic = schematic,
        ))
        for gs in sorted(gdssvg):
            f.write (figure_template.format (
                fig  = gs.name,
                name = gs.stem
        ))

def process(cellpath):
    ''' Processes cell indicated by path.
        Opens cell definiton and calls further processing

    Args:
        cellpath - path to a cell [str of pathlib.Path]
    '''
    if verbose:
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

# --- Sphinx extension wrapper ----------------

def GenerateCellReadme (app, cellpath):

        print (f'GenerateCellReadme: generating files for {cellpath}')
        path = pathlib.Path(cellpath).expanduser()
        parts = path.parts[1:] if path.is_absolute() else path.parts
        paths = pathlib.Path(path.root).glob(str(pathlib.Path("").joinpath(*parts)))
        paths = list(paths)    
        cell_dirs = [d.resolve() for d in paths if d.is_dir()]

        errors = 0
        for d in cell_dirs:
            try:
                process(d)
            except (AssertionError, FileNotFoundError, ChildProcessError) as ex:
                print (f'GenerateCellReadme: {type(ex).__name__}')
                print (f'{ex.args}')
                errors +=1
        print (f'GenerateCellReadme: {len(cell_dirs)} files processed, {errors} errors.')

def setup(app):
    app.add_event("cells_generate_readme")
    app.connect('cells_generate_readme', GenerateCellReadme)

    return {
        'version': '0.1',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
           }

# ----------------------------------------------      

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

