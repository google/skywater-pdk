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

# The top directory where environment will be created.
DOCS_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
TOP_DIR := $(realpath $(DOCS_DIR)/..)

# A pip `requirements.txt` file.
# https://pip.pypa.io/en/stable/reference/pip_install/#requirements-file-format
REQUIREMENTS_FILE := requirements.txt

# A conda `environment.yml` file.
# https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html
ENVIRONMENT_FILE := environment.yml

$(TOP_DIR)/third_party/make-env/conda.mk: $(TOP_DIR)/.gitmodules
	cd $(TOP_DIR); git submodule update --init third_party/make-env

-include $(TOP_DIR)/third_party/make-env/conda.mk

SHELL = /bin/bash

EXP_OPEN := $$((
EXP_CLOSE := ))
CPU_CORES := $(shell nproc)
CPU_CORES_2 := $(shell echo $(EXP_OPEN) $(CPU_CORES) * 2 $(EXP_CLOSE))

SPHINXOPTS      = -j $(CPU_CORES_2)
SPHINXBUILD     = $(IN_CONDA_ENV) sphinx-build
SPHINXAUTOBUILD = $(IN_CONDA_ENV) sphinx-autobuild
SPHINXPROJ      = SkyWaterPDK
SOURCEDIR       = $(DOCS_DIR)
BUILDDIR        = $(DOCS_DIR)/_build

# Put it first so that "make" without argument is like "make help".
help: | $(CONDA_ENV_PYTHON)
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# Vim makes a '4913' file for file system checking. Seriously.
livehtml: | $(CONDA_ENV_PYTHON)
	@$(SPHINXAUTOBUILD) \
		-b html \
		--delay 5 \
		\
		--ignore \*.swp \
		--ignore \*~ \
		--ignore env \
		--ignore _build \
        	--ignore .git \
        	--ignore */4913 \
		\
		$(SPHINXOPTS) \
		"$(SOURCEDIR)" \
		"$(BUILDDIR)/html"

.PHONY: help livehtml Makefile

# Generate the rules/periphery-rules.rst from CSV files in rules/periphery/
$(wildcard rules/periphery/*): | $(CONDA_ENV_PYTHON)
	true

rules/periphery-rules.rst: $(wildcard rules/periphery/*) | $(CONDA_ENV_PYTHON)
	$(IN_CONDA_ENV) cd rules/periphery; ./periphery-split-csv.py > /dev/null

rules/device-details.rst: rules/device-details.py $(wildcard rules/device-details/*/index.rst) | $(CONDA_ENV_PYTHON)
	$(IN_CONDA_ENV) cd rules; ./device-details.py > $(abspath $@)

# Various automated fixups that can be run
fixup:
	# Make sure it is SkyWater
	find ../ -type f -name \*.rst -exec sed -i 's/Skywater/SkyWater/gi' \{\} \+
	# Strip trailing space
	find ../ -type f -name \*.rst -exec sed -i 's/ \+$$//' \{\} \+
	# Make sure all library names have the :lib: role.
	find ../ -type f -name \*.rst -exec sed -i -e'/:name:.*/!s/\(:lib:\)\?`\?\(sky130_[a-z0-9]\+_[a-z0-9]\+\(_[a-z0-9]\+\)\?\)`\?\(\s\|$$\)/:lib:`\2`\4/g' \{\} \+

.PHONY: fixup

echo: | $(CONDA_ENV_PYTHON)
	@echo '$(SPHINXBUILD) -M XXXX "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)'

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
.DEFAULT: | $(CONDA_ENV_PYTHON)
	@make env
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)


clean:: clean-docs


clean-docs:
	rm -rf _build
