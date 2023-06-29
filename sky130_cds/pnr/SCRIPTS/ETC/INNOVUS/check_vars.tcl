###############################################################################
#                       CADENCE COPYRIGHT NOTICE
#         © 2008-2013 Cadence Design Systems, Inc. All rights reserved.
#------------------------------------------------------------------------------
#
# This Foundation Flow is provided as an example of how to perform specialized
# tasks.
#
# This work may not be copied, re-published, uploaded, or distributed in any way,
# in any medium, whether in whole or in part, without prior written permission
# from Cadence. Notwithstanding any restrictions herein, subject to compliance
# with the terms and conditions of the Cadence software license agreement under
# which this material was provided, this material may be copied and internally
# distributed solely for internal purposes for use with Cadence tools.
#
# This work is Cadence intellectual property and may under no circumstances be
# given to third parties, neither in original nor in modified versions, without
# explicit written permission from Cadence. The information contained herein is
# the proprietary and confidential information of Cadence or its licensors, and
# is supplied subject to, and may be used only by Cadence's current customers
# in accordance with, a previously executed license agreement between Cadence
# and its customer.
#
#------------------------------------------------------------------------------
# THIS MATERIAL IS PROVIDED BY CADENCE "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL CADENCE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL
# OR CONSEQUENTIAL DAMAGES HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS  MATERIAL, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

if  {[info exists vars(check_vars)] && $vars(check_vars)} {

   set op [open $vars(script_dir)/check_vars.rpt w]
   
   if {![info exists vars(opconds)]} {
      set vars(opconds) ""
   }   

   set valid_prefixes "\
      $vars(library_sets) \
      $vars(rc_corners) \
      $vars(opconds) \
      $vars(delay_corners) \
      $vars(constraint_modes) \
      $vars(setup_analysis_views) \
      $vars(hold_analysis_views) \
      library_set \
      cdb_file \
      echo_file \
      timelib \
      rc_corner \
      delay_corner \
      constraint_mode \
      welltaps \
      filler_cells \
      mail \
      partition \
      init \
      place \
      prects \
      cts \
      postcts \
      postcts_hold \
      route \
      postroute \
      postroute_hold  \
      postroute_si \
      postroute_si_hold \
      signoff \
      assemble \ 
      tie_cells \
      filler_cells \
      welltaps \
      secondary_pg \
      always_on_nets \
      lsf custom rsh \ 
      tags \
   "
   
   set valid_suffixes "\
      timing si min max\
      library_set \
      rc_corner \
      P V T cap_table qx_tech_file qx_lib_dir\
      def_res_factor def_cap_factor def_clk_cap_factor \
      det_res_factor det_cap_factor det_clk_cap_factor \
      xcap_factor \
      pre_route_res_factor pre_route_clk_res_factor  pre_route_cap_factor  pre_route_clk_cap_factor  \
      post_route_res_factor post_route_clk_res_factor  post_route_cap_factor  post_route_clk_cap_factor  
      post_route_xcap_factor  \
      scale_tcl \ 
      delay_corner \
      data_cell_late data_cell_early data_net_late data_net_early \
      clock_cell_late clock_cell_early clock_net_late clock_net_early \
      cell_check_late cell_check_early \
      opcond  opcond_library power_domains \
      constraint_mode \
      derate_tcl \
      pre_cts_sdc post_cts_sdc  incr_cts_sdc \ 
      active_setup_views active_hold_views \
      pre_endcap post_endcap \
      cell_interval row_offset checkerboard verify_rule \
      max_gap cell_interval checker_board  \
      max_distance max_fanout max_tran max_delay \ 
      always_on_buffers cell_pin_pairs nets non_default_rule \
      switchable switch_type checker_board back_to_back_chain \
      loop_back_at_end check_height verify_rows enable_chain \
      pre_tcl post_tcl replace_tcl skip \
      to steps library_file \
      script queue host_list args resource \
      verbose verbosity_level \
      welltaps, tie_cells, filler_cells \
      pac_mode ilm_dir lef_file \
      starting_dbs assemble_dbs \
      latency_sdc cts_spec \
      edi_config_tcl qor_tcl \
      rpt_dir skip pre_tcl post_tcl \
   "

   if {[info exists vars(power_domains)]} {
      append valid_prefixes $vars(power_domains)
      append valid_suffixes "bbox max_gap rs_exts"
   }

   set valid_midfixes "\
      set_distribute_host \
      set_multi_cpu_usage \
      set_distribute_host \
      set_multi_cpu_usage \
      set_rc_factor \
      derate_timing \
      create_rc_corner \
      create_library_set \
      create_delay_corner \
      create_constraint_mode \
      create_analysis_view \
      update_delay_corner \
      update_library_set \
      derate_timing \
      set_default_view \
      set_power_analysis_mode \
      load_config \
      load_floorplan \
      generate_tracks \
      load_cpf \
      commit_cpf \
      read_activity_file \
      specify_ilm \
      load_ilm_non_sdc_file \
      initialize_timing \
      load_scan \
      specify_spare_gates \
      set_dont_use \
      set_max_route_layer \
      set_design_mode \
      insert_welltaps_endcaps \
      load_config \
      time_design \
      check_design \
      check_timing \
      report_power_domains \
      set_distribute_host \
      set_multi_cpu_usage \
      restore_design \
      initialize_step \
         set_design_mode \
         set_delay_cal_mode \
         set_place_mode \
         set_opt_mode \
         cleanup_specify_clock_tree \
         specify_clock_tree \
      specify_jtag \
      place_jtag \
      place_design \
      add_tie_cells \
      time_design \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_design_mode \
         set_ilm_type \
         cleanup_specify_clock_tree \
         create_clock_tree_spec \
         specify_clock_tree \
         set_useful_skew_mode \
         set_opt_mode \
         set_design_mode \
         set_delay_cal_mode \
         set_dont_use \
      opt_design \
      ck_clone_gate \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_design_mode \
         set_cts_mode \
         set_nanoroute_mode \
      enable_clock_gate_cells \
      clock_design \
      disable_clock_gate_cells \
      run_clock_eco \
      update_timing \
      time_design \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_design_mode \
         set_delay_cal_mode \
         set_analysis_mode \
         set_opt_mode \
      opt_design \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_dont_use \
         set_opt_mode \
      opt_design \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_nanoroute_mode \
         add_filler_cells \
      route_secondary_pg_nets \
      check_place \
      route_design \
      run_clock_eco \
      spread_wires \
      initialize_timing \
      time_design \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_design_mode \
         set_extract_rc_mode \
         set_analysis_mode \
         set_delay_cal_mode \
      add_metalfill \
      delete_filler_cells \
      opt_design \
      add_filler_cells \
      trim_metalfill \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_dont_use_mode \
         set_opt_mode \
      delete_filler_cells \
      opt_design \
      add_filler_cells \
      trim_metalfill \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_design_mode \
         set_extract_rc_mode \
         set_si_mode \
         set_analysis_mode \
         set_delay_cal_mode \
      add_metalfill \
      delete_filler_cells \
      opt_design \
      add_filler_cells \
      trim_metalfill \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_design_mode \
         set_dont_use \
         set_opt_mode \
         set_extract_rc_mode \
         set_si_mode \
         set_delay_cal_mode \
         set_analysis_mode \
      add_metalfill \
      delete_filler_cells \
      opt_design \
      add_filler_cells \
      trim_metalfill \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_timing \
      initialize_step \
         set_analysis_mode \
         set_extract_rc_mode \
      extract_rc \
      dump_spef \
      time_design_setup \
      time_design_hold \
      stream_out \
      save_oa_design \
      create_ilm \
      summary_report \
      verify_connectivity \
      verify_geometry \
      verify_metal_density \
      verify_process_antenna \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
      initialize_timing \
      load_cpf \
      commit_cpf \
      run_clp_init \
      save_init_dbs \
      set_budgeting_mode \
      update_constraint_mode \
      set_ptn_user_cns_file \
      set_place_mode \
      place_design \
      save_place_dbs \
      trial_route \
      assign_ptn_pins \
      check_pin_assignment \
      report_unaligned_nets \
      set_ptn_pin_status \
      derive_timing_budget \
      save_budget_dbs \
      run_clp \
      partition \
      save_partition \
      assemble_design \
      specify_ilm \
      load_ilm_non_sdc_file \
      load_cpf \
      commit_cpf \
      initialize_timing \
      update_timing \
      pre_pac_verify_connectivity \
      pre_pac_verify_geometry \
      set_module_view \
      delete_filler_cells \
      opt_design \
      add_filler_cells \
      post_pac_verify_connectivity \
      post_pac_verify_geometry \
   "
   
   set prefix_count 0
   set midfix_count 0
   set suffix_count 0
   
   foreach variable [array names vars] {
      set split [split $variable ","]
      if {[llength $split] == 1} {
         continue
      } elseif {[llength $split] == 2} {
         set prefix [lindex $split 0]
         set suffix [lindex $split 1]
         puts $op "Checking $prefix + $suffix"
         if {[lsearch $valid_prefixes $prefix] == -1} {
            incr prefix_count
            puts $op "<FF> ERROR Unknown prefix -> $prefix ($variable)"
            puts "<FF> ERROR Unknown prefix -> $prefix ($variable)"
   #         append commands "#  ERROR: A verilog netlist file must be defined\n"
            set errors($error_count) "Unknown prefix -> $prefix ($variable)"
            incr error_count
         } 
         if {[lsearch $valid_suffixes $suffix] == -1} {
            incr suffix_count
            puts $op "<FF> ERROR Unknown suffix -> $suffix ($variable)"
            puts "<FF> ERROR Unknown suffix -> $suffix ($variable)"
            set errors($error_count) "Unknown suffix -> $prefix ($variable)"
            incr error_count
         }
      } elseif {[llength $split] == 3} {
         set prefix [lindex $split 0]
         set midfix [lindex $split 1]
         set suffix [lindex $split 2]
         puts $op "Checking $prefix + $midfix + $suffix"
         if {[lsearch $valid_prefixes $prefix] == -1} {
            incr prefix_count
            puts $op "<FF> ERROR Unknown prefix -> $prefix ($variable)"
            puts "<FF> ERROR Unknown prefix -> $prefix ($variable)"
            set errors($error_count) "Unknown prefix -> $prefix ($variable)"
            incr error_count
         } 
         if {[lsearch $valid_midfixes $midfix] == -1} {
            incr midfix_count
            puts $op "<FF> ERROR Unknown midfix -> $prefix ($variable)"
            puts "<FF> ERROR Unknown midfix -> $prefix ($variable)"
            set errors($error_count) "Unknown midfix -> $midfix ($variable)"
            incr error_count
         } 
         if {[lsearch $valid_suffixes $suffix] == -1} {
            incr suffix_count
            puts $op "<FF> WARNING Unknown suffix -> $suffix ($variable)"
            puts "<FF> WARNING Unknown suffix -> $suffix ($variable)"
            set errors($error_count) "Unknown suffix -> $prefix ($variable)"
            incr error_count
         }
      } else {
         continue
      }
   }
   
   close $op

}
