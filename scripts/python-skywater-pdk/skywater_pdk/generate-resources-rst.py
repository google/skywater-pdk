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

import os
import sys
import pickle
import argparse
from pathlib import Path
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import pandas as pd

SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly']

SAMPLE_SPREADSHEET_ID = '1tOU0N0qMeDFjTz9NrGz_-PBikgu2x2gDHezy2SlE9dA'


def parse_news_articles(sheet):
    DATA = 'News Articles!B2:D'
    result = sheet.values().get(
        spreadsheetId=SAMPLE_SPREADSHEET_ID,
        range=DATA).execute()
    values = result.get('values', [])
    return pd.DataFrame.from_records(values[1:], columns=values[0])


def parse_talk_series(sheet):
    DATA = 'Talk Series!B2:M'
    result = sheet.values().get(
        spreadsheetId=SAMPLE_SPREADSHEET_ID,
        range=DATA).execute()
    values = result.get('values', [])
    return pd.DataFrame.from_records(values[1:], columns=values[0])


def parse_conferences(sheet):
    DATA = 'Conferences!B2:D'
    result = sheet.values().get(
        spreadsheetId=SAMPLE_SPREADSHEET_ID,
        range=DATA).execute()
    values = result.get('values', [])
    return pd.DataFrame.from_records(values[1:], columns=values[0])


def main(argv):
    parser = argparse.ArgumentParser(prog=argv[0])
    parser.add_argument(
        'output',
        help='The path to output RST file',
        type=Path
    )

    args = parser.parse_args(argv[1:])

    creds = None
    if os.path.exists('token.pickle'):
        with open('token.pickle', 'rb') as token:
            creds = pickle.load(token)
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                'credentials.json',
                SCOPES
            )
            creds = flow.run_local_server(port=0)
        with open('token.pickle', 'wb') as token:
            pickle.dump(creds, token)

    service = build('sheets', 'v4', credentials=creds)

    sheet = service.spreadsheets()

    news_articles = parse_news_articles(sheet)
    talk_series = parse_talk_series(sheet)
    conferences = parse_conferences(sheet)

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
                out.write(f'* `{row["Related link"]} <{row["Related link"]}>`__\n')
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
                linkname = entry["Video"] if entry["Video"] else entry["Video link"]
                out.write(f'**Video**: `{linkname} <entry["Video link"]>`__\n\n')
            if entry["Slides PPTX link"]:
                linkname = entry["Slides PPTX"] if entry["Slides PPTX"] else entry["Slides PPTX link"]
                out.write(f'**Slides**: `{linkname} <entry["Slides PPTX link"]>`__\n\n')
            if entry["Slides PDF link"]:
                linkname = entry["Slides PDF"] if entry["Slides PDF"] else entry["Slides PDF link"]
                out.write(f'**Slides (PDF)**: `{linkname} <entry["Slides PDF link"]>`__\n\n')
            out.write('\n')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
