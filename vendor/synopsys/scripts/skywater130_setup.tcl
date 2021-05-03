#set DESIGN_REF_PATH "/u/powercae/paths/libs/all_libs/google-skywater"

## pg_type fix:
set DESIGN_REF_PATH "/slowfs/cae678/diegob/testing/powercae_scripts/libraries/google-skywater/results"

set high_density " \
	sky130_fd_sc_hd__ss_n40C_1v28.db \
	"
set LIBRARY_FILES " \
	${high_density} \
    "

set MW_REFERENCE_LIB_DIRS  " \
	${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/mw/sky130_fd_sc_hd
       " 

set NDM_REFERENCE_LIB_DIRS  " \
	${DESIGN_REF_PATH}/lib/sky130_fd_sc_hd/ndm/sky130_fd_sc_hd.ndm
       " 
set TECH_FILE        "${DESIGN_REF_PATH}/tech/milkyway/skywater130_fd_sc_hd.tf"
set MAP_FILE         "${DESIGN_REF_PATH}/tech/star_rcxt/skywater130.mw2itf.map"
set TLUPLUS_MAX_FILE "${DESIGN_REF_PATH}/tech/star_rcxt/skywater130.nominal.tluplus"
set TLUPLUS_MIN_FILE "${DESIGN_REF_PATH}/tech/star_rcxt/skywater130.nominal.tluplus"

set MW_POWER_NET                "VDD" ;#
set MW_POWER_PORT               "VDD" ;#
set MW_GROUND_NET               "VSS" ;#
set MW_GROUND_PORT              "VSS" ;#

set MIN_ROUTING_LAYER            "M2"   ;# Min routing layer
set MAX_ROUTING_LAYER            "M8"   ;# Max routing layer

