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

"""
A module for altering diagrams and image files using Inkscape and other tools.
"""

import subprocess


def run_inkscape(args, retries=1, inkscape_executable='inkscape') -> int:
    """
    Runs Inkscape for given arguments.

    Parameters
    ----------
    args : List[str]
        List of arguments to provide to Inkscape
    retries : int
        Number of tries to run Inkscape with given arguments

    Returns
    Union[List[int], int] : error codes for Inkscape runs
    """
    returncodes = []
    for i in range(retries):
        p = subprocess.Popen([inkscape_executable] + args)
        try:
            p.wait(timeout=60)
        except subprocess.TimeoutExpired:
            print("ERROR: Inkscape timed out! Sending SIGTERM")
            p.terminate()
            try:
                p.wait(timeout=60)
            except subprocess.TimeoutExpired:
                print("ERROR: Inkscape timed out! Sending SIGKILL")
                p.kill()
            p.wait()
        if retries == 1:
            return p.returncode
        returncodes.append(p.returncode)
        if p.returncode == 0:
            break
    return returncodes
