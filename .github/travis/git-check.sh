#!/usr/bin/env bash
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

set -e

source .github/travis/common.sh

# Output any changes in the repository
# ------------------------------------------------------------------------
start_section git-status "Current git status"

git diff

$SPACER

git status

end_section git-status

# Check there are not changes in the repository
# ------------------------------------------------------------------------
start_section git-check "Checking git repository isn't dirty"

(
	. "$(git --exec-path)/git-sh-setup"

	require_clean_work_tree "continue" "Please include the changes in your commits."
)

end_section git-check
