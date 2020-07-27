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

submodules: libraries/sky130_fd_sc_hd/$(SUBMODULE_VERSION)/.git libraries/sky130_fd_sc_hdll/$(SUBMODULE_VERSION)/.git libraries/sky130_fd_sc_hs/$(SUBMODULE_VERSION)/.git libraries/sky130_fd_sc_ms/$(SUBMODULE_VERSION)/.git libraries/sky130_fd_sc_ls/$(SUBMODULE_VERSION)/.git

libraries/sky130_fd_sc_hd/%/.git: .gitmodules
	git submodule update --init $(@D)

libraries/sky130_fd_sc_hdll/%/.git: .gitmodules
	git submodule update --init $(@D)

libraries/sky130_fd_sc_hs/%/.git: .gitmodules
	git submodule update --init $(@D)

libraries/sky130_fd_sc_ms/%/.git: .gitmodules
	git submodule update --init $(@D)

libraries/sky130_fd_sc_ls/%/.git: .gitmodules
	git submodule update --init $(@D)
