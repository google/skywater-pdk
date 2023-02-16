####################################################################################
#                          PRE-PLACE PLUG-IN
####################################################################################
#
# This plug-in script is called before placeDesign from the run_place.tcl flow
# script.
#
####################################################################################
# Example tasks include:
#          - Power planning related tasks which includes
#            - Power planning for power domains (ring/strap creations)
#            - Power Shut-off cell power hookup
############################################################################################
setCTSMode -bottomPreferredLayer 1 -topPreferredLayer 5

