####################################################################################
#                              POST-CTS PLUG-IN
#####################################################################################
#
# This plug-in script is called after clockDesign from the run_cts.tcl script.
# It can be used to adjust IO latencies, update to postcts clock uncertainties, etc.
#
#####################################################################################
set_ccopt_property balance_mode full
setOptMode -usefulSkewCCOpt medium
#ccopt_design
