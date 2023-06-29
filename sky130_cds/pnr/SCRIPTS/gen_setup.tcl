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

proc conv2mmmc {} {

   global rda_Input

   if {![info exists slow_libs]} {
      set slow_libs [list]
   } 
   if {![info exists fast_libs]} {
      set fast_libs [list]
   } 

   if {$rda_Input(ui_timelib,max) != ""} {
      foreach lib $rda_Input(ui_timelib,max) {
         foreach glob_lib [glob $lib] {
            if {[file isdirectory $glob_lib]} {
               foreach nested_glob_lib [glob $glob_lib/\*] {
                  lappend slow_libs $nested_glob_lib
               }
            } else {
               lappend slow_libs $glob_lib
            }
         }
      }
      foreach lib $rda_Input(ui_timelib) {
         foreach glob_lib [glob $lib] {
            if {[file isdirectory $glob_lib]} {
               foreach nested_glob_lib [glob $glob_lib/\*] {
                  lappend slow_libs $nested_glob_lib
               }
            } else {
               lappend slow_libs $glob_lib
            }
         }
      }
   #   set slow_libs [concat $rda_Input(ui_timelib,max) $rda_Input(ui_timelib)]
   } else {
      foreach lib $rda_Input(ui_timelib) {
         foreach glob_lib [glob $lib] {
            if {[file isdirectory $glob_lib]} {
               foreach nested_glob_lib [glob $glob_lib/\*] {
                  lappend slow_libs $nested_glob_lib
               }
            } else {
               lappend slow_libs $glob_lib
            }
         }
      }
   #   set slow_libs $rda_Input(ui_timelib)
   }
   if {$rda_Input(ui_timelib,min) != ""} {
      foreach lib $rda_Input(ui_timelib,min) {
         foreach glob_lib [glob $lib] {
            if {[file isdirectory $glob_lib]} {
               foreach nested_glob_lib [glob $glob_lib/\*] {
                  lappend fast_libs $nested_glob_lib
               }
            } else {
               lappend fast_libs $glob_lib
            }
         }
      }
      foreach lib $rda_Input(ui_timelib) {
         foreach glob_lib [glob $lib] {
            if {[file isdirectory $glob_lib]} {
               foreach nested_glob_lib [glob $glob_lib/\*] {
                  lappend fast_libs $nested_glob_lib
               }
            } else {
               lappend fast_libs $glob_lib
            }
         } 
      }
   #   set fast_libs [concat $rda_Input(ui_timelib,min) $rda_Input(ui_timelib)]
   } else {
      set fast_libs $slow_libs
   }
   
   #puts "--------------------------------------------------------------------------------------" 
   #puts "PQRS: $slow_libs"
   #puts "PQRS: $fast_libs"
   #puts "--------------------------------------------------------------------------------------" 
   
   set sdc_files [list]
   foreach file $rda_Input(ui_timingcon_file) {
      lappend sdc_files $file
   }
   
   set ilm_sdc_files [list]
   if {[info exists rda_Input(ui_timingcon_file,full)]} {
      foreach file $rda_Input(ui_timingcon_file,full) {
         lappend ilm_sdc_files $file
      }
   }
   
   if {$rda_Input(ui_cdb_file,max) != ""} {
      set slow_cdbs [concat $rda_Input(ui_cdb_file,max) $rda_Input(ui_cdb_file)]
   } else {
      if {$rda_Input(ui_cdb_file) != ""} {
         set slow_cdbs $rda_Input(ui_cdb_file)
      }
   }
   if {$rda_Input(ui_cdb_file,min) != ""} {
      set fast_cdbs [concat $rda_Input(ui_cdb_file,min) $rda_Input(ui_cdb_file)]
   } else {
      if {$rda_Input(ui_cdb_file) != ""} {
         set fast_cdbs $rda_Input(ui_cdb_file)
      } else {
         if {[info exists slow_cdbs] && ($slow_cdbs != "")} {
            set fast_cdbs $slow_cdbs
        }
     }
   }

   set bc_cap_table ""
   set wc_cap_table ""
  
   if {[llength $rda_Input(ui_captbl_file)] > 1} {
      for {set i 0} {$i<[llength $rda_Input(ui_captbl_file)]} {incr i} {
         if {[lindex $rda_Input(ui_captbl_file) $i] == "-best"} {
            set bc_cap_table [file normalize [lindex $rda_Input(ui_captbl_file) [expr $i+1]]]
         }
         if {[lindex $rda_Input(ui_captbl_file) $i] == "-worst"} {
            set wc_cap_table [file normalize [lindex $rda_Input(ui_captbl_file) [expr $i+1]]]
         }
      }
   } else {
      set wc_cap_table [file normalize $rda_Input(ui_captbl_file)]
      set bc_cap_table [file normalize $rda_Input(ui_captbl_file)]
   }
   
   set bc_qx_tech_file ""
   set wc_qx_tech_file ""
   
   if {[llength $rda_Input(ui_qxtech_file)] > 1} {
      for {set i 0} {$i<[llength $rda_Input(ui_qxtech_file)]} {incr i} {
         if {[lindex $rda_Input(ui_qxtech_file) $i] == "-best"} {
            set bc_qx_tech_file [file normalize [lindex $rda_Input(ui_qxtech_file) [expr $i+1]]]
         }
         if {[lindex $rda_Input(ui_qxtech_file) $i] == "-worst"} {
            set wc_qx_tech_file [file normalize [lindex $rda_Input(ui_qxtech_file) [expr $i+1]]]
         }
      }
   } else {
      set wc_qx_tech_file [file normalize $rda_Input(ui_qxtech_file)]
      set bc_qx_tech_file [file normalize $rda_Input(ui_qxtech_file)]
   }
   
   
#   if {$wc_cap_table == ""} {
#      Puts "--------------------------------------------------------------------------------------" 
#      Puts "\[PQRS\]\[ERROR\] No cap tables defined for this testcase ... aborting"
#      Puts "--------------------------------------------------------------------------------------" 
#      exit 1
#   }
   
   if {([info exists dgn_max_temp] == 0) || ([info exists dgn_max_temp] && $dgn_max_temp == "")} {
      set max_temp ""
   } else {
      set max_temp $dgn_max_temp
   }
   
   if {([info exists dgn_min_temp] == 0) || ([info exists dgn_min_temp] && $dgn_min_temp == "")} {
      set min_temp ""
   } else {
      set min_temp [expr abs($dgn_min_temp)]
   }

   set pre_route_res_factor $rda_Input(ui_preRoute_res)
   set pre_route_clk_res_factor 1.0
   set post_route_res_factor $rda_Input(ui_postRoute_res)
   set post_route_clk_res_factor "1.0 1.0 1.0"
   set pre_route_cap_factor $rda_Input(ui_preRoute_cap)
   set pre_route_clk_cap_factor 1.0
   set post_route_cap_factor $rda_Input(ui_postRoute_cap)
   set post_route_clk_cap_factor "1.0 1.0 1.0"
   set post_route_xcap_factor $rda_Input(ui_postRoute_xcap)
   set shrink_factor $rda_Input(ui_shr_scale)
#   set relative_c_thresh $rda_Input(ui_rel_c_thresh)
#   set total_c_thresh $rda_Input(ui_tot_c_thresh)
#   set coupling_c_thresh $rda_Input(ui_cpl_c_thresh)

   create_rc_corner -name rc_max  \
                    -preRoute_res $pre_route_res_factor \
                    -preRoute_clkres $pre_route_clk_res_factor \
                    -preRoute_cap $pre_route_cap_factor \
                    -preRoute_clkcap $pre_route_clk_cap_factor \
                    -postRoute_res $post_route_res_factor \
                    -postRoute_clkres $post_route_clk_res_factor \
                    -postRoute_cap $post_route_cap_factor \
                    -postRoute_clkcap $post_route_clk_cap_factor \
                    -postRoute_xcap $post_route_xcap_factor
  
   if {$wc_cap_table != ""} {
      update_rc_corner -name rc_max -cap_table $wc_cap_table
   }
   if {$max_temp != ""} {
      update_rc_corner -name rc_max -T $max_temp
   }

   if {$wc_qx_tech_file != "" } {
      update_rc_corner -name rc_max -qx_tech_file $wc_qx_tech_file
   }
    
   create_rc_corner -name rc_min  \
                    -preRoute_res $pre_route_res_factor \
                    -preRoute_clkres $pre_route_clk_res_factor \
                    -preRoute_cap $pre_route_cap_factor \
                    -preRoute_clkcap $pre_route_clk_cap_factor \
                    -postRoute_res $post_route_res_factor \
                    -postRoute_clkres $post_route_clk_res_factor \
                    -postRoute_cap $post_route_cap_factor \
                    -postRoute_clkcap $post_route_clk_cap_factor \
                    -postRoute_xcap $post_route_xcap_factor
   
   if {$bc_cap_table != ""} {
      update_rc_corner -name rc_min -cap_table $bc_cap_table
   }
   if {$min_temp != ""} {
      update_rc_corner -name rc_min -T $min_temp
   }

   if {$bc_qx_tech_file != "" } {
      update_rc_corner -name rc_min -qx_tech_file $bc_qx_tech_file
   }
    
   if {[info exists slow_cdbs] && ($slow_cdbs != "")} {
      create_library_set -name libs_max -timing $slow_libs -si $slow_cdbs 
      create_library_set -name libs_min -timing $fast_libs -si $fast_cdbs 
   } else {
      create_library_set -name libs_max -timing $slow_libs
      create_library_set -name libs_min -timing $fast_libs
   }
   
   create_delay_corner -name corner_max -library_set libs_max -rc_corner rc_max
   create_delay_corner -name corner_min -library_set libs_min -rc_corner rc_min
   Puts "\[INFO\] create_constraint_mode setup_func_mode with "
   Puts "\[INFO\]   SDC files: $sdc_files"
   if {$ilm_sdc_files != ""} {
     Puts "\[INFO\]   ILM SDC files: $ilm_sdc_files" 
     create_constraint_mode -name setup_func_mode -sdc_files $sdc_files -ilm_sdc_files ilm_sdc_files
   } else {
     create_constraint_mode -name setup_func_mode -sdc_files $sdc_files 
   }
   create_analysis_view -name setup_func -constraint_mode setup_func_mode -delay_corner corner_max
#   Puts "\[INFO\] create_constraint_mode hold_func_mode with "
#   Puts "\[INFO\]   SDC files: $sdc_files"
#   if {$ilm_sdc_files != ""} {
#     Puts "\[INFO\]   ILM SDC files: $ilm_sdc_files" 
#     create_constraint_mode -name hold_func_mode -sdc_files $sdc_files -ilm_sdc_files ilm_sdc_files
#   } else {
#     create_constraint_mode -name hold_func_mode -sdc_files $sdc_files 
#   }
   create_analysis_view -name hold_func -constraint_mode setup_func_mode -delay_corner corner_min
   set_analysis_view -setup {setup_func} -hold {hold_func} 
   set_default_view -setup {setup_func} -hold {hold_func} 
   set_interactive_constraint_modes [all_constraint_modes -active] 
}

proc create_lp_config_file {} {

   global vars

   set op [open lp_config.auto.tcl w]

   if {[file exists setup.auto.tcl]} {
      source setup.auto.tcl
   }
   if {[file exists innovus_config.auto.tcl]} {
      source innovus_config.auto.tcl
   }

   puts $op "##########################################################################################"
   puts $op "# Low power configuration file overlay.  This file contains foundation flow variables"
   puts $op "# that are specific to the LP flow and should be used in addition to the setup.tcl"
   puts $op "##########################################################################################"
   puts $op "#                           Tie cell information"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# The variable vars(tie_cells) is defined in the setup.tcl and is used to define a "
   puts $op "# \"global\" tie cell list. This list will be used by default for each power domain."
   puts $op "# It can be overridden for a given power domain by setting vars(<power_domain>,tie_cells)."
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "#"
   puts $op "##########################################################################################"
   puts $op "#                         Placement Options"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "#set vars(resize_shifter_and_iso_insts) <true | false>"
   puts $op "#"
   if {[info exists vars(power_domains)]} {
      foreach domain $vars(power_domains) {
         if {[info exists vars(tie_cells)]} {
            puts $op "# set vars($domain,tie_cells)\t\"$vars(tie_cells)\""
         } else {
            puts $op "# set vars($domain,tie_cells)    <tie cells for <power_domain>>"
         }
      }
   }
   puts $op "#"
   puts $op "##########################################################################################"
   puts $op "#                         Filler cell information"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# The variable vars(filler_cells) is defined in the setup.tcl and is used to define a "
   puts $op "# \"global\" filler cell list. This list will be used by default for each power domain."
   puts $op "# It can be overridden for a given power domain by setting vars(<power_domain>,filler_cells)."
   puts $op "# ----------------------------------------------------------------------------------------"
   if {[info exists vars(power_domains)]} {
      foreach domain $vars(power_domains) {
         if {[info exists vars(filler_cells)]} {
            puts $op "# set vars($domain,filler_cells)\t\"$vars(filler_cells)\""
         } else {
            puts $op "# set vars($domain,filler_cells) <filler cells for <power_domain>>"
         }
      }
   }
   puts $op "#"
   puts $op "##########################################################################################"
   puts $op "#                          Welltap cell information"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# The variable vars(welltaps) is defined in the setup.tcl and is used to define a "
   puts $op "# \"global\" welltap cell list. This list will be used by default for each power domain."
   puts $op "# It can be overridden for a given power domain by setting vars(<power_domain>,welltaps)."
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "#    verify_rule : maximum distance (in microns) between welltap cells and standard cells "
   puts $op "#                  in microns"
   puts $op "#        max_gap : specifies the maximum distance from the right edge of one well-tap cell "
   puts $op "#                  to the left edge of  the following well-tap cell in the same row"
   puts $op "#  cell_interval : specifies the maximum distance from the center of one well-tap cell "
   puts $op "#                  to the center of the following well-tap cell in the same row"
   puts $op "#"
   puts $op "# NOTE: max_gap and cell_interval parameters are mutually exclusive, user has to define "
   puts $op "#       only one of these parameters to add welltap cells"
   puts $op "#"
   puts $op "# ----------------------------------------------------------------------------------------"
   if {[info exists vars(power_domains)]} {
      foreach domain $vars(power_domains) {
         if {[info exists vars(welltaps)]} {
            puts $op "# set vars($domain,vars(welltaps))                 <welltap cell list for <power_domain>>"
         } else {
            puts $op "# set vars($domain,welltaps)                 <welltap cell list for <power_domain>>"
         } 
         puts $op "# set vars($domain,welltaps,checkerboard)  <true or false>"
         puts $op "# set vars($domain,welltaps,max_gap)       <max gap in microns>"
         puts $op "# set vars($domain,welltaps,cell_interval) <cell interval in microns>"
         puts $op "# set vars($domain,welltaps,row_offset)    <row offset in microns>"
         puts $op "# set vars($domain,welltaps,verify_rule)   <verify rule distance>"
      }
   }
   puts $op "#"
   puts $op "##########################################################################################"
   puts $op "#                          Endcap cell information"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# The variables vars(pre_endcap) and vars(post_endcap) are set in the setup.tcl file and"
   puts $op "# are used to define \"global\" endcap cells. These used by default for each power domain."
   puts $op "# They can be overridden for a given power domain setting vars(<power_domain>,pre_endcap)"
   puts $op "# and/or vars(<power_domain>,post_endcap)."
   puts $op "# ----------------------------------------------------------------------------------------"
   if {[info exists vars(power_domains)]} {
      foreach domain $vars(power_domains) {
         puts $op "# set vars($domain,pre_endcap)  <pre endcap cell for <power_domain>>"
         puts $op "# set vars($domain,post_endcap) <post endcap cell for <power_domain>>"
      }
   }
   puts $op "#"
   puts $op "##########################################################################################"
   puts $op "#                            Always on net buffering"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# By default SOCE does always-on-net synthesis for SRPG control signal and PSO enable "
   puts $op "# signals as part of optDesign -preCTS, but this can be manually done for specific nets if"
   puts $op "# necessary.  To do this, define the following variables and uncomment the pre_prects.tcl"
   puts $op "# plug-in template"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(always_on_buffers)                   <list of always on buffers>"
   puts $op "# set vars(always_on_nets)                      <list of always on nets>"
   puts $op "# set vars(always_on_nets,max_fanout)           <max fanout limit for always on nets> (optional)"
   puts $op "# set vars(always_on_nets,max_tran)             <max transition on always on nets> (optional)"
   puts $op "# set vars(always_on_nets,max_skew)             <max skew for always on nets> (optional)"
   puts $op "# set vars(always_on_nets,max_delay)            <max delay for always on nets> (optional)"
   if {[info exists vars(power_domains)]} {
      foreach domain $vars(power_domains) {
         puts $op "# set vars($domain,always_on_buffers)  <buffers for <power domain>>"
      }
   }
   puts $op "#"
   puts $op "##########################################################################################"
   puts $op "#                      Secondary power/ground routing"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# Automatic secondary power routing can be enabled the foundation flows by setting "
   puts $op "# vars(route_secondary_pg_nets) to true and providing cell pin pair information to"
   puts $op "# identify the connections requiring routing (PTBUFFD1:TVDD LVLLHCD4:VDDL, e.g.) "
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(route_secondary_pg_nets)         \[true | false\]"
   puts $op "# set vars(secondary_pg,cell_pin_pairs)     <secondary power cell pin pair list>"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "#In addition, the following can optionally defined either globally or per p/g net"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(secondary_pg,max_fanout)           <max fanout for secondary power routing>"
   puts $op "# set vars(secondary_pg,pattern)              <secondary power routing pattern trunk | steiner>"
   puts $op "# set vars(secondary_pg,non_default_rule)     <non-default rule for secondary p/g/ routing>"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# To optionally override for a given p/g net(s), use the vars(route_secondary_pg_nets) to "
   puts $op "# define the list of nets to be overridden and then override vars(<p/g net>,<option>)"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(secondary_pg,nets)                  <list of power/ground nets>"
   puts $op "# set vars(<p/g_net>,max_fanout)               <max fanout>"
   puts $op "# set vars(<p/g_net>,pattern)                  <trunk | steiner>"
   puts $op "# set vars(<p/g_net>,non_default_rule)         <non default rule>"
   puts $op "#"
   puts $op "##########################################################################################"
   puts $op "#                              runCLP options"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(clp_options)  <options for runCLP>"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(clp_options)  \"\""
   puts $op "#"
   puts $op "##########################################################################################"
   puts $op "#              Modify power domains, row creation for power domains"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# The foundation flows contain a sample post_init_tcl (PLUG/post_init.tcl) plug-in to do "
   puts $op "# power domain modification automatically based on the folloing variables:"
   puts $op "# ----------------------------------------------------------------------------------------"
   if {[info exists vars(power_domains)]} {
      foreach domain $vars(power_domains) {
         puts $op "# set vars($domain,bbox)         <llx lly urx ury>; bondary coordinates in microns"
         puts $op "# set vars($domain,rs_exts)      <top bot left right>; distance in microns  "
         puts $op "# set vars($domain,min_gaps)     <top bot left right>; distance in microns"
      }
   }
   puts $op "#"
   puts $op "##########################################################################################"
   puts $op "#                           Power Shut-off Planning "
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# The foundation flows contain a sample post_init_tcl (PLUG/post_init.tcl) plug-in to do "
   puts $op "# power switch insertion automatically based on the following information:"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(<power_domain>,switchable)         <true | false>"
   puts $op "# set vars(<power_domain>,switch_type)        <column | ring>"
   puts $op "# set vars(<power_domain>,switch_cell)        <PSO cell name>"
   puts $op "# set vars(<power_domain>,input_enable_pin)   <PSO cell input enable pin>"
   puts $op "# set vars(<power_domain>,output_enable_pin)  <PSO cell output enable pin>"
   puts $op "# set vars(<power_domain>,input_enable_net)   <PSO cell input enable net>"
   puts $op "# set vars(<power_domain>,output_enable_net)  <PSO cell output enable net>"
   puts $op "# set vars(<power_domain>,switch_instance)    <switchModuleInstance>"
   puts $op "# set vars(<power_domain>,top_offset)         <top offset in microns>"
   puts $op "# set vars(<power_domain>,bottom_offset)      <bottom offset in microns>"
   puts $op "# set vars(<power_domain>,right_offset)       <right offset in microns>"
   puts $op "# set vars(<power_domain>,left_offset)        <left offset in microns>"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# Below variables are for column based pso implemetation"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(<power_domain>,checker_board)     <true | false>"
   puts $op "# set vars(<power_domain>,horizonal_pitch)   <in microns>"
   puts $op "# set vars(<power_domain>,column_height)     <Switch cell column height in microns>"
   puts $op "# set vars(<power_domain>,skip_rows)         <Number of rows to skip>"
   puts $op "# set vars(<power_domain>,back_to_back_chain) <true|false>"
   puts $op "# ... Connects the enableNetOut at the top of a column to the enableNetIn at the top of "
   puts $op "# ... the next column, and connects the enableNetOut at the bottom of the column to the "
   puts $op "# ... enableNetIn at the bottom of the next column"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# Below variables are for ring based pso implemetation"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(<power_domain>,top_ring)     <1|0>"
   puts $op "# set vars(<power_domain>,bottom_ring)  <1|0>"
   puts $op "# set vars(<power_domain>,right_ring)   <1|0>"
   puts $op "# set vars(<power_domain>,left_ring)    <1|0>"
   puts $op "# ... defines which side of the power domain to insert switches:"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(<power_domain>,top_switch_cell)    <pso cell name>"
   puts $op "# set vars(<power_domain>,bottom_switch_cell) <pso cell name>"
   puts $op "# set vars(<power_domain>,left_switch_cell)   <pso cell name>"
   puts $op "# set vars(<power_domain>,right_switch_cell)  <pso cell name>"
   puts $op "# ... define pso cell name for each side of the power domain"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(<power_domain>,top_filler_cell)    <filler cell name>"
   puts $op "# set vars(<power_domain>,bottom_filler_cell) <filler cell name>"
   puts $op "# set vars(<power_domain>,left_filler_cell)   <filler cell name>"
   puts $op "# set vars(<power_domain>,right_filler_cell)  <filler cell name>"
   puts $op "# set vars(<power_domain>,corner_cell_list)   <corner cell name>"
   puts $op "# ... define filler cell name for each side of the power domain"
   puts $op "# ----------------------------------------------------------------------------------------"
   puts $op "# set vars(<power_domain>,distribute)         <true or false>"
   puts $op "# set vars(<power_domain>,top_switches)       <integer>"
   puts $op "# set vars(<power_domain>,bottom_switches)    <integer>"
   puts $op "# set vars(<power_domain>,left_switches)      <integer>"
   puts $op "# set vars(<power_domain>,right_switches)     <integer>"
   puts $op "# ... define the number of switches for each side of the power domain"
   puts $op "#"

   close $op

   Puts "<FF> ------------------------------------------------------------------------------------"
   Puts "<FF> Created low power config file \"lp_config.auto.tcl\""
   Puts "<FF>    This file is used to define variables specific to the LP foundation flow."
   Puts "<FF>    All the informaiton in this file is optional but is intended to help "
   Puts "<FF>    automate some of the most common LP commands.  Please edit and copy"
   Puts "<FF>    to lp_config.tcl to enable (make sure it is sourced from setup.tcl)."

}

proc create_invs_tag_file {} {

   global vars
   global tags

   set steps [list "feedthrough" "assign_pin" "model_gen" "partition" \
                 "init" "place" "prects" "cts" "postcts" "postcts_hold" "route" \
                 "postroute" "postroute_hold" "signoff" "assemble"]

   set tags(init) [list \
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
      init_design \
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
      time_design \
      check_design \
      check_timing \
      report_power_domains \
      ff_replace_flexmodel_with_full_netlist \
   ]
   set tags(place) [list \
      set_distribute_host \
      set_multi_cpu_usage \
      restore_design \
      initialize_step \
         set_design_mode \
         set_delay_cal_mode \
         set_place_mode \
         set_opt_mode \
         set_tie_hilo_mode \
         cleanup_specify_clock_tree \
         specify_clock_tree \
      specify_jtag \
      place_jtag \
      place_design \
      place_opt_design \
      add_tie_cells \
      time_design \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
   ]
   set tags(prects) [list \
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
   ]
   set tags(cts) [list \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_design_mode \
         set_cts_mode \
         set_ccopt_mode \
         set_nanoroute_mode \
      enable_clock_gate_cells \
      cleanup_specify_clock_tree \
      create_clock_tree_spec \
      specify_clock_tree \
      clock_design \
      ccopt_design \
      disable_clock_gate_cells \
      run_clock_eco \
      update_timing \
      time_design \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
   ]
   set tags(postcts) [list \
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
   ]
   set tags(postcts_hold) [list \
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
   ]
   set tags(route) [list \
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
   ]
   set tags(postroute) [list \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_design_mode \
         set_extract_rc_mode \
         set_analysis_mode \
         set_delay_cal_mode \
      add_metalfill \
      opt_design \
      trim_metalfill \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
   ]
   set tags(postroute_hold) [list \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_step \
         set_dont_use_mode \
         set_opt_mode \
      opt_design \
      trim_metalfill \
      save_design \
      report_power \
      verify_power_domain \
      run_clp \
   ]
   set tags(signoff) [list \
      set_distribute_host \
      set_multi_cpu_usage \
      initialize_timing \
      initialize_step \
         set_analysis_mode \
         set_extract_rc_mode \
      extract_rc \
      dump_spef \
      signoff_time_design \
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
   
   ]
   set tags(feedthrough) [list \
      initialize_timing \
      load_cpf \
      commit_cpf \
      run_clp_init \
      save_init_dbs \
      set_budgeting_mode \
      update_constraint_mode \
      set_ptn_user_cns_file \
      set_place_mode \
      set_proto_model \
      place_design \
      time_design \
      save_place_dbs \
      insert_ptn_feedthrough \
      trial_route \
      trial_route_time_design \
   ]
   set tags(assign_pin) [list \
      assign_ptn_pins \
      check_pin_assignment \
      report_unaligned_nets \
      trial_route \
   ]
   set tags(model_gen) [list \
      create_ps_per_micron_model \
      identify_proto_model \
      report_proto_model \
      setIlmMode \
      create_proto_model \
      create_flexfiller_route_blockage \
      report_proto_model \
      saveDesign \
   ]
   set tags(partition) [list \
      time_design_proto \
      set_pspm_vars \
      set_budgeting_mode \
      set_ptn_pin_status \
      derive_timing_budget \
      save_budget_dbs \
      run_clp \
      partition \
      save_partition \
   ]
   set tags(assemble) [list \
      assemble_design \
      specify_ilm \
      load_ilm_non_sdc_file \
      load_cpf \
      commit_cpf \
      initialize_timing \
      update_timing \
      pre_signoff_eco_verify_connectivity \
      pre_signoff_eco_verify_geometry \
      set_module_view \
      delete_filler_cells \
      opt_design \
      extract_rc \
      signoff_opt_design \
      signoff_time_design \
      add_filler_cells \
      eco_route \
      post_signoff_eco_verify_connectivity \
      post_signoff_eco_verify_geometry \
   ]

   set op [open invs.auto.tcl w]

   puts $op "##########################################################################################"
   puts $op "#                             CDNS FOUNDATION FLOW"
   puts $op "#-----------------------------------------------------------------------------------------"
   puts $op "# This is the foundation flow tags file.  Each flow step is a sequence of commands and" 
   puts $op "# each command has a tag associated with it and each tag has four attributes:"
   puts $op "#-----------------------------------------------------------------------------------------"
   puts $op "#       pre_tcl -> file to be sourced prior to the command"
   puts $op "#      post_tcl -> file to be sourced after the command"
   puts $op "#   replace_tcl -> file to be sourced instead of the command"
   puts $op "#          skip -> skip the command entirely (true | false)"
   puts $op "#-----------------------------------------------------------------------------------------"
   puts $op "# These attributes provide more granularity that the plug-ins and are intended to"
   puts $op "# allow for flow customization at a very detailed level.  To enable, simply uncomment"
   puts $op "# the tag, assign the appropriate value, and make sure this file gets sourced"
   puts $op "# from the setup.tcl or innovus_config.tcl.  Keep in mind, these tags will only"
   puts $op "# be evaluated if the command they are associated is executed as part of the flow"
   puts $op "#-----------------------------------------------------------------------------------------"
   puts $op "#         verbose -> Print tag related comments for imported tags"
   puts $op "# verbosity_level -> Print tag related comments for ALL possible tags \[LOW | HIGH\]"
   puts $op "#-----------------------------------------------------------------------------------------"

   foreach step $steps {
      foreach command $tags($step) {
         foreach tag "pre_tcl post_tcl replace_tcl skip" {
            set string "#set vars($step,$command,$tag)"
            set length [string length $string]
            set diff [expr 60-$length]
            set spaces [string repeat " " $diff]
            if {$tag == "skip"} {
               puts $op [format "%s%s%s" $string $spaces "<true or false>"]
            } else {
               puts $op [format "%s%s%s" $string $spaces "<file>"]
            }
         }
      }
      puts $op "# ----------------------------------------------------------------------------------------"
   }

}

proc pad {a {add 0}} {
   
   if {[expr [string length $a] + $add] < 6} {
      return "\t\t\t\t"
   } elseif {[expr [string length $a] + $add] < 12} { 
      return "\t\t\t"
   } elseif {[expr [string length $a] + $add] < 18} { 
      return "\t\t"
   } elseif {[expr [string length $a] + $add] < 24} { 
      return "\t"
   }

}

proc format_string {a b {large 0}} {

   set add 0

   if {[regexp "#" $a]} {
      regsub "#" $a "" a
      set add 1
   }

#   puts "$a, [string length $a]"

   if {$large} {
      if {[expr [string length $a] + $add] < 4} {
         set tabs "\t\t\t\t\t\t\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 8} { 
         set tabs "\t\t\t\t\t\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 12} { 
         set tabs "\t\t\t\t\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 16} { 
         set tabs "\t\t\t\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 20} { 
         set tabs "\t\t\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 24} { 
         set tabs "\t\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 28} { 
         set tabs "\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 32} { 
         set tabs "\t\t\t"
      } else {
         set tabs "\t\t"
      }
   } else {
      if {[expr [string length $a] + $add] < 4} {
         set tabs "\t\t\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 8} { 
         set tabs "\t\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 12} { 
         set tabs "\t\t\t\t"
      } elseif {[expr [string length $a] + $add] < 16} { 
         set tabs "\t\t\t"
      } elseif {[expr [string length $a] + $add] < 20} { 
         set tabs "\t\t"
      } else {
         set tabs "\t"
      }
   }

   # Handle the empty string correctly
   if {$b == {}} { set b {{}} }

   if {$add} {
      return [format "#set $a%s%s" $tabs $b] 
   } else {
      return [format "set $a%s%s" $tabs $b] 
   }
}

proc get_line_match {pattern file {last 1}} {

   set ip [open $file r]

   while {[gets $ip line]>=0} {
      if {[regexp "$pattern" $line]>0} {
        if {$last} {
           set match $line
         } else {
           lappend match $line
         }
      }
   }
   if {[info exists match]} { 
      return $match
   }
}

set op1 [open setup.auto.tcl w]
set op2 [open innovus_config.auto.tcl w]

puts $op1 "##########################################################################################"
puts $op1 "#                             CDNS FOUNDATION FLOW"
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "# This is the foundation flow setup file.  It contains all the necessary design"
puts $op1 "# data to drive all the CDNS foundation flows. Each flow can also have an"
puts $op1 "# additional configuration file to define flow specific information:" 
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "# INNOVUS ->   innovus_config.tcl (for flat and hier implementation flows)"
puts $op1 "#         +     lp_config.tcl (additional information for flat and hier lp flows)"
#puts $op1 "#         -> proto_config.tcl (for the prototyping flow)"
#puts $op1 "#     ETS ->   ets_config.tcl"
#puts $op1 "#     EPS ->   eps_config.tcl"
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "# A single setup.tcl is all that is required.  These additional files are to enable "
puts $op1 "# the sharing of a setup.tcl (design data) amongst design groups while also allowing" 
puts $op1 "# different flow options to be set in the *_config.cl files for different blocks or runs"
puts $op1 "##########################################################################################"
puts $op1 ""

puts $op2 "##########################################################################################"
puts $op2 "#                             INNOVUS FOUNDATION FLOW"
puts $op2 "#-----------------------------------------------------------------------------------------"
puts $op2 "# This is the INNOVUS foundation flow configuration file.  It contains all the necessary flow"
puts $op2 "# options to drive the CDNS flat and/or hier implementation flows. "
puts $op2 "# For low power flows, an optional/additional configuration file (lp_config.tcl) can be "
puts $op2 "# used to enable low power foundation flow features and define domain specific information."
puts $op2 "#-----------------------------------------------------------------------------------------"
if {![info exists vars(version)]} {
    set vars(version) 17.1.0
}
if {[lindex [split $vars(version) "."]  0] <= 10 && [llength [all_analysis_views]] == 2} {
   puts "Converting default timing environment to MMMC" 
   conv2mmmc
}

global rda_Input

puts $op1 "##########################################################################################"
puts $op1 "# The variable vars(version) tells the code generator which version of INNOVUS you will be"
puts $op1 "# targeting."
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "set vars(version) $vars(version)"
#puts $op1 "##########################################################################################"
#puts $op1 "# For non-codgen flow, the following must be set - it should point to the foundation " 
#puts $op1 "# flow installation directory"
puts $op1 "#-----------------------------------------------------------------------------------------"
#puts $op1 "#set vars(script_root) SCRIPTS"
#puts $op1 ""
#puts $op2 "# The vars(flow) variable can be used to define the type of flow to run. If not set," 
#puts $op2 "# mmmc will be used.  Supported values are:"
#puts $op2 "#    - default (minmax timing)"
#puts $op2 "#    - pr_mmmc (minmax timing pre-route, mmmc timing post-route)"
#puts $op2 "#    - mmmc    (mmmc timing)"
#puts $op2 "##########################################################################################"
#if {[info exists ::CPF::cpfCommitted]} {
#   puts $op2 "set vars(flow)     mmmc"
#} else {
#   puts $op2 "set vars(flow)     default"
#}
puts $op2 "set vars(plug_dir) PLUG/INNOVUS"
puts $op2 "set vars(dbs_dir)  DBS"
puts $op2 "set vars(log_dir)  LOG"
puts $op2 "set vars(rpt_dir)  RPT"
puts $op2 "# You can set a report directory per step using vars(<step>,rpt_dir) ..."
puts $op2 ""

if {[info exists rda_Input(ui_netlist)]} {
   set vars(netlist) [list]
   foreach  file $rda_Input(ui_netlist) {
      lappend vars(netlist) [file normalize $file]
   }  
} else {
   catch {set vars(netlist) [file normalize [lindex [get_line_match "Reading netlist file" [getLogFileName]] 3]]}
}
catch {set vars(fp_file) [file normalize [lindex [get_line_match "Reading floorplan" [getLogFileName]] 4]]}
#catch {set vars(cts_spec) [regsub -all "'"  [lindex [get_line_match "Reading clock tree spec file" [getLogFileName]] 5] ""]}
#catch {set vars(cts_spec) [regsub -all "\"" $vars(cts_spec)] ""}
set vars(cts_spec) ""
set specOpt [ckGetCkSpecOption]
 for { set i 0 } { $i < [llength $specOpt] } { incr i } {
   if { [string match -nocase [lindex $specOpt $i] "-file" ] ||  [string match -nocase [lindex $specOpt $i] "-specFile" ]  } {
      incr i
      set clkFile [lindex $specOpt $i]
      if { [file exists $clkFile ] } {
         if { [lsearch -exact $vars(cts_spec) $clkFile] == -1 } {
              lappend vars(cts_spec) [file normalize $clkFile]
         }
      }
   }
}

foreach option [getDesignMode -quiet] {
   if {[lindex $option 0] == "process"} {
      set vars(process) [lindex $option 1]nm
   }
}
catch {set vars(max_route_layer) [getMaxRouteLayer]}

puts $op1 "########################################################################################"
puts $op1 "# Define design data ..."
puts $op1 "########################################################################################"
puts $op1 [format_string vars(design) [dbCellName [dbgTopCell]]]

if {[lindex [split $vars(version) "."]  0] > 10} {
   if {[info exists init_verilog] && ($init_verilog != "")} { 
     set vars(netlist) $init_verilog
   }
   if {[info exists init_oa_ref_lib] && ($init_oa_ref_lib != "")} { 
     set vars(oa_ref_lib) $init_oa_ref_lib
   }
#      catch {set restore_design [get_line_match "restoreDesign" [getLogFileName]}
#      set vars(netlist_type) oa
#      set vars(oa_design_lib)  [lindex $restore_design 1]
#      set vars(oa_design_cell) [lindex $restore_design 2]
#      set vars(oa_design_view) [lindex $restore_design 3]
   if {[info exists init_abstract_view] && ($init_abstract_view != "")} {
      set vars(oa_abstract_name) $init_abstract_view
   }
   if {[info exists init_oa_design_lib] && ($init_oa_design_lib != "")} {
      set vars(oa_design_lib) $init_oa_design_lib
   }
   if {[info exists init_oa_design_cell] && ($init_oa_design_cell != "")} {
      set vars(oa_design_cell) $init_oa_design_cell
   }
   if {[info exists init_oa_design_view] && ($init_oa_design_view != "")} {
      set vars(oa_design_view) $init_oa_design_view
   }
   if {[info exists init_abstract_view] && ($init_abstract_view != "")} {
      set vars(oa_abstract_name) $init_abstract_view
   }
   if {[info exists init_layout_view] && ($init_layout_view != "")} {
      set vars(oa_layout_name) $init_layout_view
   }
   puts $op1 "#########################################################################################"
   puts $op1 "# Variables for OA design import and export"
   puts $op1 "# ---------------------------------------------------------------------------------------"
   if {[info exists vars(oa_design_lib)]} {
      puts $op1 "set vars(netlist_type)     oa"
      puts $op1 "set vars(oa_design_lib)    $vars(oa_design_lib)"
   } else {
      puts $op1 "#set vars(oa_design_lib)    <OA design library>"
   }
   if {[info exists vars(oa_design_cell)]} {
      puts $op1 "set vars(oa_design_cell)    $vars(oa_design_cell)"
   } else {
      puts $op1 "#set vars(oa_design_cell)   <OA design cell>"
   }
   if {[info exists vars(oa_design_view)]} {
      puts $op1 "set vars(oa_design_view)    $vars(oa_design_view)"
   } else {
      puts $op1 "#set vars(oa_design_view)   <OA design view>"
   }
   puts $op1 "#set vars(dbs_format)       oa"
   if {[info exists vars(oa_ref_lib)]} {
      puts $op1 "set vars(oa_ref_lib)        $vars(oa_ref_lib)"
   } else {
      puts $op1 "#set vars(oa_ref_lib)       <OA reference library>"
   }
   if {[info exists vars(oa_abstract_name)]} {
      puts $op1 "set vars(oa_abstract_name)  $vars(oa_abstract_name)"
   } else {
      puts $op1 "#set vars(oa_abstract_name) <OA abstract name>"
   }
   if {[info exists vars(oa_layout_name)]} {
      puts $op1 "set vars(oa_layout_name)    $vars(oa_layout_name)"
   } else {
      puts $op1 "#set vars(oa_layout_name)   <OA layout name>"
   }
   if {[info exists vars(netlist)]} {
#      puts $op1 [format "set vars(netlist)%s%s" [pad vars(netlist)] $vars(netlist)]
      puts $op1 [format_string vars(netlist) \"$vars(netlist)\"]
      puts $op1 [format_string vars(netlist_type) verilog]
   }
   puts $op1 "#########################################################################################"
} else {
   if {[info exists vars(netlist)]} {
#      puts $op1 [format "set vars(netlist)%s%s" [pad vars(netlist)] $vars(netlist)]
      puts $op1 [format_string vars(netlist) \"$vars(netlist)\"]
      puts $op1 [format_string vars(netlist_type) verilog]
   }
   puts $op1 "#########################################################################################"
   puts $op1 "# Variables for OA design import and export"
   puts $op1 "# ---------------------------------------------------------------------------------------"
   puts $op1 "#set vars(oa_design_lib)    <OA design library>"
   puts $op1 "#set vars(oa_design_cell)   <OA design cell>"
   puts $op1 "#set vars(oa_design_view)   <OA design view>"
   puts $op1 "#set vars(oa_ref_lib)       <OA reference library>"
   puts $op1 "#set vars(oa_abstract_name) <OA abstract name>"
   puts $op1 "#set vars(oa_layout_name)   <OA layout name>"
}
if {[info exists vars(fp_file)]} {
   puts $op1 [format_string vars(fp_file) $vars(fp_file)]
} else {
   puts $op1 [format_string #vars(fp_file) <floorplan_file>]
}
puts $op1 [format_string #vars(oa_fp) <OA_floorplan>]
puts $op1 [format_string #vars(def_files) <def_files>]
#puts $op1 "#set vars(scan_def)       <scan_def>"
puts $op1 "# NOTE: vars(cts_spec) is only required for cts flows."
puts $op1 "#       For ccopt flows, it is not required"
if {[file exists $vars(cts_spec)]} {
   puts $op1 [format_string vars(cts_spec) \"$vars(cts_spec)\"] 
} else {
   puts $op1 [format_string #vars(cts_spec) <cts_spec>]
}
if {[info exists vars(process)]} {
   puts $op1 [format_string vars(process) $vars(process)]
} else {
   puts $op1 [format_string #vars(process) <process>]
}
if {[info exists vars(max_route_layer)]} {
   puts $op1 [format_string vars(max_route_layer) $vars(max_route_layer)]
} else {
   puts $op1 [format_string #vars(max_route_layer) <max_route_layer>]
}
puts $op1 "# NOTE: When generate_tracks is set, the tracks in the DEF are ignored; even the pitch"
puts $op1 "#       To generate new tracks but preserve the pitch, use vars(honor_pitch) true"
puts $op1 [format_string #vars(generate_tracks) "<true | false>"]
puts $op1 [format_string #vars(honor_pitch) "<true | false>"]
if {[info exists rda_Input(ui_pwrnet)] && ($rda_Input(ui_pwrnet) != "")} {
   puts $op1 "set vars(power_nets)   \"$rda_Input(ui_pwrnet)\""
} else {
   puts $op1 "#set vars(power_nets)             <list of power nets>"
}
if {[info exists rda_Input(ui_gndnet)] && ($rda_Input(ui_gndnet) != "")} {
   puts $op1 "set vars(ground_nets)  \"$rda_Input(ui_gndnet)\""
} else {
   puts $op1 "#set vars(ground_nets)            <list of ground nets>"
}
puts $op1 "##########################################################################################"
puts $op1 "# For hierarchical designs, define vars(partition_list) which should be a list "
puts $op1 "# of all defined partitions (DO NOT INCLUDE THE TOP PARTITION)."
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "# To assist the budgeting process, also define the following for each partition"
puts $op1 "# - set vars(<partition>,cts_spec) <file>"
puts $op1 "# - set vars(<partition>,latency_sdc) <file>"
puts $op1 "#"
puts $op1 "# These files should contain the expected clock latency for the clock tree(s)"
puts $op1 "# For example, if partition A has an expected clock latency of 500ps out of a total clock"
puts $op1 "# latency of 1ns, the top level constraints would have 'set_clock_latency 1.0 <clock pin>'"
puts $op1 "# and A would have a latency sdc file containing 'set_clock_latency 0.5 <ptn clock pin>'"
puts $op1 "# Likewise, the top level CTS spec would contain 'MaxDelay 1ns' and the vars(A,cts_spec)"
puts $op1 "# would contain 'MacroModel A/<ptn clock pin> 500ps 500ps 500ps 500ps 0fF"
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "# During assembly, the foundation flow defaults to assembly the 'signoff' databases"
puts $op1 "# from each partition sub-directory.  To specify a different database to use for any"
puts $op1 "# partition (including the top), specify the following:"
puts $op1 "#    - vars(<ptn>,assemble_dbs)  <path to INNOVUS database directory>"
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "# If vars(use_flexmodels) is set to true, Flexmodels will be used. Some additional"
puts $op1 "# options for flexmodel usage are:"
puts $op1 "#    set vars(use_proto_net_delay_model) false"
puts $op1 "#    set vars(flexmodel_as_ptn) true"
puts $op1 "#    set vars(flexmodel_art_based) true"
puts $op1 "#    set vars(create_flexfiller_blockage) true"
puts $op1 "#    set vars(enable_nrgr) true"
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "# If vars(insert_feedthrough) is set to true, feedthrough insertion will be called"
puts $op1 "#  before partitioning. Some additional options for partitioning are:"
puts $op1 "#    set vars(abutted_design) true"
puts $op1 "#    set vars(placement_based_ptn) true"
puts $op1 "#    set vars(budget_mode) { trial_ipo giga_opt proto_net_delay_model }"
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "# Flexilm creation can be enabled for the partitions, using vars(enable_flexilm) true"
puts $op1 "#-----------------------------------------------------------------------------------------"
puts $op1 "# Finally, each partition can have its own innovus_config.tcl (INCLUDING THE TOP PARTITION)."
puts $op1 "# To enable this, define vars(<partition>,<innovus_config_tcl>"
puts $op1 "##########################################################################################"
set vars(partition_list) ""
dbForEachCellPtn [dbGet top] ptn {
   lappend vars(partition_list) [dbPtnName $ptn]
}
if {$vars(partition_list) != ""} {
   puts $op1 "set vars(partition_list)        \[list $vars(partition_list)\]"
   foreach part $vars(partition_list) {
      puts $op1 "#set vars($part,cts_spec)       <partition cts spec file>"
      puts $op1 "#set vars($part,latency_sdc)    <partition latency sdc file>"
      puts $op1 "#set vars($part,assemble_dbs)   <database directory>"
      puts $op1 "#set vars($part,ilm_dir)        <path to ILM diretory>"
      puts $op1 "#set vars($part,lef_file)       <path to LEF file>"
      puts $op1 "#set vars($part,innovus_config_tcl) <partition specific innovus_config.tcl>"
   }
} else {
   puts $op1 "#set vars(partition_list)             <list of partitions>"
   puts $op1 "#set vars(<partition>,cts_spec)       <partition cts spec file>"
   puts $op1 "#set vars(<partition>,latency_sdc)    <partition latency sdc file>"
   puts $op1 "#set vars(<partition>,assemble_dbs)   <database directory>"
   puts $op1 "#set vars(<partition>,ilm_dir)        <path to ILM diretory>"
   puts $op1 "#set vars(<partition>,lef_file)       <path to LEF file>"
   puts $op1 "#set vars(<partition>,innovus_config_tcl) <partition specific innovus_config.tcl>"
}

if {(![catch {dbGet top.isProtoModelCommitted} val]) && $val} {
   puts $op1 "set vars(use_flexmodels) true"
} else {
   puts $op1 "#set vars(use_flexmodels) <boolean>"
}

puts $op1 ""

puts $op1 "########################################################################################"
puts $op1 "# Optionally define user ILMs to be specified during the flow. These will be specified "
puts $op1 "# during the flat init step and the hierarchical partitioning step. The ILMs should"
puts $op1 "# not be hierarhical partitions (they are handled automatically.  See below for "
puts $op1 "# handling partition ILMs during post assembly closure."
puts $op1 "# - vars(ilm_list)  <list of ilm modules>"
puts $op1 "# - vars(<ilm>,ilm_dir)  <path to ILM diretory>"
puts $op1 "# - vars(<ilm>,lef_file) <path to LEF file>"
puts $op1 "########################################################################################"
puts $op1 "# set vars(ilm_list) \[list\]"
if {[info exists rda_Input(ui_ilmdir)] && ($rda_Input(ui_ilmdir) != "")} {
   set ilm_list [list]
   for {set i 0} {$i < [llength $rda_Input(ui_ilmdir)]} {incr i} {
      set ilm [lindex $rda_Input(ui_ilmdir) $i]
      incr i
      set dir [lindex $rda_Input(ui_ilmdir) $i]
      lappend ilm_list $ilm
      set vars($ilm,ilm_dir) $dir
   }
   if {$ilm_list != ""} {
      puts $op1 "set vars(ilm_list) \[list $ilm_list\]"
      foreach ilm $ilm_list {
         puts $op1 "set vars($ilm,ilm_dir) $vars($ilm,ilm_dir)"
      }
   }
}
puts $op1 "########################################################################################"
puts $op1 "# Define lef files ..."
puts $op1 "########################################################################################"
puts $op1 "set vars(lef_files) \"\\"
foreach file $rda_Input(ui_leffile) {
   puts $op1 "   [file normalize $file] \\"
}
puts $op1 "\""

puts $op1 "########################################################################################"
puts $op1 "# Define library sets ..."
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "# set vars(library_sets) <list of library sets>"
puts $op1 "# set vars(<set>,timing) <list of lib files>"
puts $op1 "# set vars(<set>,si) <list of cdb/udn files>"
puts $op1 "########################################################################################"
set library_sets [list]

foreach library_set [all_library_sets] {
   if {[llength [all_library_sets]] > 2} {
#      if {[regexp "^default" $library_set] == 0} {
         if {[info exists ::CPF::cpfCommitted]} {
            if {([regexp "^domain_" $library_set] == 0)} {
               lappend library_sets $library_set
            }
         } else {
            lappend library_sets $library_set
         }
#      }
   } else {
      lappend library_sets $library_set
   }
}

if {$library_sets != ""} {
   puts $op1 "set vars(library_sets) \"$library_sets\""
}

foreach library_set $library_sets {
   foreach option "timing si aocv" {
      if {[get_library_set $library_set -$option] != ""} {
         set file_list [get_library_set $library_set -$option]
         puts $op1 "set vars($library_set,$option) \"\\"
         foreach file $file_list {
            puts $op1 "   [file normalize $file] \\" 
         } 
         puts $op1 "\"" 
      }
   }
}

puts $op1 "########################################################################################"
puts $op1 "# Define rc corners ..."
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "# set vars(rc_corners) <list of rc corners>"
puts $op1 "# set vars(<rc_corner>,T) <temperature>"
puts $op1 "# set vars(<rc_corner>,cap_table) <cap table for corner>"
puts $op1 "########################################################################################"
set rc_corners [list]
foreach rc_corner [all_rc_corners] {
#   if {[llength [all_rc_corners]] > 1} {
#      if {[regexp "^default" $rc_corner ] == 0} {
#         lappend rc_corners $rc_corner
#      }
#   } else {
      lappend rc_corners $rc_corner
#   }
}
if {$rc_corners != ""} {
   puts $op1 "set vars(rc_corners) \"$rc_corners\""
}
foreach rc_corner $rc_corners {
   foreach option "T cap_table" {
      if {[get_rc_corner $rc_corner -$option] != ""} {
         if {$option == "cap_table"} {
            puts $op1 "set vars($rc_corner,$option) [file normalize [get_rc_corner $rc_corner -$option]]"
         } else {
            puts $op1 "set vars($rc_corner,$option) [get_rc_corner $rc_corner -$option]" 
         }
      } else {
         if {($option == "T") && ([get_rc_corner $rc_corner -$option] == "")} {
            puts $op1 "#set vars($rc_corner,$option) 25 ; # EDIT FOR CORRECT T VALUE"
         }
         if {($option == "cap_table") && ([get_rc_corner $rc_corner -$option] == "")} {
            puts $op1 "#set vars($rc_corner,$option) ; # EDIT FOR CORRECT CAP TABLE DEFINITION"
         }
      }
   }
   puts $op1 "#set vars($rc_corner,atf_file)"
}

puts $op1 "########################################################################################"
puts $op1 "# Optionally define QRC technology information"
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "# set vars(<rc_corner>,qx_tech_file) <qx_tech_file for corner>"
puts $op1 "# set vars(<rc_corner>,qx_lib_file)  <qx_lib_file for corner>"
puts $op1 "# set vars(<rc_corner>,qx_conf_file) <qx_conf_file for corner>"
puts $op1 "########################################################################################"
foreach rc_corner $rc_corners {
   foreach option "qx_tech_file qx_lib_file qx_conf_file" {
      if {[get_rc_corner $rc_corner -$option] != ""} {
         puts $op1 "set vars($rc_corner,$option) [file normalize [get_rc_corner $rc_corner -$option]]" 
      }
   }
}

puts $op1 "########################################################################################"
puts $op1 "# Scale factors are also optional but are strongly encouraged for pre_route optimization "
puts $op1 "# in order to obtain the best flow convergence and QoR.  Scaling factors are applied per"
puts $op1 "# rc corner by setting the individual values OR via a scale_tcl file which must contain" 
puts $op1 "# syntactically correct update_rc_corner commands for a given rc_corner"
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "# set vars(<rc_corner>,scale_tcl)                 <file>"
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "# set vars(<rc_corner>,pre_route_res_factor)      <pre-route resistance scale factor>"
puts $op1 "# set vars(<rc_corner>,pre_route_clk_res_factor)  <pre-route clock resistance scale factor>"
puts $op1 "# set vars(<rc_corner>,post_route_res_factor)     <post-route resistance scale factor (triplets)>"
puts $op1 "# set vars(<rc_corner>,post_route_clk_res_factor) <post-route clock resistance scale factor>"
puts $op1 "# set vars(<rc_corner>,pre_route_cap_factor)      <pre-route capacitance scale factor>"
puts $op1 "# set vars(<rc_corner>,pre_route_clk_cap_factor)  <pre-route clock capacitance scale factor>"
puts $op1 "# set vars(<rc_corner>,post_route_cap_factor)     <post-route capacitance scale factor (triplets)>"
puts $op1 "# set vars(<rc_corner>,post_route_clk_cap_factor) <post-route clock capacitance scale factor>"
puts $op1 "# set vars(<rc_corner>,post_route_xcap_factor)    <post-route coupling capacitance scale factor (triplets)>"
puts $op1 "########################################################################################"

foreach rc_corner $rc_corners {
   if {[get_rc_corner $rc_corner -preRoute_res] != ""} {
      puts $op1 "set vars($rc_corner,pre_route_res_factor) \t\t[format %4.2f [expr [get_rc_corner $rc_corner -preRoute_res]*1.0]]" 
   }
   if {[get_rc_corner $rc_corner -preRoute_clkres] != ""} {
      puts $op1 "set vars($rc_corner,pre_route_clk_res_factor) \t[format %4.2f [expr [get_rc_corner $rc_corner -preRoute_clkres]*1.0]]" 
    }
   if {[get_rc_corner $rc_corner -postRoute_res] != ""} {
      set triplets [get_rc_corner $rc_corner -postRoute_res]
      set scalar [lindex $triplets 0]
      if {[llength $scalar] == 1} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] 1.0 1.0]
      }
      if {[llength $scalar] == 2} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] 1.0]
      }
      if {[llength $scalar] == 3} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] [expr [lindex $scalar 2]*1.0]]
      }
      puts $op1 "set vars($rc_corner,post_route_res_factor) \t\t\"$pstring\""
   }
   if {[get_rc_corner $rc_corner -postRoute_clkres] != ""} {
      set triplets [get_rc_corner $rc_corner -postRoute_clkres]
      set scalar [lindex $triplets 0]
      if {[llength $scalar] == 1} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] 1.0 1.0]
      }
      if {[llength $scalar] == 2} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] 1.0]
      }
      if {[llength $scalar] == 3} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] [expr [lindex $scalar 2]*1.0]]
      }
      puts $op1 "set vars($rc_corner,post_route_clk_res_factor) \t\t\"$pstring\""
    }
   if {[get_rc_corner $rc_corner -preRoute_cap] != ""} {
      puts $op1 "set vars($rc_corner,pre_route_cap_factor) \t\t[format %4.2f [expr [get_rc_corner $rc_corner -preRoute_cap]*1.0]]" 
   }
   if {[get_rc_corner $rc_corner -preRoute_clkcap] != ""} {
      puts $op1 "set vars($rc_corner,pre_route_clk_cap_factor) \t[format %4.2f [expr [get_rc_corner $rc_corner -preRoute_clkcap]*1.0]]" 
    }
   if {[get_rc_corner $rc_corner -postRoute_cap] != ""} {
      set triplets [get_rc_corner $rc_corner -postRoute_cap]
      set scalar [lindex $triplets 0]
      if {[llength $scalar] == 1} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] 1.0 1.0]
      }
      if {[llength $scalar] == 2} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] 1.0]
      }
      if {[llength $scalar] == 3} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] [expr [lindex $scalar 2]*1.0]]
      }
      puts $op1 "set vars($rc_corner,post_route_cap_factor) \t\t\"$pstring\""
   }
   if {[get_rc_corner $rc_corner -postRoute_clkcap] != ""} {
      set triplets [get_rc_corner $rc_corner -postRoute_clkcap]
      set scalar [lindex $triplets 0]
      if {[llength $scalar] == 1} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] 1.0 1.0]
      }
      if {[llength $scalar] == 2} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] 1.0]
      }
      if {[llength $scalar] == 3} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] [expr [lindex $scalar 2]*1.0]]
      }
      puts $op1 "set vars($rc_corner,post_route_clk_cap_factor) \t\t\"$pstring\""
   }
   if {[get_rc_corner $rc_corner -postRoute_xcap] != ""} {
      set triplets [get_rc_corner $rc_corner -postRoute_xcap]
      set scalar [lindex $triplets 0]
      if {[llength $scalar] == 1} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] 1.0 1.0]
      }
      if {[llength $scalar] == 2} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] 1.0]
      }
      if {[llength $scalar] == 3} {
         set pstring [format "%4.2f %4.2f %4.2f" [expr [lindex $scalar 0]*1.0] [expr [lindex $scalar 1]*1.0] [expr [lindex $scalar 2]*1.0]]
      }
      puts $op1 "set vars($rc_corner,post_route_xcap_factor) \t\t\"$pstring\""
   }
   puts $op1  "" 
}
puts $op1 "########################################################################################"
puts $op1 "# Define operating conditions (optional)"
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "# set vars(opconds) <list of operating conditions>"
puts $op1 "# set vars(<opcond>,library_file) <library file >"
puts $op1 "# set vars(<opcond>,P) <process scale factor>"
puts $op1 "# set vars(<opcond>,V) <voltage>"
puts $op1 "# set vars(<opcond>,T) <temperature>"
puts $op1 "########################################################################################"
if {![info exists ::CPF::cpfCommitted]} {
   set opconds [list]
   foreach opcond [all_op_conds] {
   #   if {[regexp "^default" $opcond ] == 0} {
         lappend opconds $opcond
   #   }
   }
   if {$opconds != ""} {
      puts $op1 "#set vars(opconds) \"$opconds\""
   }
   foreach opcond $opconds {
      foreach option "library_file P V T" {
         if {[get_op_cond $opcond -$option] != ""} {
            puts $op1 "#set vars($opcond,$option) [get_op_cond $opcond -$option]" 
         }
      }
   }
}

puts $op1 "########################################################################################"
puts $op1 "# Define delay corners ..."
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "# set vars(delay_corners) <list of delay corners>"
puts $op1 "# set vars(<delay_corner>,library_set) <library_set> (previously defined)"
puts $op1 "# set vars(<delay_corner>,opcond) <opcond> (previously defined) (optional)"
puts $op1 "# set vars(<delay_corner>,rc_corner) library_set> (previously defined)"
puts $op1 "########################################################################################"
set delay_corners [list]
foreach delay_corner [all_delay_corners] {
#   if {[llength [all_delay_corners]] > 2} {
#      if {[regexp "^default" $delay_corner ] == 0} {
#         lappend delay_corners $delay_corner
#      }
#   } else {
      lappend delay_corners $delay_corner
#   }
}
if {$delay_corners != ""} {
   puts $op1 "set vars(delay_corners) \"$delay_corners\""
}
foreach dc $delay_corners {
    set attribute_list "rc_corner library_set opcond_library opcond irdrop_file late_library_set early_library_set 
                        late_opcond_library early_opcond_library late_opcond early_opcond late_irdrop_file early_irdrop_file"

   foreach attr $attribute_list {
   # Extraction the corner level properties
      if {[get_delay_corner $dc -$attr] != ""} { 
         puts $op1 "set vars($dc,$attr) \t[get_delay_corner $dc -$attr]"
      }
   # Extraction the power domain level properties
      set domains [get_delay_corner $dc -power_domain_list]
      if {$domains != ""} {
        if {![info exists done($dc,power_domains)]} {
           puts $op1 "set vars($dc,power_domains) \"$domains\""
            foreach pd [get_delay_corner $dc -power_domain_list] {
              puts $op1 "# Attributes for power domain $pd"
               foreach attr $attribute_list {
                  if {[get_delay_corner -power_domain $pd $dc -$attr] != ""} {
                     set done($dc,$pd,$attr) TRUE
                     puts $op1 "set vars($dc,$pd,$attr) \t[get_delay_corner $dc -power_domain $pd -$attr]"
                  }
               } 
            }
           set done($dc,power_domains) TRUE
         } 
      }
   }
}


puts $op1 "########################################################################################"
puts $op1 "# Optionally define derating factors for OCV here (clock and data). "
puts $op1 "# Derating factors are applied per delay corner using either individual"
puts $op1 "# values OR via a derate_tcl file which must contain syntactically correct"
puts $op1 "# set_timing_derate commands for a given delay_corner"
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "#set vars(<delay_corner>,derate_tcl)        <file>"
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "#set vars(<delay_corner>,data_cell_late)    <float>"
puts $op1 "#set vars(<delay_corner>,data_cell_early)   <float>"
puts $op1 "#set vars(<delay_corner>,data_net_late)     <float>"
puts $op1 "#set vars(<delay_corner>,data_net_early)    <float>"
puts $op1 "#set vars(<delay_corner>,clock_cell_late)   <float>"
puts $op1 "#set vars(<delay_corner>,clock_cell_early)  <float>"
puts $op1 "#set vars(<delay_corner>,clock_net_late)    <float>"
puts $op1 "#set vars(<delay_corner>,clock_net_early)   <float>"
puts $op1 "#set vars(<delay_corner>,cell_check_late)   <float>"
puts $op1 "#set vars(<delay_corner>,cell_check_early)  <float>"
puts $op1 "#---------------------------------------------------------------------------------------"

set map(early_cell_check_derate_factor) early_cell_check
set map(early_clk_cell_derate_factor) clock_cell_early
set map(early_data_cell_derate_factor) data_cell_early
set map(late_cell_check_derate_factor) late_cell_check
set map(late_clk_cell_derate_factor) clock_cell_late
set map(late_data_cell_derate_factor) data_cell_late

#timeDesign -prePlace
#foreach view [all_setup_analysis_views] {
#   foreach type "early_cell_check_derate_factor early_clk_cell_derate_factor early_data_cell_derate_factor \
#                 late_cell_check_derate_factor late_clk_cell_derate_factor late_data_cell_derate_factor" {
#
#      puts $op1 "set vars([get_analysis_view $view -delay_corner],$map($type)) [get_property [lindex [all_registers] 0] $type -view $view]"
#   }
#}
#timeDesign -prePlace -hold
#foreach view [all_hold_analysis_views] {
#   foreach type "early_cell_check_derate_factor early_clk_cell_derate_factor early_data_cell_derate_factor \
#                 late_cell_check_derate_factor late_clk_cell_derate_factor late_data_cell_derate_factor" {
#
#      puts $op1 "set vars([get_analysis_view $view -delay_corner],$map($type)) [get_property [lindex [all_registers] 0] $type -view $view]"
#   }
#}

puts $op1 "########################################################################################"
puts $op1 "# Define constraint modes ... "
puts $op1 "#---------------------------------------------------------------------------------------"
puts $op1 "# set vars(constraint_modes)        <list of constraint modes>"
puts $op1 "# set vars(<mode>,pre_cts_sdc)      <pre cts constraint file> (required)"
puts $op1 "# set vars(<mode>,post_cts_sdc)     <post cts constraint file> (optional)"
puts $op1 "# set vars(<mode>,incr_cts_sdc)     <incremental post cts constraint file> (optional)"
puts $op1 "# set vars(<mode>,pre_cts_ilm_sdc)  <pre cts ilm constraint file> (optional)"
puts $op1 "#---------------------------------------------------------------------------------------"
set constraint_modes [list]
foreach constraint_mode [all_constraint_modes] {
#   if {[llength [all_constraint_modes]] > 2} {
#      if {[regexp "^default_mode" $constraint_mode ] == 0} {
#         lappend constraint_modes $constraint_mode
#      }
#   } else {
      lappend constraint_modes $constraint_mode
#   }
}
if {$constraint_modes != ""} {
   puts $op1 "set vars(constraint_modes) \"$constraint_modes\""
}
foreach constraint_mode $constraint_modes {
   if {[get_constraint_mode $constraint_mode -sdc_files] != ""} {
#      puts $op1 "set vars($constraint_mode,pre_cts_sdc) \"[file normalize [get_constraint_mode $constraint_mode -sdc_files]]\"" 
     set pre_cts_sdc_list [list]
     foreach file [get_constraint_mode $constraint_mode -sdc_files]  {
        lappend pre_cts_sdc_list [file normalize $file]
     }
     puts $op1 "set vars($constraint_mode,pre_cts_sdc) \"[join $pre_cts_sdc_list]\"" 
      if {[info exists dgn_post_cts_sdc] && ($dgn_post_cts_sdc != "") } {
         puts $op1 "set vars($constraint_mode,post_cts_sdc) \"$dgn_post_cts_sdc\"" 
      }
   }
   if {[get_constraint_mode $constraint_mode -ilm_sdc_files] != ""} {
#      puts $op1 "set vars($constraint_mode,pre_cts_ilm_sdc) \"[file normalize [get_constraint_mode $constraint_mode -ilm_sdc_files]]\"" 
     set ilm_cts_sdc_list [list]
     foreach file [get_constraint_mode $constraint_mode -ilm_sdc_files]  {
        lappend ilm_cts_sdc_list [file normalize $file]
     }
     puts $op1 "set vars($constraint_mode,pre_cts_ilm_sdc) \"[join $ilm_cts_sdc_list]\"" 
   }
}

puts $op1 "########################################################################################"
puts $op1 "# Define setup and hold analysis views ... each analysis view requires"
puts $op1 "# a delay corner and a constraint mode"
puts $op1 "########################################################################################"

#set analysis_views ""
set analysis_views [concat [all_setup_analysis_views] [all_hold_analysis_views]]
#foreach view [all_analysis_views] {
#   if {[llength [all_analysis_views]] > 2} {
#      if {[regexp "^default" $view ] == 0} {
#         lappend analysis_views $view
#      }
#   } else {
#      lappend analysis_views $view
#   }
#}
foreach view $analysis_views {
   foreach option "delay_corner constraint_mode" {
      if {[get_analysis_view $view -$option] != ""} {
         puts $op1 "set vars($view,$option) [get_analysis_view $view -$option]" 
      }
   }
}
puts $op1 "########################################################################################"
puts $op1 "# EDIT/VERIFY THESE LISTS!!"
puts $op1 "########################################################################################"
puts $op1 "set vars(setup_analysis_views) \"[all_setup_analysis_views]\""
puts $op1 "set vars(hold_analysis_views)  \"[all_hold_analysis_views]\""
#puts $op1 "set vars(setup_analysis_views) \"$analysis_views\""
#puts $op1 "set vars(hold_analysis_views) \"$analysis_views\""

puts $op1 "########################################################################################"
puts $op1 "# Define active setup and hold analysis view lists and default views"
puts $op1 "########################################################################################"
puts $op1 "set vars(default_setup_view)  \[lindex \$vars(setup_analysis_views) 0\]"
puts $op1 "set vars(default_hold_view)   \[lindex \$vars(hold_analysis_views) 0\]"
#puts $op1 "set vars(active_setup_views) \$vars(setup_analysis_views)"
#puts $op1 "set vars(active_hold_views)  \$vars(hold_analysis_views)"
puts $op1 "set vars(active_setup_views)  \$vars(setup_analysis_views)"
puts $op1 "set vars(active_hold_views)   \$vars(hold_analysis_views)"
puts $op1 ""
puts $op1 "#set vars(gds_files)         <list of gds files>"
puts $op1 "#set vars(gds_layer_map)     <gds layer map file>"
puts $op1 "#set vars(qrc_layer_map)     <qrc layer map file>"
puts $op1 "#set vars(qrc_library)       <qrc library directory>"
puts $op1 "#set vars(qrc_config_file)   <qrc config file>"
puts $op1 ""
puts $op2 "########################################################################################"
puts $op2 "# Enable onChipVariation (for MMMC flows).  Options are:"
puts $op2 "# pre_place, pre_prects, pre_cts, pre_postcts, pre_postroute, pre_signoff, false"
puts $op2 "########################################################################################"
puts $op2 "set vars(enable_ocv)        pre_cts"
puts $op2 ""
puts $op2 "########################################################################################"
puts $op2 "# Optionally enable aocv"
puts $op2 "########################################################################################"
puts $op2 "set vars(enable_aocv)       false"
puts $op2 "########################################################################################"
puts $op2 "# Optionally enable cppr; options are: setup, hold, both, none"
puts $op2 "########################################################################################"
puts $op2 "set vars(enable_cppr)       both"
puts $op2 ""
#puts $op2 "########################################################################################"
#puts $op2 "# Optionally enable signalStorm delay calculation during the flow."
#puts $op2 "# This is a requirement when using ECSM/CCS models.  The following are"
#puts $op2 "# value options: pre_place pre_prects pre_postcts pre_postroute pre_signoff false"
#puts $op2 "########################################################################################"
#puts $op2 "set vars(enable_ss)         false"
#puts $op2 ""
puts $op2 "########################################################################################"
puts $op2 "# Optionally enable signoff ECO for the hierarhical flow"
puts $op2 "# IF 'ilm', THEN THE FOLLOWING SHOULD BE SET IN THE setup.tcl"
puts $op2 "# - vars(<ptn>,ilm_dir)   <path to ILM diretory>"
puts $op2 "# - va#rs(<ptn>,lef_file)  <path to LEF file>"
puts $op2 "########################################################################################"
puts $op2 "set vars(enable_signoff_eco)            false"
puts $op2 ""
puts $op2 "########################################################################################"
puts $op2 "#                              Flow Options"
puts $op2 "# Optionally enable design mode options:"
puts $op2 "#---------------------------------------------------------------------------------------"
puts $op2 "#set vars(flow_effot)       <express | standard | extreme>"
puts $op2 "#set vars(power_effort)     <none | low | high>"
puts $op2 ""
puts $op2 "########################################################################################"
puts $op2 "#                              Placement Options"
puts $op2 "# NOTE: When place_opt_design is enabled, the prects step will be skipped"
puts $op2 "#---------------------------------------------------------------------------------------"
puts $op2 "#set vars(in_place_opt)     true"
puts $op2 "#set vars(no_pre_place_opt) true"
puts $op2 "#set vars(place_opt_design)  <true | false>"
puts $op2 "#set vars(place_io_pins)     <true | false>"
puts $op2 "#set vars(clock_gate_aware)  <true | false>"
puts $op2 "#set vars(congestion_effort) <auto | low | high>"
puts $op2 "#---------------------------------------------------------------------------------------"
foreach option [getPlaceMode -quiet] {
   if {[lindex $option 0] == "clkGateAware"} {
      puts $op2 "set vars(clock_gate_aware)  [lindex $option 1]"
   }
   if {[lindex $option 0] == "congEffort"} {
      puts $op2 "set vars(congestion_effort) [lindex $option 1]"
   }
   if {[lindex $option 0] == "placeIoPins"} {
      puts $op2 "set vars(place_io_pins)     [lindex $option 1]"
   }
}
puts $op2 ""
puts $op2 "########################################################################################"
puts $op2 "#                     Tie/Filler/Tap Cell Options"
puts $op2 "# --------------------------------------------------------------------------------------"
puts $op2 "#                         Tie cell information"
puts $op2 "# --------------------------------------------------------------------------------------"
foreach option [getTieHiLoMode -quiet] {
   switch -exact -- [lindex $option 0] {
      "cell" {
         if {[lindex $option 1] != ""} {
            puts $op2 "set vars(tie_cells) \"[lindex $option 1]\""
         } else {
            puts $op2 "#set vars(tie_cells) <tie_cells>"
         }
      }
      "maxDistance" {
         if {[lindex $option 1] != 0} {
            puts $op2 "set vars(tie_cells,max_distance) [list [lindex $option 1]]"
         } else {
            puts $op2 "#set vars(tie_cells,max_distance) <float>"
         }
      }
      "maxFanout" {
         if {[lindex $option 1] != 0} {
            puts $op2 "set vars(tie_cells,max_fanout) [list [lindex $option 1]]"
         } else {
            puts $op2 "#set vars(tie_cells,max_fanout) <int>"
         }
      }
   }
}
puts $op2 "# --------------------------------------------------------------------------------------"
puts $op2 "#                     Filler cell information"
puts $op2 "# --------------------------------------------------------------------------------------"
foreach option [getFillerMode -quiet] {
   if {[lindex $option 0] == "core"} {
      if {[lindex $option 1] != ""} {
         puts $op2 "set vars(filler_cells) \"[lindex $option 1]\""
      } else {
         puts $op2 "#set vars(filler_cells) <filler_cells>"
      }
   }
}
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#                     Welltap cell information"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#    verify_rule : maximum distance (in microns) between welltap cells and standard cells "
puts $op2 "#                  in microns"
puts $op2 "#        max_gap : specifies the maximum distance from the right edge of one well-tap cell "
puts $op2 "#                  to the left edge of  the following well-tap cell in the same row"
puts $op2 "#  cell_interval : specifies the maximum distance from the center of one well-tap cell "
puts $op2 "#                  to the center of the following well-tap cell in the same row"
puts $op2 "#"
puts $op2 "# NOTE: max_gap and cell_interval parameters are mutually exclusive, user has to define "
puts $op2 "#       only one of these parameters to add welltap cells"
puts $op2 "#"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(welltaps)                         <welltap cells>"
puts $op2 "#set vars(welltaps,checkerboard)            <true or false>"
puts $op2 "#set vars(welltaps,max_gap)                 <max gap>"
puts $op2 "#set vars(welltaps,cell_interval)           <cell interval>"
puts $op2 "#set vars(welltaps,verify_rule)             <distance interval>"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#                          Endcap cell information"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(pre_endcap)                       <pre endcap cell>"
puts $op2 "#set vars(post_endcap)                      <post endcap cell>"
puts $op2 ""
if {[info exists ::CPF::cpfCommitted] || [info exists ::MSV::ieee1801Loaded]} {
   puts $op1 "##########################################################################################"
   puts $op1 "#                             LP Flow Options"
   puts $op1 "#---------------------------------------------------------------------------------------"
   set lpfile {}
   if {[info exists ::CPF::cpfCommitted] && $::CPF::cpfCommitted &&
       [info exists ::CPF::cpf_file] && $::CPF::cpf_file != ""} {
      set lpformat cpf
      set lpfile gen_setup.[pid].$lpformat; # $::CPF::cpf_file is not used directly
   if {[lindex [split $vars(version) "."]  0] < 15} {
      saveCPF $lpfile
   } else {
      write_power_intent -cpf $lpfile
   } 
   } elseif {[info exists ::MSV::ieee1801Loaded] && $::MSV::ieee1801Loaded &&
             [info exists ::MSV_UPF::upf_file]} {
      set lpfile [file normalize $::MSV_UPF::upf_file]
      set lpformat ieee1801
   }

   if {$lpfile == {}} {
      puts "WARNING: Cannot determine CPF or IEEE 1801 file ..."
   } else {
      set vars(${lpformat}_file) $lpfile
     puts $op1 "set vars(${lpformat}_file)       \"$vars(${lpformat}_file)\""
      puts $op1 "# --------------------------------------------------------------------"
      puts $op1 "# Define the following to selectively commit sections of the [string toupper $lpformat] file"
      puts $op1 "#set vars(${lpformat}_power_domain)     <true | false>"
      puts $op1 "#set vars(${lpformat}_power_switch)     <true | false>"
      puts $op1 "#set vars(${lpformat}_isolation)        <true | false>"
      puts $op1 "#set vars(${lpformat}_level_shifter)    <true | false>"
      puts $op1 "#set vars(${lpformat}_state_retention)  <true | false>"
      puts $op1 "# --------------------------------------------------------------------"
      puts $op1 "#set vars(${lpformat}_keep_rows)        <true | false>"
      puts $op1 "# ---------------------------------------------------------------------------------------"
      puts $op1 "# The vars(power_domains) is optional.  If not defined, the power" 
      puts $op1 "# power domain list will be picked up automatically"
      puts $op1 "# ---------------------------------------------------------------------------------------"
      set power_domains [list]
      dbForEachPowerDomain [dbgHead] pd {
         lappend power_domains [dbPowerDomainName $pd]
      }
      if {$power_domains != ""} {
         puts $op1 "set vars(power_domains) \"$power_domains\""
      } else {
         puts $op1 "#set vars(power_domains)                       <list of power domains>"
      }
      puts $op1 "# ---------------------------------------------------------------------------------------"
      puts $op1 "# Additional optional low power variables can be defined in the lp_config.tcl file."
      puts $op1 "# ---------------------------------------------------------------------------------------"
   }
}
puts $op2 ""
puts $op2 "#########################################################################################"
puts $op2 "#                               Clock Tree Options"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(route_clock_nets) <true | false>"
puts $op2 "#set vars(cts_cells)        <list of clock buffers>"
puts $op2 "#set vars(clock_gate_cells) <list of clock gating cells>"
puts $op2 "#set vars(clock_gate_clone) <true | false>"
puts $op2 "#set vars(clock_eco)        <pre_route | post_route | both | none>"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(clk_tree_top_layer)     <tree_top_preferred_layer>"
puts $op2 "#set vars(clk_tree_bottom_layer)  <tree_bottom_preferred_layer> "
puts $op2 "#set vars(clk_tree_ndr)           <tree_non_default_rule>"
puts $op2 "#set vars(clk_tree_shield_net)    <tree_shield_net> "
puts $op2 "#set vars(clk_leaf_top_layer)     <leaf_top_preferred_layer>"
puts $op2 "#set vars(clk_leaf_bottom_layer)  <leaf_bottom_preferred_layer>"
puts $op2 "#set vars(cts_leaf_ndr)           <leaf_non_default_layer>"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "# Additional variables to enable/support ccopt"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(cts_engine) <clockDesign | ccoptDesign>"
puts $op2 "#set vars(cts_buffer_cells) <list of buffers>"
puts $op2 "#set vars(cts_inverter_cells) <list of inverters>"
puts $op2 "#set vars(cts_use_inverters) <true | false>"
puts $op2 "#set vars(cts_io_opt) <on secondary off>"
#puts $op2 "#set vars(ccopt_integration) <native | scripted>"
#puts $op2 "#set vars(ccopt_executable) <path to ccopt executable>"

puts $op2 ""
puts $op2 "#########################################################################################"
puts $op2 "#                              Optimization Options"
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "# For difficult timing designs, 'set vars(high_timing_effort) true'"
puts $op2 "# This enables a variety of options throughout the flow for optimal"
puts $op2 "# QoR at the expense of runtime"
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "#set vars(high_timing_effort)             <true | false>"
puts $op2 "# --------------------------------------------------------------------"
#puts $op2 "#set vars(critical_range)                 <float>"
puts $op2 "#set vars(preserve_assertions)            <true | false>" 
puts $op2 "#set vars(clock_gate_aware_opt)           <true | false>"
#puts $op2 "#set vars(power_effort)                   <none | low | high>"
#puts $op2 "#set vars(power_ratio)                    <float>"
puts $op2 "#set vars(fix_hold_allow_tns_degradation) <true | false>"
puts $op2 "#set vars(useful_skew)                    <true | false>"
#puts $op2 "#set vars(skew_buffers)                   <true | false>"
puts $op2 "#set vars(fix_hold)                       <false | postcts | postroute >"
puts $op2 "#set vars(fix_hold_ignore_ios)            <true | false>"
puts $op2 "#set vars(delay_cells)                    <list of delay cells>"
puts $op2 "#set vars(dont_use_list)                  <list of cells>"
puts $op2 "#set vars(dont_use_file)                  <file of dont use commands>"
puts $op2 "#set vars(use_list)                       <list of cells>"
puts $op2 "#---------------------------------------------------------------------------------------"
foreach option [getOptMode -quiet] {
   if {[lindex $option 0] == "criticalRange"} {
      puts $op2 "#set vars(critical_range)                 [lindex $option 1]"
   }
   if {[lindex $option 0] == "preserveAssertions"} {
      puts $op2 "set vars(preserve_assertions)            [lindex $option 1]"
   } 
#   if {[lindex $option 0] == "leakagePowerEffort"} {
#      puts $op2 "set vars(leakage_power_effort)           [lindex $option 1]"
#   }
#   if {[lindex $option 0] == "dynamicPowerEffort"} {
#      puts $op2 "set vars(dynamic_power_effort)           [lindex $option 1]"
#   }
   if {[lindex $option 0] == "fixHoldAllowSetupTnsDegrade"} {
      puts $op2 "set vars(fix_hold_allow_tns_degradation) [lindex $option 1]"
   }
   if {[lindex $option 0] == "clkGateAware"} {
      puts $op2 "set vars(clock_gate_aware_opt)           [lindex $option 1]"
   }
   if {[lindex $option 0] == "usefulSkew"} {
      puts $op2 "set vars(useful_skew)                    [lindex $option 1]"
   }
}
#foreach option [getUsefulSkewMode -quiet] {
#   if {[lindex $option 0] == "useCells"} {
#      if {[lindex $option 1] != ""} {
#         puts $op2 "set vars(skew_buffers) \"\\"
#         foreach cell [lindex $option 1] {
#            puts $op2 "   $cell \\"
#         }
#         puts $op2 "\"" 
#      } 
#   }
#}
catch {set foo [get_line_match "set don't use by User" [getLogFileName]]}
if {[info exists foo] && ($foo != "") } {
   puts $op2 "set vars(dont_use_list) \"\\"
   foreach line [get_line_match "set don't use by User" [getLogFileName] 0] {
#      lappend vars(dont_use_list) [lindex [split [lindex $line 0] "/"] 1]
       puts $op2 "   [lindex [split [lindex $line 0] "/"] 1] \\"
   }
   puts $op2 "\""
}
puts $op2 "#########################################################################################"
puts $op2 "#                            Power Analysis Options"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(activity_file)        <activity file>"
puts $op2 "#set vars(activity_file_format) <TCF | SAF | VCD>"
puts $op2 "#set vars(report_power)         <true or false>"
puts $op2 "#set vars(power_analysis_view)  <power analysis view>"
puts $op2 ""
puts $op2 "#########################################################################################"
puts $op2 "#                              Nanoroute Options"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(multi_cut_effort)        <low | medium | high>"
puts $op2 "#set vars(antenna_diode)           <cell name>"
puts $op2 "#set vars(litho_driven_routing)    <true | false>"
puts $op2 "#set vars(verify_litho)            <true | false>"
puts $op2 "#set vars(lpa_tech_file)           <file name>"
puts $op2 "#set vars(fix_litho)               <true | false>"
puts $op2 "#set vars(lpa_conf_file)           <file name>"
puts $op2 "#set vars(postroute_spread_wires)  <true | false>"
puts $op2 "# ---------------------------------------------------------------------------------------"
foreach option [getNanoRouteMode -quiet] {
   if {[lindex $option 0] == "drouteUseMultiCutViaEffort"} {
      puts $op2 "set vars(multi_cut_effort)     [lindex $option 1]"
   }
   if {[lindex $option 0] == "routeWithLithoDriven"} {
      puts $op2 "set vars(litho_driven_routing) [lindex $option 1]"
   }
}

puts $op2 "#########################################################################################"
puts $op2 "#                              Extraction Options"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(coupling_c_thresh)       <float>"
puts $op2 "#set vars(relative_c_thresh)       <float>"
puts $op2 "#set vars(total_c_thresh)          <float>"
puts $op2 "# ---------------------------------------------------------------------------------------"
foreach option [getExtractRCMode -quiet] {
   if {[lindex $option 0] == "coupling_c_th"} {
      puts $op2 "#set vars(coupling_c_thresh)       [lindex $option 1]"
   }
   if {[lindex $option 0] == "relative_c_th"} {
      puts $op2 "#set vars(relative_c_thresh)       [lindex $option 1]"
   }
   if {[lindex $option 0] == "total_c_th"} {
      puts $op2 "#set vars(total_c_thresh)          [lindex $option 1]"
   }
}
puts $op2 "# Signoff extraction requires qrc_tech file; if you dont have one, please switch to effort low."
puts $op2 "# But keep in mind, effort low is NOT allowed for process nodes 32nm and below"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(postroute_extraction_effort) <low | medium | high>"
puts $op2 "#set vars(signoff_extraction_effort)   <low | medium | high | signoff>"
puts $op2 ""
puts $op2 "#########################################################################################"
puts $op2 "#                              Signal Integrity Options"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(delta_delay_threshold)  <float> (in nanoseconds)"
puts $op2 "#set vars(celtic_settings)        <string>"
puts $op2 "#set vars(si_analysis_type)       <default | pessimistic>"
puts $op2 "#set vars(acceptable_wns)         <float>"
puts $op2 "# ---------------------------------------------------------------------------------------"
foreach option [getSIMode -quiet] {
   if {[lindex $option 0] == "deltaDelayThreshold"} {
      puts $op2 "set vars(delta_delay_threshold) [lindex $option 1]"
   }
   if {[lindex $option 0] == "insCeltICPreTCL"} {
      puts $op2 "set vars(celtic_settings)       [lindex $option 1]"
   }
   if {[lindex $option 0] == "analysisType"} {
      puts $op2 "set vars(si_analysis_type)       [lindex $option 1]"
   }
}

puts $op2 "#########################################################################################"
puts $op2 "# Optionally define the following when applicable"
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "#set vars(assign_buffer)     {1 -buffer <buffer name>}"
puts $op2 "#set vars(buffer_tie_assign) <true | false>"
puts $op2 "#set vars(jtag_rows)         <number of rows for jtag placement>"
puts $op2 "#set vars(jtag_cells)        <list of jtag cells>"
puts $op2 "#set vars(spare_cells)       <list of spare cells instances>"


puts $op2 "#########################################################################################"
puts $op2 "# Below are the available plug-ins for the flat foundation flow.  Each "
puts $op2 "# should point to a file. If the file doesn't exist, the flow will print"
puts $op2 "# a warning an continue.  The place_tcl and cts_tcl are unique in that "
puts $op2 "# they REPLACE the placeDesign and clockDesign calls, respectively."
puts $op2 "# ---------------------------------------------------------------------------------------"
puts $op2 "set vars(always_source_tcl)           \$vars(plug_dir)/always_source.tcl"
puts $op2 "set vars(final_always_source_tcl)     \$vars(plug_dir)/final_always_source.tcl"
puts $op2 "set vars(pre_init_tcl)                \$vars(plug_dir)/pre_init.tcl"
puts $op2 "set vars(post_init_tcl)               \$vars(plug_dir)/post_init.tcl"
puts $op2 "set vars(pre_place_tcl)               \$vars(plug_dir)/pre_place.tcl"
puts $op2 "#set vars(place_tcl)                  \$vars(plug_dir)/place.tcl"
puts $op2 "set vars(post_place_tcl)              \$vars(plug_dir)/post_place.tcl"
puts $op2 "set vars(pre_prects_tcl)              \$vars(plug_dir)/pre_prects.tcl"
puts $op2 "set vars(post_prects_tcl)             \$vars(plug_dir)/post_prects.tcl"
puts $op2 "set vars(pre_cts_tcl)                 \$vars(plug_dir)/pre_cts.tcl"
puts $op2 "#set vars(cts_tcl)                    \$vars(plug_dir)/cts.tcl"
puts $op2 "set vars(post_cts_tcl)                \$vars(plug_dir)/post_cts.tcl"
puts $op2 "set vars(pre_postcts_tcl)             \$vars(plug_dir)/pre_postcts.tcl"
puts $op2 "set vars(post_postcts_tcl)            \$vars(plug_dir)/post_postcts.tcl"
puts $op2 "set vars(pre_route_tcl)               \$vars(plug_dir)/pre_route.tcl"
puts $op2 "set vars(post_route_tcl)              \$vars(plug_dir)/post_route.tcl"
puts $op2 "set vars(pre_postcts_hold_tcl)        \$vars(plug_dir)/pre_postcts_hold.tcl"
puts $op2 "set vars(post_postcts_hold_tcl)       \$vars(plug_dir)/post_postcts_hold.tcl"
puts $op2 "set vars(pre_postroute_tcl)           \$vars(plug_dir)/pre_postroute.tcl"
puts $op2 "set vars(post_postroute_tcl)          \$vars(plug_dir)/post_postroute.tcl"
puts $op2 "set vars(pre_postroute_hold_tcl)      \$vars(plug_dir)/pre_postroute_hold.tcl"
puts $op2 "set vars(post_postroute_hold_tcl)     \$vars(plug_dir)/post_postroute_hold.tcl"
puts $op2 "set vars(pre_signoff_tcl)             \$vars(plug_dir)/pre_signoff.tcl"
puts $op2 "set vars(post_signoff_tcl)            \$vars(plug_dir)/post_signoff.tcl"
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "# Below are the plug-ins available for the hierarchical flow ... note"
puts $op2 "# the additional plug-ins for the partition and assemble steps.  "
puts $op2 "# Keep in mind "
puts $op2 "#    - The partitioning step will also load the pre/post init"
puts $op2 "#      and pre/post place plug-ins (see above)."
puts $op2 "#    - The assemble step will also load the pre/post signoff"
puts $op2 "#      plug-ins as well.  "
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "#set vars(always_source_tcl)          \$vars(plug_dir)/post_signoff.tcl"
puts $op2 "#set vars(final_always_source_tcl)    \$vars(plug_dir)/final_always_source.tcl"
puts $op2 "#set vars(pre_model_gen_tcl)          \$vars(plug_dir)/pre_model_gen.tcl"
puts $op2 "#set vars(post_model_gen_tcl)         \$vars(plug_dir)/post_model_gen.tcl"
puts $op2 "#set vars(pre_pin_assign_tcl)         \$vars(plug_dir)/pre_pin_assign.tcl"
puts $op2 "#set vars(post_pin_assign_tcl)        \$vars(plug_dir)/post_pin_assign.tcl"
puts $op2 "#set vars(pre_partition_tcl)          \$vars(plug_dir)/pre_partition.tcl"
puts $op2 "#set vars(post_partition_tcl)         \$vars(plug_dir)/post_partition.tcl"
puts $op2 "#set vars(pre_assemble_tcl)           \$vars(plug_dir)/pre_assemble.tcl"
puts $op2 "#set vars(post_assemble_tcl)          \$vars(plug_dir)/post_assemble.tcl"
puts $op2 "#set vars(pre_signoff_tcl)            \$vars(plug_dir)/pre_signoff.tcl"
puts $op2 "#set vars(post_signoff_tcl)           \$vars(plug_dir)/post_signoff.tcl"
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "# All other plug-ins are only used during the flat implementation"
puts $op2 "# of the partitions. To enable plug-ins for partition implementation"
puts $op2 "# define in the vars(<part>,innovus_config_tcl) file for that partition"
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "# To insert metal fill during the flow define the following two variables:"
puts $op2 "# - vars(metalfill)    \[pre_postroute, pre_signoff\]"
puts $op2 "# - vars(metalfill_tcl) <path to metalfill plug-in file>"
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "#set vars(metalfill)                  pre_postroute"
puts $op2 "#set vars(metalfill_tcl)             \$vars(plug_dir)/metalfill.tcl"

puts $op2 "##########################################################################################"
puts $op2 "# Distribution setup ... vars(distribute) can be one of the following:"
puts $op2 "# lsf, rsh, local, or custom"
puts $op2 "# Depending on the value of vars(distribute), addition variables"
puts $op2 "# may be required.  Some examples are shown below"
puts $op2 "# Also, a timeout can be set (unit is seconds)"
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "#set vars(distribute)           custom"
puts $op2 "#set vars(distribute_timeout)   3600"
puts $op2 "#set vars(custom,script)        {/grid/sfi/farm/bin/gridsub -W 72:00 -P SOC7.1 -R \"SFIARCH==OPT64 && OSREL==EE40\" -q lnx64}"
puts $op2 "#set vars(lsf,queue)            lnx64"
puts $op2 "#set vars(lsf,resource)         \"SFIARCH==OPT64 && OSREL==EE40\""
puts $op2 "#set vars(lsf,args)             \"-W 72:00 -P SOC8.1\""
puts $op2 "#set vars(local_cpus)           2"
puts $op2 "#set vars(remote_hosts)         2"
puts $op2 "#set vars(cpu_per_remote_host)  2"
puts $op2 "#set vars(rsh,hosts)            <list of hosts>"
puts $op2 "##########################################################################################"
puts $op2 "# Capture qor and run time metrics ..."
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "#set vars(capture_metrics) false"
puts $op2 "set vars(report_run_time) true"
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "#set vars(html_summary) <filename>"
puts $op2 "#set vars(time_info_rpt) <filename>"
puts $op2 "#set vars(time_info_dbs) <filename>"
puts $op2 "##########################################################################################"
puts $op2 "# Makefile options ..."
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "#set vars(make_tool) <innovus executable>"
puts $op2 "#set vars(make_tool_args) \"-64 -nowin\""
puts $op2 "#set vars(make_syn_tool) <rc executable>"
puts $op2 "#set vars(make_syn_tool_args) \"-64\""
puts $op2 "#set vars(make_browser) mozilla"
puts $op2 "##########################################################################################"
puts $op2 "# Abort if there are errors in the setup.tcl"
puts $op2 "# --------------------------------------------------------------------"
puts $op2 "set vars(abort) true"
puts $op2 "##########################################################################################"
puts $op2 "# Send mail during flow execution;  vars(mail,steps) defaults to ALL steps."
puts $op2 "#set vars(mail,to)              \"<list of email addresses>\""
puts $op2 "#set vars(mail,steps)           \"<list of steps>\""
puts $op2 "##########################################################################################"
puts $op1 "puts \"<FF> Finished loading setup.tcl file\""
puts $op2 "puts \"<FF> Finished loading the INNOVUS configuration file\""

close $op1
close $op2

Puts "<FF> ------------------------------------------------------------------------------------"
Puts "<FF> Finished generating setup file \"setup.auto.tcl\" ... "
Puts "<FF> please edit and rename to setup.tcl to enable"
Puts "<FF> ------------------------------------------------------------------------------------"
Puts "<FF> Finished generating INNOVUS config file \"innovus_config.auto.tcl\" ... "
Puts "<FF> please edit and rename to innovus_config.tcl to enable"
Puts "<FF> ------------------------------------------------------------------------------------"
#puts "     Please check for correctness and add additional information as necessary"
if {[info exists lpfile]} {
   create_lp_config_file
   Puts "<FF> Finished generating low power config file \"lp_config.auto.tcl\" ... "
   Puts "<FF> please edit and rename to lp_config.tcl to enable"
   Puts "<FF> ------------------------------------------------------------------------------------"
}
create_invs_tag_file
Puts "<FF> ------------------------------------------------------------------------------------"
Puts "<FF> Finished generating INNOVUS tag file \"invs.auto.tcl\" ... "
Puts "<FF> This file is for detailed flow customization and in purely optional."
Puts "<FF> ------------------------------------------------------------------------------------"
if {[info exists done]} { 
   foreach var [array names done] {
      unset done($var)
   }
}
