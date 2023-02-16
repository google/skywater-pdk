##################################################################################
#                      POST-PRE_CTS PLUG-IN 
##################################################################################
#
# This plug-in is called after optDesign -preCTS from the run_prects.tcl flow
# script.  The user can use this plug-in for:
#
# --------------------------------------------------------------------------------
#     - Secondary power pin routing for low power cells 
#        - State retention flops
#        - Always-on-buffers
#        - Level-shifters
#     - Check the connectivity and geometry on these nets
# --------------------------------------------------------------------------------
# Below are some example commands ...
####################################################################################

####################################################################################
# Secondary power routing for SRPG/AON/LVL cells using nanoroute ...
# ... it requires vars(secondary_pg,cell_pin_pairs) to be defined
# ... in the OVERLAY/lp_config.tcl
# NOTE: In the early stage of the flow (before CTS) if user wants to estimate the
# routing resource impact due to secondary pg pin routing, he can do secondary pg pin
# connection before CTS OR if user enables "vars(route_secondary_pg_nets)" as true in
# OVERLAY/lp_config.tcl then same would be done before the routing stage also.
####################################################################################
#ff_route_secondary_pg_nets

####################################################################################
## Check for Geometry and connectivity violations on power nets
####################################################################################
#clearDrc

#verifyConnectivity \
#   -type special \
#   -noAntenna \
#   -nets { VSS VDD } \
#   -report $vars(rpt_dir)/$vars(design).conn.rpt

#verifyGeometry \
#   -allowPadFillerCellsOverlap \
#   -allowRoutingBlkgPinOverlap \
#   -allowRoutingCellBlkgOverlap \
#   -error 1000 \
#   -report $vars(rpt_dir)/$vars(design).geom.rpt

#clearDrc
