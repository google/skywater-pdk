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
import os
import argparse
from pathlib import Path
import pandas as pd
import errno
from jinja2 import Template
import importlib.resources as resources

sys.path.insert(0, os.path.abspath(__file__ + '../'))

from skywater_pdk import templates


def parse_entries(filepath, sheet_name, cols=None):
    """
    Loads resources from spreadsheet to pandas frames.

    Parameters
    ----------
    filepath:
        path or URL to spreadsheet file (ODS requires odfpy package, XLSX
        requires xlrd package)
    sheet_name: name of the sheet to extract data from
    cols: range of columns to extract from the sheet
    """
    values = pd.read_excel(
        filepath,
        sheet_name=sheet_name,
        header=0,
        usecols=cols
    )
    values = values.where(values.notnull(), None)
    return values


def main(argv):
    parser = argparse.ArgumentParser(prog=argv[0])
    parser.add_argument(
        'output',
        help='The path to output RST file',
        type=Path
    )
    parser.add_argument(
        '--spreadsheet-file',
        help='The path to input spreadsheet file',
        type=Path
    )
    parser.add_argument(
        '--google-spreadsheet-id',
        help='Google Spreadsheet ID of the document to process',
        action='store_true'
    )

    args = parser.parse_args(argv[1:])

    input_file = None
    if args.spreadsheet_file:
        input_file = args.spreadsheet_file
    if args.google_spreadsheet_id:
        input_file = f'https://docs.google.com/spreadsheets/d/{args.google_spreadsheet_id}/export?format=ods'  # noqa: E501

    if input_file is None:
        print('Input file is not provided')
        return errno.ENOENT

    news_articles = parse_entries(input_file, 'News Articles')
    talk_series = parse_entries(input_file, 'Talk Series')
    conferences = parse_entries(input_file, 'Conferences')
    linkedin = parse_entries(input_file, 'LinkedIn Posts')
    courses = parse_entries(input_file, 'Courses')

    with resources.path(templates, 'resources.template.rst') as resourcepath:
        with open(resourcepath, 'r') as resourcetemplate:
            resources_rst_template = resourcetemplate.read()

            tm = Template(resources_rst_template)
            resources_rst_content = tm.render(
                news_articles=news_articles,
                talk_series=talk_series,
                conferences=conferences,
                linkedin=linkedin,
                courses=courses
            )

            with open(args.output, 'w') as out:
                out.write(resources_rst_content)

    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
