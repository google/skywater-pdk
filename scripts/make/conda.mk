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


SHELL := /bin/bash

UNAME_S := $(shell uname -s)
ifneq (, $(findstring Linux, $(UNAME_S)))
        OSFLAG := Linux
endif
ifeq ($(UNAME_S), Darwin)
        OSFLAG := MacOSX
endif
ifneq (, $(findstring Cygwin, $(UNAME_S)))
        OSFLAG := Linux
endif
ifneq (, $(findstring MINGW, $(UNAME_S)))
        OSFLAG := Linux
endif

MAKE_DIR          := $(dir $(lastword $(MAKEFILE_LIST)))
TOP_DIR           := $(realpath $(MAKE_DIR)/../..)
ENV_DIR           := $(TOP_DIR)/env
REQUIREMENTS_FILE := $(TOP_DIR)/requirements.txt
ENVIRONMENT_FILE  := $(TOP_DIR)/environment.yml

CONDA_DIR         := $(ENV_DIR)/conda
DOWNLOADS_DIR     := $(ENV_DIR)/downloads
CONDA_PYTHON      := $(CONDA_DIR)/bin/python
CONDA_PKGS_DIR    := $(DOWNLOADS_DIR)/conda-pkgs
CONDA_PKGS_DEP    := $(CONDA_PKGS_DIR)/urls.txt
CONDA_ENV_NAME    := skywater-pdk-scripts
CONDA_ENV_PYTHON  := $(CONDA_DIR)/envs/$(CONDA_ENV_NAME)/bin/python
IN_CONDA_ENV_BASE := source $(CONDA_DIR)/bin/activate &&
IN_CONDA_ENV      := $(IN_CONDA_ENV_BASE) conda activate $(CONDA_ENV_NAME) &&

$(ENV_DIR): | $(DOWNLOADS_DIR)
	mkdir -p $(END_DIR)

$(DOWNLOADS_DIR):
	mkdir -p $(DOWNLOADS_DIR)

$(DOWNLOADS_DIR)/Miniconda3-latest-$(OSFLAG)-x86_64.sh: | $(DOWNLOADS_DIR)
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-$(OSFLAG)-x86_64.sh -O $(DOWNLOADS_DIR)/Miniconda3-latest-$(OSFLAG)-x86_64.sh
	chmod a+x $(DOWNLOADS_DIR)/Miniconda3-latest-$(OSFLAG)-x86_64.sh

$(CONDA_PKGS_DEP): $(CONDA_PYTHON)
	$(IN_CONDA_ENV_BASE) conda config --system --add pkgs_dirs $(CONDA_PKGS_DIR)

$(CONDA_PYTHON): $(DOWNLOADS_DIR)/Miniconda3-latest-$(OSFLAG)-x86_64.sh
	$(DOWNLOADS_DIR)/Miniconda3-latest-$(OSFLAG)-x86_64.sh -p $(CONDA_DIR) -b -f
	touch $(CONDA_PYTHON)

$(CONDA_DIR)/envs: $(CONDA_PYTHON)
	$(IN_CONDA_ENV_BASE) conda config --system --add envs_dirs $(CONDA_DIR)/envs

$(CONDA_ENV_PYTHON): $(ENVIRONMENT_FILE) $(REQUIREMENTS_FILE) | $(CONDA_PYTHON) $(CONDA_DIR)/envs $(CONDA_PKGS_DEP)
	$(IN_CONDA_ENV_BASE) conda env update --name $(CONDA_ENV_NAME) --file $(ENVIRONMENT_FILE)
	touch $(CONDA_ENV_PYTHON)

env:: $(CONDA_ENV_PYTHON)
	$(IN_CONDA_ENV) conda info

.PHONY: env

enter: $(CONDA_ENV_PYTHON)
	$(IN_CONDA_ENV) bash

.PHONY: enter

clean::
	rm -rf env/conda

.PHONY: clean

dist-clean::
	rm -rf conda

.PHONY: dist-clean


FILTER_TOP = sed -e's@$(TOP_DIR)/@$$TOP_DIR/@'
env-info:
	@echo "             Top level directory is: '$(TOP_DIR)'"
	@echo "              The version number is: '$$(git describe)'"
	@echo "            Git repository is using: $$(du -h -s $(TOP_DIR)/.git | sed -e's/\s.*//')" \
		| $(FILTER_TOP)
	@echo
	@echo "     Environment setup directory is: '$(ENV_DIR)'" \
		| $(FILTER_TOP)
	@echo "    Download and cache directory is: '$(DOWNLOADS_DIR)' (using $$(du -h -s $(DOWNLOADS_DIR) | sed -e's/\s.*//'))" \
		| $(FILTER_TOP)
	@echo "               Conda's directory is: '$(CONDA_DIR)' (using $$(du -h -s $(CONDA_DIR) | sed -e's/\s.*//'))" \
		| $(FILTER_TOP)
	@echo " Conda's packages download cache is: '$(CONDA_PKGS_DIR)' (using $$(du -h -s $(CONDA_PKGS_DIR) | sed -e's/\s.*//'))" \
		| $(FILTER_TOP)
	@echo "           Conda's Python binary is: '$(CONDA_ENV_PYTHON)'"\
		| $(FILTER_TOP)


.PHONY: info
