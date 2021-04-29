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

FULL_VERSION := $(shell git describe --long)
TAG_VERSION  := $(firstword $(subst -, ,$(FULL_VERSION)))

SUBMODULE_VERSION ?= latest

ifeq (,$(FULL_VERSION))
$(error "Version value could not be determined. Make sure you fetch the tags.")
endif

LIBRARIES = $(sort $(notdir $(wildcard libraries/sky130_*)))

LIBS_DOT_GIT = $(addsuffix /$(SUBMODULE_VERSION)/.git,$(addprefix libraries/,$(LIBRARIES)))

libraries-info:
	@echo "The following libraries exist:"
	@for L in $(LIBRARIES); do \
		LD=libraries/$$L/$(SUBMODULE_VERSION); \
		echo " * $$L"; \
		echo "    $$(git submodule status $$LD)"; \
	done
	@echo $(LIBS_DOT_GIT)

submodules: $(LIBS_DOT_GIT)

define LIB_template
libraries/$(1)/%/.git: .gitmodules
	git submodule update --init $$(@D)
endef

$(foreach lib,$(LIBRARIES), $(eval $(call LIB_template,$(lib))))
