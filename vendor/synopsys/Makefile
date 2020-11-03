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

techfile: setup gds_layers
	mkdir -p $(PLACEROUTE_DIR)/techfile
	cd $(WORK_DIR) && Milkyway -galaxy -nogui -tcl -log read_lef.log -file ${ROOT}/${SCRIPTS}/techfile_convert.tcl |& tee ${ROOT}/$(LOGS)/tech_$@.log
	chmod 755 ./$(SCRIPTS)/fix_techfile.sh
	# ./$(SCRIPTS)/fix_techfile.sh $(PLACEROUTE_DIR)/techfile/$(SCLIB)_icc.tf
	date > $@

gds_layers: setup
	mkdir -p $(COMMON_DIR)
	#  Copy map file and duplicate lines with "drawing,text"
	sed -e "s/:/,/" $(ROOT)/docs/rules/gds_layers.csv | \
	sed -e "s/\(.*\)\"drawing, text\"\(.*\)/\1drawing \2\n\1text \2/" | \
	sed -e "s/Layer name/#Layer name/" > $(COMMON_DIR)/$(mapFileName)
	# Remove comments (5th column)
	cut -d "," -f 1-4 $(COMMON_DIR)/$(mapFileName) | sponge $(COMMON_DIR)/$(mapFileName)
	# Align columns
	column -t -s, -o, $(COMMON_DIR)/$(mapFileName) | sponge $(COMMON_DIR)/$(mapFileName)
	# Remove lines with empty data and remove comma
	sed -i -e "/.*,\s*,.*$$/d" -e "s/,/ /g" $(COMMON_DIR)/$(mapFileName)
	date > $@

tluplus: setup
	mkdir -p $(COMMON_DIR)
	cd $(WORK_DIR) && grdgenxo -itf2TLUPlus \
	-i $(ROOT)/$(COMMON_DIR)/skywater130.nominal.itf \
	-o $(ROOT)/$(COMMON_DIR)/skywater130.nominal.tluplus |& tee $(LOGS)/$@.log
	date > $@

db: setup techfile
	cd $(WORK_DIR) && lc_shell -f ${ROOT}/$(SCRIPTS)/lc.tcl $(LC_OPTIONS) |& tee ${ROOT}/$(LOGS)/lc_$@.log
	grep -q '^Error' ${ROOT}/$(LOGS)/lc_$@.log || true
	date > $@

lef: db
	mkdir -p $(PLACEROUTE_DIR)/lef && rm -rf $(PLACEROUTE_DIR)/lef/*
	for Lfile in $$(ls $(LIBRARIES)/$(SCLIB)/latest/cells/*/*.lef | sed '/magic/d' | sed '/isowell	/d'); do \
	ln -s ../../../$$Lfile $(PLACEROUTE_DIR)/lef/$$(echo $$(basename $$Lfile) | sed "s/lef/snps.lef/"); \
	done
	date > $@

gds: db
	mkdir -p $(PLACEROUTE_DIR)/gds && rm -rf $(PLACEROUTE_DIR)/gds/*
	for Lfile in $(LIBRARIES)/$(SCLIB)/latest/cells/*/*.gds; do \
	ln -s ../../../$$Lfile $(PLACEROUTE_DIR)/gds/$$(echo $$(basename $$Lfile) | sed "s/gds/snps.gds/"); \
	done
	date > $@

# Skipped : Use if original LEFs need modification
# lef: db
# 	mkdir -p $(PLACEROUTE_DIR)/lef && rm -rf $(PLACEROUTE_DIR)/lef/*
# 	# cd $(WORK_DIR) && Milkyway -nogui -file ${ROOT}/$(SCRIPTS)/mw.tcl |& tee ${ROOT}/$(LOGS)/mw_$@.log
# 	# grep -q '^Error' ${ROOT}/$(LOGS)/mw_$@.log || true
# 	cp $(LIBRARIES)/$(SCLIB)/latest/cells/*/*.lef $(PLACEROUTE_DIR)/lef
# 	rm $(PLACEROUTE_DIR)/lef/*.magic.lef
# 	date > $@

ndm: db lef gds
	cd $(WORK_DIR) && icc2_lm_shell -f ${ROOT}/$(SCRIPTS)/lm.tcl $(LM_OPTIONS) |& tee ${ROOT}/$(LOGS)/lm_$@.log
	grep -q '^Error' ${ROOT}/$(LOGS)/lm_$@.log || true
	date > $@

tech: techfile tluplus
	date > $@

clean:
	rm -rfv setup* db lef ndm all techfile tluplus gds_layers *.log *output.txt
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
