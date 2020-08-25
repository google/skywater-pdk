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
    """Generate the RST file containing basic information about cells

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
    path: str
        Path to generated file
    """

    if not isinstance(library_dir, pathlib.Path):
        library_dir = pathlib.Path(library_dir)

    file_name = "cell-list.rst"
    cell_list_file = pathlib.Path(library_dir, file_name)
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
    try:
        with(open(str(cell_list_file), "w")) as c:
            c.write(rst_template.format(
                header_line = header,
                header_underline = rst_header_line_char * len(header),
                cell_list = cell_list
            ))
    except FileNotFoundError:
        print(f"ERROR: Failed to create {str(cell_list_file)}", file=sys.stderr)
        raise

    return cell_list_file


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
            "library_dir",
            help="Path to the library.",
            type=pathlib.Path,
            nargs=1)

    args = parser.parse_args()
    lib = args.library_dir[0]

    print(f"Analysing {lib}")
    libname, cells = collect(lib)
    print(f"Library name: {libname}, found {len(cells)} cells")
    file = generate_rst(lib, libname, cells)
    print(f'Generated {file}')


if __name__ == "__main__":
    sys.exit(main())

