####################################################################################
#                          PRE-ASSEMBLE PLUG-IN
####################################################################################
#
# This plug-in script is called before prior the assemble_design from the
# run_assemble.tcl flow script.
#
####################################################################################
#
# Assign partition pins
# Set pin-placement parameters for pin-assignment:
#     - pinDepth, to avoid min-area violations when 
#        DRC is run at the partition-level
#     - pinPitch and pin-layers set to single layer 
#       for each side (T/B/L/R)
# Fix the pin locations after assignment
#
# -----------------------------------------------------------------------------
#
#foreach ptn $vars(partition_list) {
#  foreach layer [list 2 3 4 5] {
#    # Sets the pin depth to 0.4um to satsify min area rule
#    setLayerPinDepth -cell $ptn -layer $layer -depth 0.4
#  }
#  # M6 is thick and requires a larger area
#  setLayerPinDepth -cell $ptn -layer 6 -depth 1.5
#  setMinPinSpacingOnEdge -cell $ptn -spacing 2
#
#  setAllowedPinLayersOnEdge -cell $ptn -edge T -layer [list 2 4]
#  setAllowedPinLayersOnEdge -cell $ptn -edge B -layer [list 2 4]
#  setAllowedPinLayersOnEdge -cell $ptn -edge L -layer [list 3 5]
#  setAllowedPinLayersOnEdge -cell $ptn -edge R -layer [list 3 5]
#}

#assignPtnPin
