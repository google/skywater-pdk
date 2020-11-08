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

echo
echo "========================================"
echo "Host Environment"
echo "----------------------------------------"
export
echo "----------------------------------------"

echo
echo "========================================"
echo "Host CPU"
echo "----------------------------------------"
export CORES=$(nproc --all)
echo "Cores: $CORES"
echo
echo "Memory"
echo "----------------------------------------"
cat /proc/meminfo
echo "----------------------------------------"
export MEM_GB=$(($(awk '/MemTotal/ {print $2}' /proc/meminfo)/(1024*1024)))
echo "Memory (GB): $CORES"
export MEM_CORES=$(($MEM_GB/4))

echo
echo "========================================"
echo "Package version"
echo "----------------------------------------"
set -x
gcc --version
set +x
echo "----------------------------------------"
