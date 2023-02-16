#####################################################################
#                       SINGLE SCRIPT FLOW
#####################################################################

source FF/vars.tcl
source FF/procs.tcl

ff_procs::system_info
setDistributeHost -local
setMultiCpuUsage -localCpu 1


if {$vars(restore_design)} { restoreDesign DBS/init.enc.dat mult_seq }

um::enable_metrics -on
puts "<FF> Plugin -> always_source_tcl"


#-------------------------------------------------------------
set vars(step) place
set vars(place,start_time) [clock seconds]
um::push_snapshot_stack
#-------------------------------------------------------------

######################################################################
# Variables affecting this step:
#---------------------------------------------------------------------
# - vars(process)
# - vars(enable_ocv)
# - vars(place_io_pins)
# - vars(in_place_opt)
######################################################################
# Additional variables for this step:
#---------------------------------------------------------------------
# - vars(power_effort) "low or high"
# - vars(enable_aocv)
# - vars(enable_socv)
# - vars(enable_ss) "pre_place"
# - vars(congestion_effort) "auto low medium high"
# - vars(clock_gate_aware) "true"
# - vars(size_only_file) "<file>"
# - vars(leakage_power_effort) "low or high"
# - vars(dynamic_power_effort) "low or high"
# - vars(clock_gate_aware_opt) "true"
# - vars(all_end_points) "true"
# - vars(fix_fanout_load) "<file>"
# - vars(useful_skew) "true"
# - vars(skew_buffers) "<list of buffers>"
######################################################################
# The active analysis views are controlled by the following variables:
#---------------------------------------------------------------------
# - vars(place,active_setup_views)
# - vars(place,active_hold_views)
#
######################################################################
# set_analysis_view -setup $vars(place,active_setup_views) -hold $vars(place,active_hold_views)
#
setDesignMode -process 130
setAnalysisMode -analysisType onChipVariation
setPlaceMode -place_global_place_io_pins true
Puts "<FF> RUNNING PLACEMENT ..."
puts "<FF> Plugin -> pre_place_tcl"
ff_procs::source_plug pre_place_tcl
place_opt_design -out_dir RPT -prefix place
puts "<FF> Plugin -> post_place_tcl"
setTieHiLoMode -cell "sky130_osu_sc_18T_ms__tiehi sky130_osu_sc_18T_ms__tielo"
foreach cell {sky130_osu_sc_18T_ms__tiehi sky130_osu_sc_18T_ms__tielo} {
   setDontUse $cell false
}
addTieHiLo
foreach cell {sky130_osu_sc_18T_ms__tiehi sky130_osu_sc_18T_ms__tielo} {
   setDontUse $cell true
}
#-------------------------------------------------------------


um::pop_snapshot_stack
create_snapshot -name place -categories design
report_metric -file RPT/metrics.html -format html
saveDesign DBS/place.enc -compress
saveNetlist DBS/LEC/place.v.gz
if {[info exists env(VPATH)]} {exec /bin/touch $env(VPATH)/place}
ff_procs::report_time
puts "<FF> Plugin -> final_always_source_tcl"

exit
