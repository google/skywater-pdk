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
import pandas as pd


def parse_entries(filepath, sheet_name, cols):
    values = pd.read_excel(
        filepath,
        sheet_name=sheet_name,
        header=1,
        usecols=cols
    )
    values = values.where(values.notnull(), None)
    return values


def main(argv):
    parser = argparse.ArgumentParser(prog=argv[0])
    parser.add_argument(
        'input_xlsx',
        help='The path to input XLSX file or GID to Google Spreadsheet',
        type=Path
    )
    parser.add_argument(
        'output',
        help='The path to output RST file',
        type=Path
    )
    parser.add_argument(
        '--input-is-spreadsheet-id',
        help='The input_xlsx argument holds public Google Spreadsheet ID',
        action='store_true'
    )

    args = parser.parse_args(argv[1:])

    if args.input_is_spreadsheet_id:
        args.input_xlsx = f'https://docs.google.com/spreadsheets/d/{args.input_xlsx}/export?format=xlsx'  # noqa: E501

    news_articles = parse_entries(args.input_xlsx, 'News Articles', 'B:D')
    talk_series = parse_entries(args.input_xlsx, 'Talk Series', 'B:M')
    conferences = parse_entries(args.input_xlsx, 'Conferences', 'B:D')
    linkedin = parse_entries(args.input_xlsx, 'LinkedIn Posts', 'B:C')
    courses = parse_entries(args.input_xlsx, 'Courses', 'B:D')

    with open(args.output, 'w') as out:
        out.write('Further Resources\n')
        out.write('=================\n')
        out.write('\n')
        out.write('News Articles\n')
        out.write('-------------\n')
        out.write('\n')
        for _, row in news_articles.iterrows():
            out.write(f'* `{row["Article"]} <{row["Link"]}>`__\n')
        out.write('\n')
        out.write('Conferences\n')
        out.write('-----------\n')
        out.write('\n')
        for _, row in conferences.iterrows():
            if row["Conference"]:
                out.write('\n')
                out.write(f'{row["Conference"]}\n')
                out.write('~' * len(row["Conference"]) + '\n')
                out.write('\n')
            if row["Description"]:
                out.write(f'{row["Description"]}\n')
                out.write('\n')
            if row["Related link"]:
                out.write(
                    f'* `{row["Related link"]} <{row["Related link"]}>`__\n'
                )
        out.write('\n')
        out.write('Talk Series\n')
        out.write('-----------\n')
        out.write('\n')
        for _, entry in talk_series.iterrows():
            if entry["Talk series"]:
                out.write('\n')
                out.write(f'{entry["Talk series"]}\n')
                out.write('~' * len(entry[0]) + '\n')
                out.write('\n')
                if entry["Description"]:
                    out.write(f'{entry["Description"]}')
                    out.write('\n')
                if entry["Page"]:
                    out.write(f'\n**Page**: {entry["Page"]}\n')
            out.write(f'\n{entry["Title"]}\n')
            out.write('^' * len(entry["Title"]) + '\n')
            out.write('\n')
            if entry["Presenter"]:
                out.write(f'**Presenter**: {entry["Presenter"]}\n\n')
            if entry["Talk details"]:
                out.write(f'**Description**: {entry["Talk details"]}\n\n')
            if entry["Video link"]:
                linkname = (entry["Video"] if entry["Video"]
                            else entry["Video link"])
                out.write(
                    f'**Video**: `{linkname} <{entry["Video link"]}>`__\n\n'
                )
            if entry["Slides PPTX link"]:
                linkname = (entry["Slides PPTX"] if entry["Slides PPTX"]
                            else entry["Slides PPTX link"])
                out.write(
                    '**Slides**: ' +
                    f'`{linkname} <{entry["Slides PPTX link"]}>`__\n\n'
                )
            if entry["Slides PDF link"]:
                linkname = (entry["Slides PDF"] if entry["Slides PDF"]
                            else entry["Slides PDF link"])
                out.write(
                    '**Slides (PDF)**: ' +
                    f'`{linkname} <{entry["Slides PDF link"]}>`__\n\n'
                )
            out.write('\n')
        out.write('LinkedIn Posts\n')
        out.write('--------------\n')
        out.write('\n')
        for _, row in linkedin.iterrows():
            out.write(f'* `{row["Title"]} <{row["Link"]}>`__\n')
        out.write('\n')
        out.write('Courses\n')
        out.write('-------\n')
        out.write('\n')
        for _, row in courses.iterrows():
            if row["Course"]:
                out.write('\n')
                out.write(f'{row["Course"]}\n')
                out.write('~' * len(row["Course"]) + '\n')
                out.write('\n')
            if row["Link"]:
                title = row['Link title'] if row['Link title'] else row['Link']
                out.write(
                    f'* `{title} <{row["Link"]}>`__\n'
                )
        out.write('\n')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
