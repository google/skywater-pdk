LIBRARIES = ../../libraries

SCLIB := sky130_fd_sc_hd
export SCLIB

ROOT = ../..
SCRIPTS = scripts
COMMON_DIR = PlaceRoute/common
mapFileName = skywater130.gds.layers
PLACEROUTE_DIR = PlaceRoute/$(SCLIB)
WORK_DIR = work/$(SCLIB)
LOGS = logs/$(SCLIB)

COMMON_OPTIONS = " \
set ROOT $(ROOT) \n\
set SCLIB $(SCLIB) \n\
set WORK_DIR $(ROOT)/$(WORK_DIR) \n\
set TARGET_LIB_DIR $(ROOT)/$(LIBRARIES)/$(SCLIB)/latest\n\
set PLACEROUTE_DIR $(ROOT)/$(PLACEROUTE_DIR)\n\
set COMMON_DIR $(ROOT)/$(COMMON_DIR)\
"

LC_OPTIONS = ""
LM_OPTIONS = ""
MW_OPTIONS = ""

setup: setup_$(SCLIB)
	date > $@

setup_$(SCLIB):
	test -d $(WORK_DIR) || mkdir -p $(WORK_DIR)
	test -d $(LOGS) || mkdir -p $(LOGS)
	test -d $(PLACEROUTE_DIR) || mkdir -p $(PLACEROUTE_DIR)
	printf $(COMMON_OPTIONS) > $(WORK_DIR)/setup.tcl
	echo "Building library $$SCLIB"
	rm -rf setup_sky130*
	date > $@

	date > $@

$(LIB_NAME)_db: setup
	cd work && lc_shell -f $(SCRIPTS)/lc.tcl $(LC_OPTIONS) |& tee $(LOGS)/lc_$@.log
	#! grep -q '^Error' $(LOGS)/lc_$@.log
	date > $@

$(LIB_NAME)_mw: setup
	cd work && echo $(MW_OPTIONS) > setup.tcl
	cd work && Milkyway -nogui -file $(SCRIPTS)/mw.tcl |& tee $(LOGS)/mw_$@.log
	#! grep -q '^Error' $(LOGS)/mw_$@.log
	date > $@

$(LIB_NAME)_ndm: $(LIB_NAME)_db $(LIB_NAME)_mw setup
	cd work && icc2_lm_shell -f $(SCRIPTS)/lm.tcl $(LM_OPTIONS) |& tee $(LOGS)/lm_$@.log
	date > $@

techfile: setup
	test -d $(TECH_DIR)/milkyway/ || mkdir $(TECH_DIR)/milkyway/
	cp $(ROOT)/milkyway/sky130_fd_sc_hd.tf $(TECH_DIR)/milkyway/skywater130_fd_sc_hd.tf
	date > $@

tluplus: setup
	test -d $(TECH_DIR)/star_rcxt/ || mkdir $(TECH_DIR)/star_rcxt/
	cp $(ROOT)/milkyway/skywater130.mw2itf.map $(TECH_DIR)/star_rcxt/
	cd work && grdgenxo -itf2TLUPlus -i $(ROOT)/star_rcxt/skywater130.nominal.itf -o $(TECH_DIR)/star_rcxt/skywater130.nominal.tluplus |& tee $(LOGS)/$@.log
	date > $@

tech: techfile tluplus
	date > $@

clean:
	rm -rfv setup* db lef ndm all techfile tluplus generate_map *.log *output.txt
	rm -rfv $(COMMON_DIR)/*.layers $(COMMON_DIR)/*.tluplus

clean_all: clean
	rm -rf $(WORK_DIR)
	rm -rf $(LOGS)
	rm -rf PlaceRoute/sky130_*

all: ndm
	date > $@

sky130_fd_sc_hd:
	$(MAKE) SCLIB=sky130_fd_sc_hd all

sky130_fd_sc_hdll:
	$(MAKE) SCLIB=sky130_fd_sc_hdll all

sky130_fd_sc_hs:
	$(MAKE) SCLIB=sky130_fd_sc_hs all

sky130_fd_sc_ls:
	$(MAKE) SCLIB=sky130_fd_sc_ls all

sky130_fd_sc_ms:
	$(MAKE) SCLIB=sky130_fd_sc_ms all

# TODO:
#all: sky130_fd_sc_hd sky130_fd_sc_hdll sky130_fd_sc_hs sky130_fd_sc_ls sky130_fd_sc_ms
