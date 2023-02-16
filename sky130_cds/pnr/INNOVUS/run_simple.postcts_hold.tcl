#####################################################################
#                       SINGLE SCRIPT FLOW
#####################################################################

source FF/vars.tcl
source FF/procs.tcl

ff_procs::system_info
setDistributeHost -local
setMultiCpuUsage -localCpu 1


if {$vars(restore_design)} { restoreDesign DBS/cts.enc.dat mult_seq }

um::enable_metrics -on
puts "<FF> Plugin -> always_source_tcl"


#-------------------------------------------------------------
set vars(step) postcts_hold
set vars(postcts_hold,start_time) [clock seconds]
um::push_snapshot_stack
#-------------------------------------------------------------

######################################################################
# Variables affecting this step:
#---------------------------------------------------------------------
# - vars(process)
######################################################################
# Additional variables for this step:
#---------------------------------------------------------------------
# - vars(power_effort) "low or high"
# - vars(delay_cells)
# - vars(fix_hold_allow_tns_degradation)
# - vars(fix_hold_ignore_ios)
######################################################################
# The active analysis views are controlled by the following variables:
#---------------------------------------------------------------------
# - vars(postcts_hold,active_setup_views)
# - vars(postcts_hold,active_hold_views)
#
######################################################################
# set_analysis_view -setup $vars(postcts_hold,active_setup_views) -hold $vars(postcts_hold,active_hold_views)
#
setDesignMode -process 130
Puts "<FF> RUNNING POST-CTS HOLD FIXING ..."
puts "<FF> Plugin -> pre_postcts_hold_tcl"
optDesign -postCTS -hold -outDir RPT -prefix postcts_hold
puts "<FF> Plugin -> post_postcts_hold_tcl"
#-------------------------------------------------------------


um::pop_snapshot_stack
create_snapshot -name postcts_hold -categories design
report_metric -file RPT/metrics.html -format html
saveDesign DBS/postcts_hold.enc -compress
saveNetlist DBS/LEC/postcts_hold.v.gz
if {[info exists env(VPATH)]} {exec /bin/touch $env(VPATH)/postcts_hold}
ff_procs::report_time
puts "<FF> Plugin -> final_always_source_tcl"

exit
