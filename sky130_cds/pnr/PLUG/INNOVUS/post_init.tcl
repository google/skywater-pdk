####################################################################################
#                             POST-INIT PLUG-IN
####################################################################################
#
# This plug-in script is called after design import from the run_init.tcl script.
#
# --------------------------------------------------------------------------------
# Can be used for various floorplan related tasks, like:
#              - Die/core boundary
#              - placement of hard macros/blocks
#              - power domain size and clearence surrounding to it
#              - Placement and routing blockages in the floorplan
#              - IO ring creation
#              - PSO planning
# --------------------------------------------------------------------------------
# Specifically, this example includes tasks related to the LP/CPF foundation flow 
# including power domain modification and power shut-off planning. The examples 
# included here operate based on variables (vars array) defined in the 
# OVERLAY/lp_config.tcl file
#
if {[info exists vars(cpf_file)]} {

# --------------------------------------------------------------------------------
# Modify power domains
# --------------------------------------------------------------------------------
# The 'modify_power_domains' procedure is included with the foundation flows
# to help automate power domain modification.  To enable this, please set the
# appropriate variables in the lp_config.tcl and uncomment the following command
#

#	ff_modify_power_domains
    
# --------------------------------------------------------------------------------
# Power switch insertion
# --------------------------------------------------------------------------------
# The 'add_power_switches' procedure is included with the foundation flows
# to cover common power switch insertion scenarios.  To use, set the appropriate
# variables in the lp_config.tcl file and uncomment the following command.
# --------------------------------------------------------------------------------
# NOTE: This procedure  will NOT COVER THE ALL THE OPTIONS in addPowerSwitch
# For more complicated scenarios, please manually add the addPowerSwitch command
# here with the necessary options.
# --------------------------------------------------------------------------------

#	ff_add_power_switches

}

# Floorplan (from long time ago in a galaxy far, far away)
floorplan -r 1.0 0.60 40 40 40 40 

# Make VDD/VSS power connectors
globalNetConnect VSS -type pgpin -pin gnd -inst * 
globalNetConnect VDD -type pgpin -pin vdd -inst * 
# Not sure I need this
#globalNetConnect VDD –type tiehi
#globalNetConnect VSS –type tielo

# Add Ring
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer met2 -stacked_via_bottom_layer met1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top met1 bottom met1 left met2 right met2} -width {top 7.2 bottom 7.2 left 7.2 right 7.2} -spacing {top 1.8 bottom 1.8 left 1.8 right 1.8} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 0 -extend_corner {} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None

####Some settings for power grid:
set vars(layers) "0 1"
# LI1
set vars(1,width) 0.61
set vars(1,space) 6.05
set vars(1,pitch) 13.32
set vars(1,direction) horizontal
set vars(1,bottom_via_layer) 0
set vars(1,offset) -0.1525
# M1
set vars(0,width) 0.61
set vars(0,space) 6.05
set vars(0,pitch) 13.32
set vars(0,direction) horizontal
set vars(0,bottom_via_layer) 0
set vars(0,offset) -0.1525


foreach layer $vars(layers) {
    set sp1 $vars($layer,space)
    set sp2 $vars($layer,space)
    if {$vars($layer,direction)== "vertical"} {
    set start_edge left
    } else {
    set start_edge bottom
    }
    setAddStripeMode -stacked_via_top_layer $layer -stacked_via_bottom_layer $vars($layer,bottom_via_layer) -break_at none -orthogonal_only false
    # add stripe command
        addStripe \
        -layer $layer \
        -width $vars($layer,width) \
        -spacing [list $sp1 $sp2] \
        -set_to_set_distance $vars($layer,pitch) \
        -start_offset [expr $vars($layer,offset)*2] \
        -direction $vars($layer,direction) \
        -start_from $start_edge \
        -nets {VDD VSS}
}

# Connect to power
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { met5(5) met1(1) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { met1(1) met5(5) } -nets { VDD VSS } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { met1(1) met5(5) }

