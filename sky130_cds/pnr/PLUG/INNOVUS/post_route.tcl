##################################################################################
#                              POST-ROUTE PLUG-IN 
##################################################################################
#
# This plug-in script is called after routeDesign from the run_route.tcl flow script.
#
# --------------------------------------------------------------------------------
# Example usage may be power switch optimization:
# --------------------------------------------------------------------------------

#set vars(switch_cell_file) $vars(data_root)/power_switch_cell.txt
#set vars(switch_cell_ir_drop) 0.1

#optPowerSwitch -readPowerSwitchCell $vars(switch_cell_file) \
#               -effort high \
#               -commit 1 \
#               -maxSwitchIRDrop $vars(switch_cell_ir_drop) \
#               -reportFile $vars(rpt_dir)/deleted_switch_cells.txt

##################################################################################


