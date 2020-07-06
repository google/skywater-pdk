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
			-e's@:ref:`Known Issues`@`Known Issues <docs/known_issues.rst>`_@g' \
			-e's@.. warning::@*Warning*@g' \
		> README.rst


COPYRIGHT_HOLDER := SkyWater PDK Authors
FIND := find . -path ./env -prune -o -path ./.git -prune -o
ADDLICENSE := addlicense -f ./docs/license_header.txt
fix-licenses:
	@# Makefiles
	@$(FIND) -type f -name Makefile -exec $(ADDLICENSE) $(ADDLICENSE_EXTRA) -v \{\} \+
	@$(FIND) -type f -name \*.mk -exec $(ADDLICENSE) $(ADDLICENSE_EXTRA) -v \{\} \+
	@# Scripting files
	@$(FIND) -type f -name \*.sh -exec $(ADDLICENSE) $(ADDLICENSE_EXTRA) -v \{\} \+
	@$(FIND) -type f -name \*.py -exec $(ADDLICENSE) $(ADDLICENSE_EXTRA) -v \{\} \+
	@# Configuration files
	@$(FIND) -type f -name \*.yml  -exec $(ADDLICENSE) $(ADDLICENSE_EXTRA) -v \{\} \+
	@# Actual PDK files
	@$(FIND) -type f -name \*.v  -exec $(ADDLICENSE) $(ADDLICENSE_EXTRA) -v \{\} \+

.PHONY: fix-licenses

check-licenses:
	@make --no-print-directory ADDLICENSE_EXTRA=--check fix-licenses

.PHONY: check-licenses


check: check-licenses
	@true

all: README.rst
	@true


LIBRARIES = $(sort $(notdir $(wildcard libraries/sky130_*_sc_*)))

$(LIBRARIES): | $(CONDA_ENV_PYTHON)
	@$(IN_CONDA_ENV) for V in libraries/$@/*; do \
		python -m skywater_pdk.liberty $$V; \
		python -m skywater_pdk.liberty $$V all; \
		python -m skywater_pdk.liberty $$V all --ccsnoise; \
	done

sky130_fd_sc_ms-leakage: | $(CONDA_ENV_PYTHON)
	 @$(IN_CONDA_ENV) for V in libraries/sky130_fd_sc_ms/*; do \
		python -m skywater_pdk.liberty $$V all --leakage; \
	done

sky130_fd_sc_ms: sky130_fd_sc_ms-leakage

timing: $(LIBRARIES) | $(CONDA_ENV_PYTHON)
	@true


.PHONY: all
