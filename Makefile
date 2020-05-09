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

include scripts/make/git.mk
include scripts/make/conda.mk

.DEFAULT_GOAL := all

README.rst: README.src.rst docs/status.rst Makefile | $(CONDA_ENV_PYTHON)
	@rm -f README.rst
	$(IN_CONDA_ENV) rst_include include --source README.src.rst \
		| sed \
			-e's@|TAG_VERSION|@$(TAG_VERSION)@g' \
			-e's@:ref:`Versioning Information`@`Versioning Information <docs/versioning.rst>`_@g' \
			-e's@:ref:`Known Issues`@`Versioning Information <docs/known_issues.rst>`_@g' \
			-e's@.. warning::@*Warning*@g' \
		> README.rst


all: README.rst
	@true

.PHONY: all
