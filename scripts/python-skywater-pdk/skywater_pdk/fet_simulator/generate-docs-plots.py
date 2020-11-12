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
from pathlib import Path

from fet_simulator import generate_fet_plots

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        'fd_pr_dir',
        help='Path to the particular version of the primitive library',
        type=Path
    )
    parser.add_argument(
        'device_details_dir',
        help='Path to the directory with device details to save images to',
        type=Path
    )

    args = parser.parse_args()

    typicalcorner = args.fd_pr_dir / 'models/corners/tt.spice'

    fets = [
        ['esd_nfet', 'esd_nfet_01v8', None],
        ['nfet_01v8', 'nfet_01v8', None],
        ['nfet_01v8_lvt', 'nfet_01v8_lvt', None],
        ['nfet_03v3_nvt', 'nfet_03v3_nvt', None],
        ['nfet_03v3_nvt-and-nfet_05v0_nvt', 'nfet_05v0_nvt', None],
        ['nfet_03v3_nvt-and-nfet_05v0_nvt', 'nfet_03v3_nvt', None],
        ['nfet_05v0_nvt', 'nfet_05v0_nvt', None],
        # ['nfet_20v0'], TODO provide
        # ['nfet_20v0_iso', 'nfet_20v0_nvt_iso', None], TODO invalid bins.csv file
        # ['nfet_20v0_nvt', 'nfet_20v0_nvt', None], TODO invalid bins.csv file
        # ['nfet_20v0_zvt', 'nfet_20v0_zvt', None], TODO invalid bins.csv file
        # ['nfet_g11v0d16v0'], TODO provide
        ['nfet_g5v0d10v5', 'nfet_g5v0d10v5', None],
        ['pfet_01v8', 'pfet_01v8', None],
        ['pfet_01v8_hvt', 'pfet_01v8_hvt', None],
        ['pfet_01v8_lvt', 'pfet_01v8_lvt', None],
        # ['pfet_20v0', 'pfet_20v0', None], TODO some plot issues
        ['pfet_g5v0d10v5', 'pfet_g5v0d10v5', None],
        # ['pfet_g5v0d16v0', 'pfet_g5v0d16v0', None] TODO invalid bins.csv file
    ]

    for outdir, fetname, onlyw in fets:
        generate_fet_plots(
            f'sky130_fd_pr__{fetname}',
            typicalcorner,
            args.fd_pr_dir / f'cells/{fetname}/sky130_fd_pr__{fetname}.bins.csv',
            args.device_details_dir / outdir,
            f'sim_{fetname}_',
            onlyw
        )
