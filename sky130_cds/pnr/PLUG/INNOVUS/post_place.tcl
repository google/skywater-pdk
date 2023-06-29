###################################################################################
#                             POST-PLACE PLUG-IN
###################################################################################
#
# This plug-in script is called after placeDesign from the run_place.tcl script.
#
# Example tasks include:
#          - standard cell rail creation 
#
###################################################################################
# 
# Standard cell rail creation for power domains if they are created/modified
# during the flow
# -----------------------------------------------------------------------------------

#sroute \
#   -noBlockPins \
#   -noPadRings \
#   -noPadPins \
#   -noStripes \
#   -straightConnections { straightWithDrcClean straightWithChanges } \
#   -nets { <p/g nets> } \
#   -powerDomains { <power domain> }  \
#   -targetViaTopLayer <layer> \
#   -crossoverViaTopLayer <layer> \
#   -verbose

checkPlace
