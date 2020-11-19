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
import json
import os
import pathlib
import pprint
import sys
import textwrap
from docutils import nodes
from docutils.parsers.rst import Directive
from docutils.statemachine import ViewList
from sphinx.util.nodes import nested_parse_with_titles

from typing import Tuple, List, Dict

# using a list-table here to allow for easier line breaks in description
rst_header_line_char = '-'
rst_header = 'List of cells in :lib:`{libname}`'
rst_template ="""\
{header_line}
{header_underline}

.. list-table::
   :header-rows: 1

   * - Cell name
     - Description
     - Type
     - Verilog name
{cell_list}
"""


cell_template = """\
   * - {cell_name}
     - {description}
     - {type}
     - {verilog_name}
"""


def collect(library_dir) -> Tuple[str, List[str]]:
    """Collect the available definitions for cells in a library

    Parameters
    ----------
    library_dir: str or pathlib.Path
        Path to a library.

    Returns
    -------
    lib : str
        Library name

    cells : list of pathlib.Path
        definition files for cells in the library.
    """

    if not isinstance(library_dir, pathlib.Path):
        library_dir = pathlib.Path(library_dir)

    libname = None
    cells = set()

    for p in library_dir.rglob("definition.json"):
        if not p.is_file():
            continue
        cells.add(p)
        if libname is None:
            with open(str(p), "r") as sample_json:
                sample_def = json.load(sample_json)
                libname = sample_def['library']

    assert len(libname) > 0
    cells = list(sorted(cells))
    return libname, cells


def generate_rst(library_dir, library_name, cells):
    """Generate the RST paragraph containing basic information about cells

    Parameters
    ----------
    library_dir: str or pathlib.Path
        Path to a library.

    library_name: str
        Name of the library

    cells: list of pathlib.Path
        List of paths to JSON description files

    Returns
    -------
    paragraph: str
        Generated paragraph
    """

    if not isinstance(library_dir, pathlib.Path):
        library_dir = pathlib.Path(library_dir)

    paragraph = ""
    cell_list = ""

    for cell in cells:
        with open(str(cell), "r") as c:
            cell_json = json.load(c)
            cell_list = cell_list + cell_template.format(
                cell_name = cell_json['name'],
                #description = cell_json['description'].replace("\n", "\n       "),
                description = textwrap.indent(cell_json['description'], '       ').lstrip(),
                type = cell_json['type'],
                verilog_name = cell_json['verilog_name']
            )

    header = rst_header.format(libname = library_name)
    paragraph = rst_template.format(
                header_line = header,
                header_underline = rst_header_line_char * len(header),
                cell_list = cell_list
            )
    return paragraph


def AppendToReadme (celllistfile):
    ''' Prototype od lebrary README builder '''
    readmefile = pathlib.Path(celllistfile.parents[0], 'README.rst')
    old = ''
    if readmefile.exists():
        with open(str(readmefile), "r") as f:
           for i, l in enumerate(f):    
            if i<5: old += l

    # get cell readme list
    lscmd = 'ls -1a ' + str(celllistfile.parents[0])+"/cells/*/README.rst 2>/dev/null"
    cellrdm = os.popen(lscmd).read().strip().split('\n')
    cellrdm = [c.replace(str(celllistfile.parents[0])+'/','') for c in cellrdm]

    with open(str(readmefile), "w+") as f:
        f.write(old)
        tableinc = f'.. include:: {celllistfile.name}\n'

        if len(cellrdm):
            f.write('\n\n\n')
            f.write('Cell descriptions\n')
            f.write('-----------------\n\n')
            f.write('.. toctree::\n\n')
            for c in cellrdm: 
                f.write(f'   {c}\n')
            f.write('\n\n\n')          

        if not tableinc in old:
            f.write(tableinc)


# --- Sphinx extension wrapper ---

class CellList(Directive):

    def run(self):
        env = self.state.document.settings.env
        dirname = env.docname.rpartition('/')[0]
        libname, cells = collect(dirname)
        paragraph = generate_rst(dirname, libname, cells)
        # parse rst string to docutils nodes
        rst = ViewList()
        for i,line in enumerate(paragraph.split('\n')):
            rst.append(line, libname+"-cell-list.rst", i+1) 
        node = nodes.section()
        node.document = self.state.document
        nested_parse_with_titles(self.state, rst, node)
        return node.children


def setup(app):
    app.add_directive("cell_list", CellList)

    return {
        'version': '0.1',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }

# --- stand alone, command line operation ---

def main():

    alllibpath = '../../../libraries/*/latest'
    parser = argparse.ArgumentParser()
    parser.add_argument(
            "--all_libs",
            help="process all libs in "+alllibpath,
            action="store_true")
    parser.add_argument(
            "library_dir",
            help="Path to the library.",
            type=pathlib.Path,
            nargs='*')

    args = parser.parse_args()

    if args.all_libs:
        path = pathlib.Path(alllibpath).expanduser()
        parts = path.parts[1:] if path.is_absolute() else path.parts
        paths = pathlib.Path(path.root).glob(str(pathlib.Path("").joinpath(*parts)))
        args.library_dir = list(paths)


    libs = [pathlib.Path(d) for d in args.library_dir]
    libs = [d for d in libs if d.is_dir()]

    for l in libs: print (str(l))

    for lib in libs:

        print(f'\nAnalysing {lib}')
        try:
            libname, cells = collect(lib)
            print(f"Library name: {libname}, found {len(cells)} cells")
            paragraph = generate_rst(lib, libname, cells)
            library_dir = pathlib.Path(lib)
            cell_list_file = pathlib.Path(library_dir, "cell-list.rst")
        except:
            print(f'  ERROR: failed to fetch cell list')
            continue
        try:
            with(open(str(cell_list_file), "w")) as c:
                c.write(paragraph)
            print(f'Generated {cell_list_file}')
            AppendToReadme(cell_list_file)
            print(f'Appended to README')
        except FileNotFoundError:
            print(f"  ERROR: Failed to create {str(cell_list_file)}", file=sys.stderr)
            raise


if __name__ == "__main__":
    sys.exit(main())

