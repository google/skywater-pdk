###############################################################################
# CADENCE COPYRIGHT NOTICE                                                    #
# September 2008 Cadence Design Systems, Inc. All rights reserved.            #
#                                                                             #
# This script is AEWare, provided as an example of how to perform specialized #
# tasks within SoC Encounter.  It is not supported via the Cadence Hotline    #
# nor the CCR system.                                                         #
#                                                                             #
# This work may not be copied, re-published, uploaded, or distributed in any  #
# way, in any medium, whether in whole or in part, without prior written      #
# permission from Cadence.                                                    #
#                                                                             #
# This work is Cadence intellectual property and may under no circumstances   #
# be given to third parties, neither in original nor in modified versions,    #
# without explicit written permission from Cadence                            #
#                                                                             #
# The information contained herein is the proprietary and confidential        #
# information of Cadence or its licensors, and is supplied subject to, and    #
# may be used only by Cadence's customers in accordance with, a previously    #
# executed license and maintenance agreement between Cadence and its          #
# customer.                                                                   #
###############################################################################

global vars

###############################################################################
# Optinally define output directories for databases and reports
###############################################################################

# Design for Combinational PNR (uncomment if needed)
# set vars(steps) [list "init" "place" "route" "postroute" "signoff"]
# Design for Combinational+Sequential PNR (uncomment if needed)
set vars(steps) [list "init" "place" "cts" "postcts_hold" "route" "postroute" "signoff"]

set vars(dbs_dir)      DBS
set vars(rpt_dir)      RPT

###############################################################################
# Enable this variable if you want to abort when there are setup 
# errors ... leave 0 to continue on error
###############################################################################
set vars(abort) 0

#set vars(mail,to) "james.stine@okstate.edu"

#set vars(dbs_format) oa
set vars(enable_pac)                     true
set vars(tdsp_core,pac_mode)             all
set vars(signoff_extraction_effort)      medium
set vars(enable_ocv)                     false
set vars(enable_cppr)                    false
set vars(enable_ss)                      false
set vars(litho_driven_routing)           false
#set vars(dont_use_list) "*CLK*"
set vars(tie_cells)     "sky130_osu_sc_18T_ms__tiehi sky130_osu_sc_18T_ms__tielo"
set vars(filler_cells)  "sky130_osu_sc_18T_ms__fill_1 sky130_osu_sc_18T_ms__fill_2 sky130_osu_sc_18T_ms__fill_4 sky130_osu_sc_18T_ms__fill_8 sky130_osu_sc_18T_ms__fill_16"
set vars(cts_inverter_cells) "sky130_osu_sc_18T_ms__inv_l sky130_osu_sc_18T_ms__inv_1 sky130_osu_sc_18T_ms__inv_2 sky130_osu_sc_18T_ms__inv_3 sky130_osu_sc_18T_ms__inv_4"
#set vars(cts_buffer_cells) "CLKBUFX1"
#set vars(delay_cells) "DLY1 DLY2 DLY3 DLY4"
set vars(place_io_pins)                 true


###############################################################################
# The following plugins are supported when needed ...
###############################################################################
#set vars(always_source_tcl)             PLUG/INNOVUS/always_source.tcl
set vars(pre_init_tcl)                  PLUG/INNOVUS/pre_init.tcl
set vars(post_init_tcl)                 PLUG/INNOVUS/post_init.tcl
set vars(pre_place_tcl)                 PLUG/INNOVUS/pre_place.tcl
#set vars(place_tcl)                    PLUG/INNOVUS/place.tcl
#set vars(post_place_tcl)                PLUG/INNOVUS/post_place.tcl
#set vars(pre_prects_tcl)                PLUG/INNOVUS/pre_prects.tcl
#set vars(post_prects_tcl)               PLUG/INNOVUS/post_prects.tcl
set vars(pre_cts_tcl)                   PLUG/INNOVUS/pre_cts.tcl
#set vars(cts_tcl)                      PLUG/INNOVUS/cts.tcl
set vars(post_cts_tcl)                  PLUG/INNOVUS/post_cts.tcl
#set vars(pre_postcts_tcl)               PLUG/INNOVUS/pre_postcts.tcl
#set vars(post_postcts_tcl)              PLUG/INNOVUS/post_postcts.tcl
#set vars(pre_route_tcl)                 PLUG/INNOVUS/pre_route.tcl
#set vars(post_route_tcl)                PLUG/INNOVUS/post_route.tcl
#set vars(pre_postcts_hold_tcl)          PLUG/INNOVUS/pre_postcts_hold.tcl
#set vars(post_postcts_hold_tcl)         PLUG/INNOVUS/post_postcts_hold.tcl
#set vars(pre_postroute_tcl)             PLUG/INNOVUS/pre_postroute.tcl
#set vars(post_postroute_tcl)            PLUG/INNOVUS/post_postroute.tcl
#set vars(pre_postroute_hold_tcl)        PLUG/INNOVUS/pre_postroute_hold.tcl
#set vars(post_postroute_hold_tcl)       PLUG/INNOVUS/post_postroute_hold.tcl
#set vars(pre_postroute_si_tcl)          PLUG/INNOVUS/pre_postroute_si.tcl
#set vars(post_postroute_si_tcl)         PLUG/INNOVUS/post_postroute_si.tcl
#set vars(pre_postroute_si_hold_tcl)     PLUG/INNOVUS/pre_postroute_si_hold.tcl
#set vars(post_postroute_si_hold_tcl)    PLUG/INNOVUS/post_postroute_si_hold.tcl
#set vars(pre_signoff_tcl)               PLUG/INNOVUS/pre_signoff.tcl
set vars(post_signoff_tcl)              PLUG/INNOVUS/post_signoff.tcl
#set vars(pre_assemble_tcl)              PLUG/INNOVUS/pre_assemble.tcl
#set vars(post_assemble_tcl)             PLUG/INNOVUS/post_assemble.tcl
#set vars(pre_pac_tcl)                   PLUG/INNOVUS/pre_pac.tcl
#set vars(post_pac_tcl)                  PLUG/INNOVUS/post_pac.tcl

#######################################################################
# To insert metal fill during the flow define the following two
# variables:
# - vars(metalfill) [pre_postroute, pre_postroute_si, pre_signoff]
# - vars(metalfill_tcl) <path to metalfill plug-in>
#######################################################################
#set vars(metalfill)                  	pre_postroute_si
#set vars(metalfill_tcl)                	PLUG/INNOVUS/metal_fill.tcl
#######################################################################
