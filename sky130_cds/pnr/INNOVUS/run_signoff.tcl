####################################################################
# Innovus Foundation Flow Code Generator, Fri Jun 24 13:06:16 CDT 2022
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

if {$vars(restore_design)} { restoreDesign DBS/postroute.enc.dat mult_seq }

um::enable_metrics -on
puts "<FF> Plugin -> always_source_tcl"

#-------------------------------------------------------------
set vars(step) signoff
set vars(signoff,start_time) [clock seconds]
um::push_snapshot_stack
#-------------------------------------------------------------

######################################################################
# Variables affecting this step:
#---------------------------------------------------------------------
# - vars(process)
# - vars(signoff_extraction_effort)
# - vars(enable_ocv)
# - vars(enable_cppr)
######################################################################
# Additional variables for this step:
#---------------------------------------------------------------------
# - vars(total_c_thresh)
# - vars(relative_c_thresh)
# - vars(coupling_c_thresh)
# - vars(qrc_layer_map)
# - vars(delta_delay_threshold)
# - vars(celtic_settings)
# - vars(si_analysis_type)
# - vars(enable_aocv)
# - vars(enable_socv)
# - vars(enable_ss) "pre_signoff"
######################################################################
# The active analysis views are controlled by the following variables:
#---------------------------------------------------------------------
# - vars(signoff,active_setup_views)
# - vars(signoff,active_hold_views)
#
######################################################################
# set_analysis_view -setup $vars(signoff,active_setup_views) -hold $vars(signoff,active_hold_views)
#
setDesignMode -process 130
setExtractRCMode -coupled true -effortLevel low
setAnalysisMode -analysisType onChipVariation -cppr none
set vars(active_rc_corners) [list]
foreach view [concat [all_setup_analysis_views] [all_hold_analysis_views]] {
   set corner [get_delay_corner [get_analysis_view $view -delay_corner] \
      -rc_corner]
   if {[lsearch $vars(active_rc_corners) $corner] == -1 } {
      lappend vars(active_rc_corners) $corner
   }
}
Puts "<FF> ACTIVE RC CORNER LIST: $vars(active_rc_corners)"
set empty_corners [list]
foreach corner $vars(active_rc_corners) {
   if {![file exists [get_rc_corner $corner -qx_tech_file]]} {
      lappend empty_corners $corner
   }
}
if {[llength $empty_corners] == 0} {
   setExtractRCMode -engine postRoute -effortLevel low -coupled true
} else {
   Puts "<FF> CAN'T RUN SIGNOFF EXTRACTION BECAUSE qx_tech_file IS NOT DEFINED FOR these corners: $empty_corners"
   setExtractRCMode -engine postRoute -effortLevel low -coupled true
}
puts "<FF> Plugin -> pre_signoff_tcl"
Puts "<FF> RUNNING FINAL SIGNOFF ..."
extractRC
foreach corner $vars(active_rc_corners) {
   rcOut -rc_corner $corner -spef $corner.spef.gz
}
timeDesign -prefix signoff -signoff -reportOnly -outDir RPT
timeDesign -prefix signoff -signoff -reportOnly -hold -outDir RPT
summaryReport -outDir RPT
verifyConnectivity -noAntenna
verify_drc
verifyMetalDensity
verifyProcessAntenna
puts "<FF> Plugin -> post_signoff_tcl"
ff_procs::source_plug post_signoff_tcl
#-------------------------------------------------------------

um::pop_snapshot_stack
create_snapshot -name signoff -categories design
report_metric -file RPT/metrics.html -format html
saveDesign DBS/signoff.enc -compress
saveNetlist DBS/LEC/signoff.v.gz
if {[info exists env(VPATH)]} {exec /bin/touch $env(VPATH)/signoff}
ff_procs::report_time
puts "<FF> Plugin -> final_always_source_tcl"

if {![info exists vars(single)]} {
   exit 0
}

