#####################################################################
#                       SINGLE SCRIPT FLOW
#####################################################################

source FF/vars.tcl
source FF/procs.tcl

ff_procs::system_info
setDistributeHost -local
setMultiCpuUsage -localCpu 1


######################################################################
# Variables affecting this step:
#---------------------------------------------------------------------
# - vars(report_run_time)
# - vars(add_tracks)
# - vars(max_route_layer)
# - vars(process)
######################################################################
# Additional variables for this step:
#---------------------------------------------------------------------
# - vars(ilm_list) "<list of ILMs>"
# - vars(<ilm>,ilm_dir) "<path to ILM directory>"
# - vars(<ilm>,lef_file) "<LEF file for block associated with ILM>"
# - vars(<ilm>,setup_lib) "<LIB file for block associated with ILM>"
# - vars(fp_tcl_file)
# - vars(fp_tcl_proc)
# - vars(fp_file)
# - vars(oa_fp)
# - vars(def_files)
# - vars(ilm_non_sdc_file)
# - vars(activity_file)
# - vars(activity_file_format)
# - vars(scan_def)
# - vars(spare_cells)
# - vars(dont_use_list)
# - vars(dont_use_file)
# - vars(use_list)
# - vars(power_effort) "low or high"
# - vars(welltaps)
# - vars(pre_endcap)
# - vars(post_endcap)
######################################################################
set vars(step) init
set vars(init,start_time) [clock seconds]
exec mkdir -p $env(VPATH)
puts "<FF> Plugin -> pre_init_tcl"
ff_procs::source_plug pre_init_tcl
source FF/init.tcl
init_design
um::enable_metrics -on
um::push_snapshot_stack
puts "<FF> Plugin -> always_source_tcl"
add_tracks
source FF/timingderate.sdc
setMaxRouteLayer 5
setDesignMode -process 130
puts "<FF> Plugin -> post_init_tcl"
ff_procs::source_plug post_init_tcl
timeDesign -preplace -prefix preplace -outDir RPT
checkDesign -all
check_timing
#-------------------------------------------------------------


um::pop_snapshot_stack
create_snapshot -name init -categories design
report_metric -file RPT/metrics.html -format html
saveDesign DBS/init.enc -compress
saveNetlist DBS/LEC/init.v.gz
if {[info exists env(VPATH)]} {exec /bin/touch $env(VPATH)/init}
ff_procs::report_time
puts "<FF> Plugin -> final_always_source_tcl"

exit
