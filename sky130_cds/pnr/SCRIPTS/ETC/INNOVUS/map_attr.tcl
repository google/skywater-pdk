# Potential flow control
# ----------------------------------------------------------------------

#set help(steps) flow_steps

#set attr(enable_aocv) "timing_enable_aocv_analysis"
#set attr(enable_cppr) "timing_analysis_cppr"
#set attr(enable_ocv) "timing_analysis_type"
#set attr(enable_si_aware) "timing_analysis_si_aware"

#set attr(enable_pac) boolean (delete)
#set attr(enable_dlm) boolean (delete)
#set attr(enable_flexilm) boolean
#set attr(abutted_design) ?
#set attr(insert_feedthrough) ?
#set attr(ps_pm) ?
#set attr(use_ps_pm) ?
#set attr(enable_flexilm) ?
#set attr(use_flexmodels) ?
#set attr(flexmodel_as_ptn) ?
#set attr(flexmodel_art_based) ?

#set attr(fix_hold) boolean
#set attr(fix_litho) boolean
#set attr(high_timing_effort) boolean
#set attr(run_clp) boolean
#set attr(run_lec) boolean
#set attr(skip_cts) boolean
#set attr(skip_si) boolean
#set attr(skip_signoff_checks) boolean
#set help(hier_flow_type) "1pass 2pass"
#set help(black_box) "TRUE false"
#set attr(partition_dir) "PARTITION directory"

# Library Setup (drop or move)
# ----------------------------------------------------------------------
#set attr(library_sets) "List of library sets"
#set attr(timing) "List of library files"  
#set attr(aocv) "AOCV table file"
#set attr(si)  "List of CDB files"
#set attr(rc_corners) "List of RC corners"
#set attr(P) "Process multiplier"
#set attr(T) "Temperature"
#set attr(V) "Voltage" 
#set attr(cap_table) "Captable file"
#set attr(post_route_cap_factor) "float (triplet)"
#set attr(post_route_clk_cap_factor) "float (triplet)"
#set attr(post_route_clk_res_factor) "float (triplet)"
#set attr(post_route_res_factor) "float"
#set attr(pre_route_cap_factor) "float"
#set attr(pre_route_clk_cap_factor) "float"
#set attr(pre_route_clk_res_factor) "float"
#set attr(pre_route_res_factor) "float"
#set attr(qx_tech_file) "QRC techfile"
#set attr(opconds) "List of opconds"
#set attr(P) "Process multiplier" 
#set attr(T) "Temperature"
#set attr(V) "Voltage"
#set attr(library_file) "Library file"
#set attr(delay_corners) "List of delay corners"
#set attr(library_set) "Library set"
#set attr(rc_corner) "RC corner"
#set attr(power_domains) "List of power domains"
#set attr(clock_cell_early) "Float"
#set attr(clock_cell_late) "Float"
#set attr(clock_net_early) "Float"
#set attr(clock_net_late) "Float"
#set attr(data_cell_early) "Float"
#set attr(data_cell_late) "Float"
#set attr(data_net_early) "Float"
#set attr(data_net_late) "Float"
#set attr(constraint_modes) "List of constraint modes"
#set attr(pre_cts_sdc) "List of SDC files"
#set attr(post_cts_sdc) "List of SDC files" 
#set attr(incr_cts_sdc) "List of SDC files (incremental)" 
#set attr(ilm_non_sdc_file) "List of ILM constraints"
#set attr(setup_analysis_views) "List of analysis views" 
#set attr(hold_analysis_views) "List of analysis views" 
#set attr(constraint_mode) "Constraint mode"
#set attr(delay_corner) "Delay corner"
#
#set attr(active_setup_views) "List of active setup views"
#set attr(active_hold_views) "List of active hold views"
#set attr(active_setup_views) "List of active setup views per step"
#set attr(active_hold_views) "List of active hold views per step"
#
#set attr(default_setup_view) "Default setup view"
#set attr(default_hold_view) "Default hold view"

# Design Initialization
set help(netlist) "init_verilog"
#set help(netlist_type) "VERILOG vhdl"
set help(design) "init_top_cell"
set attr(def_files) "flow_def_files"
set attr(oa_design_lib) init_oa_design_lib
set attr(oa_design_cell) init_oa_design_cell
set attr(oa_design_view)  init_oa_design_view
#set attr(ilm_list) flow_ilm_list
#set attr(ilm_dir) flow_ilm_dir_list
#set attr(lef_file) flow_ilm_lef_files
#set attr(setup_lib) flow_ilm_setup_lib
set attr(max_route_layer) route_trial_max_route_layer
set attr(generate_tracks) add_tracks
#set attr(honor_pitch) ?

# Place
set attr(place_io_pins) place_global_place_io_pins
set attr(clock_gate_aware) place_global_clock_gate_aware
#set attr(clock_gate_clone) ? 
set attr(congestion_effort) place_global_cong_effort


# Power
set attr(activity_file) "File name"
set attr(activity_file_format) "TCF VCD SAIF"
set attr(power_analysis_view) "Analysis view for power analysis"
set attr(power_domains) "List of power domains"

set attr(cpf_file) init_cpf_file
#set attr(ieee1801_file) ?

set attr(power_nets) "List of power nets"
set attr(ground_nets) "List of ground nets"
set attr(global_nets) "List of global nets"
set attr(module) "Module for global net"
set attr(pins) "Power pins for global net"
set attr(tiehi) "Tiehi global net" 
set attr(tielo) "Tielo global net" 


# Clock
set attr(cts_engine) cts_engine
#set attr(cts_integration) ?
set attr(cts_cells) "List of CTS cells"
set attr(cts_buffer_cells) "List of CTS buffer cells"
set attr(cts_inverter_cells) "List of CTS inverter cells"
set attr(clock_gate_cells) "List of CTS clock gate cells"
set attr(cts_use_inverters) "true false"
set attr(clk_leaf_bottom_layer) cts_route_leaf_bottom_preferred_layer
set attr(clk_leaf_top_layer) cts_route_leaf_top_preferred_layer
set attr(clk_leaf_extra_space) cts_route_leaf_preferred_extra_space
set attr(clk_leaf_ndr) cts_route_leaf_non_default_rule
set attr(clk_max_skew) "Float (nanoseconds)"
set attr(clk_max_slew) "Float (nanoseconds)"
set attr(clk_tree_bottom_layer) cts_route_bottom_preferred_layer
set attr(clk_tree_extra_space) cts_route_top_preferred_layer
set attr(route_clock_nets) cts_route_clk_net
set attr(clk_tree_ndr) cts_route_non_default_rule
set attr(clk_tree_shield_net) ccopt_route_top_shielding_net
set attr(clk_tree_shield_thresh) ccopt_top_net_min_fanout
set attr(update_io_latency) ccopt_modify_clock_latency

set attr(clock_eco) "true FALSE"

# Opt
set attr(all_end_points) opt_all_end_points
#set attr(clock_gate_aware_opt) ?
#set attr(critical_range) ?
#set attr(congestion_effort) ?
set attr(dynamic_power_effort) opt_dynamic_power_effort
set attr(leakage_power_effort) opt_leakage_power_effort
set attr(preserve_assertions) opt_preserve_pins_with_timing_constraints
set attr(resize_shifter_and_iso_insts) opt_resize_level_shifter_and_iso_instances
set attr(fix_hold_allow_tns_degradation) opt_fix_hold_allow_setup_tns_degradation
set attr(fix_hold_ignore_ios) opt_fix_hold_ignore_path_groups
set attr(useful_skew) opt_useful_skew

# Route
set attr(multi_cut_effort) route_detail_use_multi_cut_via_effort
set attr(litho_driven_routing) route_detail_post_route_litho_repair
set attr(postroute_spread_wires) route_detail_post_route_spread_wire
#set attr(route_secondary_pg_nets) "true FALSE"
#set attr(secondary_pg_nets) "List of global nets for secondary power/ground"

# Extraction
set attr(postroute_extraction_effort) extract_rc_effort_level
set attr(signoff_extraction_effort) extract_rc_effort_level
set attr(coupling_c_thresh) extract_rc_coupling_cap_th
set attr(total_c_thresh) extract_rc_total_cap_th
set attr(relative_c_thresh) extract_rc_relative_cap_th

# DFM
#set attr(verify_litho) "true FALSE"
#set attr(lpa_tech_file) "LPA tech file"
#set attr(metalfill) "true FALSE"
#set attr(metalfill_tcl) "Metalfill plug-in"
#set attr(gds_files) "GDS file list"
#set attr(gds_layer_map) "GDS layer map"
#set attr(gds_files) "Oasis file list"
#set attr(gds_layer_map) "Oasis layer map"

# Noise
#set attr(si_analysis_type) "DEFAULT pessimistic"
set attr(delta_delay_threshold) si_delay_delta_threshold
#set attr(acceptable_wns) si_acceptable_wns

# Database
set attr(dbs_dir) "Database directory"
set attr(dbs_format) "FE oa"
set attr(oa_layout_name) "OA Layout view name"
set attr(oa_abstract_name) "OA Abstract view name"
set attr(save_constraints) "true FALSE (Save constraints with DBS?)"
set attr(save_rc) "true FALSE (Save RCDB with DBS?)"

# Reporting
set attr(rpt_dir) "Reports directory"
set attr(report_power) "TRUE false"
set attr(capture_metrics) capture_metrics

# Misc
set attr(to) "Mail addresses"
set attr(steps) "List of steps"

set attr(plug_dir) "Plug-in directory"
set attr(tmp_dir) "TMP directory"
set attr(log_dir) "LOG directory"


set attr(distribute) "LOCAL lsf rsh custom"
set attr(local_cpus) "List of hosts"
set attr(remote_hosts) "Integer (number of hosts)"
set attr(cpus_per_remote_host) "Integer (number of cpus)"


#set attr(assign_buffer) ?
#set attr(assign_buffer_cell) ?
#set attr(always_on_buffers) "List of AON buffers"
#set attr(delay_cells) "List of delay cells"
#set attr(dont_use_list) "List of dont use cells"
#set attr(dont_use_file) "File w/setDontUse commands"
#set attr(welltaps) "Welltap cells"
#set attr(cell_interval) "Float: (interval) distance in microns"
#set attr(checkerboard) "true FALSE"
#set attr(spare_cells) "List of spare modules"
#set attr(jtag_cells) "List of jtag modules"
#set attr(jtag_rows) "List of rows to reserve for jtag placement"
#set attr(filler_cells) "List of filler cells"
#set attr(skew_buffers) "List of buffers for useful skew"
#set attr(tie_cells) "List of tie cells"
#set attr(max_distance) "Float: distance in microns"
#set attr(max_fanout) "Interger: fanout number"
