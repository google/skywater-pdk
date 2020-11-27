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

verbose = False

# using a list-table here to allow for easier line breaks in description
rst_header_line_char = '-'
rst_header = 'Cells in libraries cross-index'
rst_template ="""\
{header_line}
{header_underline}

.. list-table::
   :header-rows: 1

   * - Cell name
     - {lib_suffixes}
     - Number of libraries
{cell_list}
"""

cell_template = """\
   * - {cell_name}
     - {lib_suffixes_match}
     - {lib_count}
"""

tab_entry = '\n     - '

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
        define_data = json.load(open(p))
        if not define_data['type'] == 'cell':
            continue
        cells.add(p)
        if libname is None:
            libname = define_data['library']

    cells = list(sorted(cells))
    if not len(cells):
        raise FileNotFoundError("No cell definitions found")
    assert len(libname) > 0
    return libname, cells

def get_cell_names(cells):
    """Get cell names from definition filess

    Parameters
    ----------
    cells: list of pathlib.Path
        List of paths to JSON description files

    Returns
    -------
    cell_list: list of str
        List of cell names
    """

    cell_list = []

    for cell in cells:
        with open(str(cell), "r") as c:
            cell_json = json.load(c)
            cell_list.append( cell_json['name'] )
    return cell_list


def generate_crosstable (cells_lib, link_template=''):
    """Generate the RST paragraph containing cell cross reference table

    Parameters:
        cells_lib: dictionary with list of libraries per cell name [dict]
        link_template: cell README generic path (with {lib} and {cell} tags) [str]

    Returns:
        paragraph: Generated paragraph [str]

    """

    assert isinstance (cells_lib, dict)

    paragraph = ""
    cell_list = ""

    lib_suffixes = set()
    for v in cells_lib.values():
        lib_suffixes.update( [lib.rpartition('_')[2] for lib in v] )
    lib_suffixes = list(lib_suffixes)
    lib_suffixes.sort()
    #print (lib_suffixes)

    for c in sorted(cells_lib):
        ls = {} # dictionary of cell library shorts (suffixes)
        for lib in cells_lib[c]:
            ls [lib.rpartition('_')[2]] = lib
        mark = ' :doc:`x <' + link_template + '>`'  # lib match mark with link
        suff_match = [ mark.format(cell=c,lib=ls[s]) if s in ls else '' for s in lib_suffixes ]
        cell_list += cell_template.format(
            cell_name = c,
            lib_suffixes_match = tab_entry.join(suff_match),
            lib_count = str (len(ls))
        )

    paragraph = rst_template.format(
                header_line = rst_header,
                header_underline = rst_header_line_char * len(rst_header),
                lib_suffixes = tab_entry.join(lib_suffixes),
                cell_list = cell_list
            )
    return paragraph


def cells_in_libs (libpaths):
    """Generate the RST paragraph containing cell cross reference table

    Parameters:
        libpaths: list of cell library paths [list of pathlib.Path]

    Returns:
        cells_lib: dictionary with list of libraries containing each cell name [dict]
    """

    lib_dirs = [pathlib.Path(d) for d in libpaths]
    lib_dirs = [d for d in lib_dirs if d.is_dir()]
    libs_toc = dict()

    for lib in lib_dirs:
        try:
            libname, cells = collect(lib)
            if verbose:
                print(f"{lib} \tLibrary name: {libname}, found {len(cells)} cells")
            libs_toc[libname] = get_cell_names(cells)
        except FileNotFoundError:
            if verbose:
                print (f'{lib} \t- no cells found') 

    all_cells = set()
    cells_lib = {}
    for lib,cells in libs_toc.items():
        all_cells.update(set(cells))
        for c in cells:
            cells_lib[c]  = cells_lib.get(c, []) + [lib]

    return cells_lib



# --- Sphinx extension wrapper ---

class CellCrossIndex(Directive):

    required_arguments = 1
    optional_arguments = 1
    has_content = True

    def run(self):
        env = self.state.document.settings.env
        dirname = env.docname.rpartition('/')[0]
        arg = self.arguments[0]
        arg = dirname + '/' + arg
        output = dirname + '/' + self.arguments[1] if len(self.arguments)>2 else None

        path = pathlib.Path(arg).expanduser()
        parts = path.parts[1:] if path.is_absolute() else path.parts
        paths = pathlib.Path(path.root).glob(str(pathlib.Path("").joinpath(*parts)))
        paths = list(paths)    
        paths = [d.resolve() for d in paths if d.is_dir()]

        cells_lib = cells_in_libs ( list(paths) )
        celllink = self.arguments[0].replace('*','{lib}') + '/cells/{cell}/README'
        paragraph = generate_crosstable (cells_lib,celllink)

        if output is None: #  dynamic output
            # parse rst string to docutils nodes
            rst = ViewList()
            for i,line in enumerate(paragraph.split('\n')):
                rst.append(line, "cell-index-tmp.rst", i+1) 
            node = nodes.section()
            node.document = self.state.document
            nested_parse_with_titles(self.state, rst, node)
            return node.children
        else: # file output
             if not output.endswith('.rst'):
                output += '.rst'
             with open(str(output),'w') as f:
                f.write(paragraph)           
             paragraph_node = nodes.paragraph()
             return [paragraph_node]

def setup(app):
    app.add_directive("cross_index", CellCrossIndex)

    return {
        'version': '0.1',
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }

# --- stand alone, command line operation ---

def main():
    global verbose
    parser = argparse.ArgumentParser()
    alllibpath = '../../../libraries/*/latest'
    celllink = 'libraries/{lib}/cells/{cell}/README'

    parser.add_argument(
            "-v", 
            "--verbose", 
            help="increase verbosity", 
            action="store_true"
            )
    parser.add_argument(
            "--all_libs",
            help="process all libs in "+alllibpath,
            action="store_true")
    parser.add_argument(
            "libraries_dirs",
            help="Paths to the library directories. Eg. " + alllibpath,
            type=pathlib.Path,
            nargs="*")
    parser.add_argument(
            "-o",
            "--outfile",
            help="Output file name", 
            type=pathlib.Path,
            default=pathlib.Path('./cell-index.rst'))
    parser.add_argument(
            "-c",
            "--celllink",
            help="Specify cell link template. Default: '" + celllink +"'", 
            type=str,
            default=celllink)

    args = parser.parse_args()
    verbose = args.verbose

    if args.all_libs:
        path = pathlib.Path(alllibpath).expanduser()
        parts = path.parts[1:] if path.is_absolute() else path.parts
        paths = pathlib.Path(path.root).glob(str(pathlib.Path("").joinpath(*parts)))
        args.libraries_dirs = list(paths)


    cells_lib = cells_in_libs (args.libraries_dirs)
    par = generate_crosstable (cells_lib,args.celllink)

    with open(str(args.outfile),'w') as f:
        f.write(par)


if __name__ == "__main__":
    sys.exit(main())
