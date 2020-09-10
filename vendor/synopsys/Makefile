ROOT = $(realpath .)
LIBRARIES = $(ROOT)/../../libraries
SCRIPTS = $(ROOT)/scripts
LIB_NAME = $(subst _db,,$@)
MW_LIB_NAME = $(subst _mw,,$@)
LC_OPTIONS = -x 'set target_lib $(LIBRARIES)/$(LIB_NAME)/latest; set target_lib_name $(LIB_NAME)'

setup:
	date > setup

sky130_%_db: setup
	cd work && lc_shell -f $(SCRIPTS)/lc.tcl $(LC_OPTIONS) |& tee lc_$@.log
	date > $@

sky130_%_mw: setup
	cd work && echo  'set target_lib_dir $(LIBRARIES)/$(MW_LIB_NAME)/latest; set target_lib_name $(LIB_NAME)' >> setup.tcl
	cd work && Milkyway -nogui -file $(SCRIPTS)/mw.tcl |& tee mw_$@.log
	date > $@

sky130_%: sky130_%_db sky130_%_mw setup
	date > $@

tluplus:
	cd star_rcxt &&	grdgenxo -itf2TLUPlus -i skywater130.nominal.itf -o skywater130.nominal.tluplus |& tee $@.log

clean: 
	rm work setup *_mw *_db $(LIBRARIES)/$(LIB_NAME)/latest/db_nldm/* $(LIBRARIES)/$(LIB_NAME)/latest/mw -rf

all: sky130_fd_sc_hd 
# TODO:
#all: sky130_fd_sc_hd sky130_fd_sc_hdll sky130_fd_sc_hs sky130_fd_sc_ls sky130_fd_sc_ms
