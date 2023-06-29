####################################################################
# Innovus Foundation Flow Code Generator, Fri Jun 24 13:02:02 CDT 2022
# Version : 17.10-p003_1
####################################################################

if {[file exists FF/vars.tcl]} {
   source FF/vars.tcl
}
foreach file $vars(config_files) {
   source $file
}

source FF/procs.tcl
ff_procs::system_info
setDistributeHost -local
setMultiCpuUsage -localCpu 1

if {$vars(restore_design)} { restoreDesign DBS/place.enc.dat mult_seq }

um::enable_metrics -on
puts "<FF> Plugin -> always_source_tcl"

#-------------------------------------------------------------
set vars(step) cts
set vars(cts,start_time) [clock seconds]
um::push_snapshot_stack
#-------------------------------------------------------------

######################################################################
# Variables affecting this step:
#---------------------------------------------------------------------
# - vars(process)
# - vars(enable_cppr)
# - vars(route_clock_nets)
# - vars(ccopt_integration)
# - vars(cts_inverter_cells)
# - vars(update_io_latency)
# - vars(ccopt_effort)
# - vars(litho_driven_routing)
######################################################################
# Additional variables for this step:
#---------------------------------------------------------------------
# - vars(power_effort) "low or high"
# - vars(enable_ocv) "pre_cts"
# - vars(enable_aocv) "true"
# - vars(enable_socv) "true"
# - vars(clk_tree_top_layer)
# - vars(clk_leaf_top_layer)
# - vars(clk_tree_bottom_layer)
# - vars(clk_leaf_bottom_layer)
# - vars(clk_tree_ndr)
# - vars(clk_tree_extra_space)
# - vars(clk_leaf_ndr)
# - vars(clk_leaf_extra_space)
# - vars(cts_buffer_cells)
# - vars(clock_gate_cells)
# - vars(cts_use_inverters)
# - vars(cts_io_opt)
# - vars(cts_target_skew)
# - vars(cts_target_slew)
# - vars(ccopt_executable)
# - vars(clk_tree_shield_net)
# - vars(multi_cut_effort)
######################################################################
# The active analysis views are controlled by the following variables:
#---------------------------------------------------------------------
# - vars(cts,active_setup_views)
# - vars(cts,active_hold_views)
#
######################################################################
# set_analysis_view -setup $vars(cts,active_setup_views) -hold $vars(cts,active_hold_views)
#
setDesignMode -process 130
setAnalysisMode -cppr none
set_ccopt_mode  -integration "native" \
   -cts_inverter_cells "sky130_osu_sc_18T_ms__inv_l sky130_osu_sc_18T_ms__inv_1 sky130_osu_sc_18T_ms__inv_2 sky130_osu_sc_18T_ms__inv_3 sky130_osu_sc_18T_ms__inv_4" \
   -ccopt_modify_clock_latency true

setNanoRouteMode -routeWithLithoDriven false
Puts "<FF> RUNNING CLOCK TREE SYNTHESIS ..."
source FF/timingderate.sdc
puts "<FF> Plugin -> pre_cts_tcl"
ff_procs::source_plug pre_cts_tcl
create_ccopt_clock_tree_spec
ccopt_design -outDir RPT -prefix cts
puts "<FF> Plugin -> post_cts_tcl"
ff_procs::source_plug post_cts_tcl
#-------------------------------------------------------------

um::pop_snapshot_stack
create_snapshot -name cts -categories design
report_metric -file RPT/metrics.html -format html
saveDesign DBS/cts.enc -compress
saveNetlist DBS/LEC/cts.v.gz
if {[info exists env(VPATH)]} {exec /bin/touch $env(VPATH)/cts}
ff_procs::report_time
puts "<FF> Plugin -> final_always_source_tcl"

if {![info exists vars(single)]} {
   exit 0
}

