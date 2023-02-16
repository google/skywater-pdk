##################################################################################
#                              PRE_CTS PLUG-IN 
##################################################################################
#
# This plug-in script is called before clockDesign from the run_cts.tcl flow script.
#
##################################################################################

#setCTSMode -topPreferredLayer 7 \
#           -bottomPreferredLayer 3  \
#           -preferredExtraSpace 2
# for 3 metal LEF
create_route_type -bottom_preferred_layer 1 -name MET1
create_route_type -top_preferred_layer 5 -name MET5
set_ccopt_property route_type MET1
set_ccopt_property route_type MET5
setCTSMode -routeBottomPreferredLayer 1 -routeLeafBottomPreferredLayer 1 -routeTopPreferredLayer 5 -routeLeafTopPreferredLayer 5


set_interactive_constraint_modes setup_func_mode

#create_clock -name clk -period 2.8
