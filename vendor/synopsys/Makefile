LIBRARIES = ../../../libraries

LIB_NAME = sky130_fd_sc_hd

ROOT = $(realpath .)
SCRIPTS = $(ROOT)/scripts
RESULTS_DIR = $(ROOT)/results
LIBS_DIR = $(RESULTS_DIR)/lib
TECH_DIR = $(RESULTS_DIR)/tech
OUTPUT_DIR = $(LIBS_DIR)/$(LIB_NAME)
LOGS = $(ROOT)/logs

COMMON_OPTIONS = 'set target_lib_dir $(LIBRARIES)/$(LIB_NAME)/latest; set target_lib_name $(LIB_NAME); set output_dir $(OUTPUT_DIR)'
LC_OPTIONS = -x $(COMMON_OPTIONS)
LM_OPTIONS = -x $(COMMON_OPTIONS)
MW_OPTIONS = $(COMMON_OPTIONS)

all: $(LIB_NAME)_ndm tech

setup:
	test -d work || mkdir work
	test -d $(OUTPUT_DIR) || mkdir -p $(OUTPUT_DIR)
	test -d $(LOGS) || mkdir $(LOGS)
	test -d $(TECH_DIR) || mkdir -p $(TECH_DIR)
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
	rm -rfv setup *_mw *_db *_ndm *_all techfile tluplus tech

clean_all: clean
	rm -rf work
	rm -rf $(LOGS)
	rm -rf $(RESULTS_DIR)

# TODO:
#all: sky130_fd_sc_hd sky130_fd_sc_hdll sky130_fd_sc_hs sky130_fd_sc_ls sky130_fd_sc_ms
