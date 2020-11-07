#!/bin/bash
# -*- coding: utf-8 -*-
#
# Copyright 2020 Regents of the University of California
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

set -e

CALLED=$_
[[ "${BASH_SOURCE[0]}" != "${0}" ]] && SOURCED=1 || SOURCED=0

SCRIPT_SRC="$(realpath ${BASH_SOURCE[0]})"
SCRIPT_DIR="$(dirname "${SCRIPT_SRC}")"

export PATH="/usr/sbin:/usr/bin:/sbin:/bin"

cd github/$KOKORO_DIR

. $SCRIPT_DIR/steps/auth.sh
. $SCRIPT_DIR/steps/git.sh
. $SCRIPT_DIR/steps/hostsetup.sh
. $SCRIPT_DIR/steps/hostinfo.sh

set -e

echo
echo "========================================"
echo "Setting up build environment"
echo "----------------------------------------"
make env
echo "----------------------------------------"

echo
echo "========================================"
echo "Checkout all the submodules"
echo "----------------------------------------"
DOWNLOAD_JOBS=$(($CORES*2))
git submodule update --init --jobs $DOWNLOAD_JOBS

echo
echo "========================================"
echo "Build the timing libraries"
echo "----------------------------------------"
make -j timing
