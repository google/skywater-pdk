##################################################################################
#                           PRE-PRE_CTS PLUG-IN 
##################################################################################
#
# This plug-in script is called before optDesign -preCTS from the run_prects.tcl 
# flow script.
#
# --------------------------------------------------------------------------------
# By default SOCE does always-on-net synthesis for SRPG control signal and PSO enable
# signals as part of optDesign -preCTS, but this can be manually done for specific nets if
# necessary.  To do this, define the appropriate variables in the lp_config.tcl file
# and uncomment the following command
# --------------------------------------------------------------------------------

#ff_buffer_always_on_nets

##################################################################################
