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

##################################################################################
# Below is a list of commands that can be tagged with the following tags:
#
#   - pre_tcl     <filename>      => Script to be run before the tagged command
#   - post_tcl    <filename>      => Script to be run after the tagged command
#   - replace_tcl <filename>      => Script to be run before the tagged command
#   - skip        <TRUE | FALSE>  => Skip the tagged command
#
# These variables are structure <step>,<commmand>,<tag> 
# They should be added to your setup.tcl or innovus_config.tcl
#
##################################################################################

# set vars(tags,verbose)                   <true or false>"
# set vars(tags,verbosity_level)           [high | low]"

# set vars(init,set_distribute_host,pre_tcl)                      <file>
# set vars(init,set_distribute_host,post_tcl)                     <file>
# set vars(init,set_distribute_host,replace_tcl)                  <file>
# set vars(init,set_distribute_host,skip)                         <true or false>
# set vars(init,set_multi_cpu_usage,pre_tcl)                      <file>
# set vars(init,set_multi_cpu_usage,post_tcl)                     <file>
# set vars(init,set_multi_cpu_usage,replace_tcl)                  <file>
# set vars(init,set_multi_cpu_usage,skip)                         <true or false>
# set vars(init,set_distribute_host,pre_tcl)                      <file>
# set vars(init,set_distribute_host,post_tcl)                     <file>
# set vars(init,set_distribute_host,replace_tcl)                  <file>
# set vars(init,set_distribute_host,skip)                         <true or false>
# set vars(init,set_multi_cpu_usage,pre_tcl)                      <file>
# set vars(init,set_multi_cpu_usage,post_tcl)                     <file>
# set vars(init,set_multi_cpu_usage,replace_tcl)                  <file>
# set vars(init,set_multi_cpu_usage,skip)                         <true or false>
# set vars(init,set_rc_factor,pre_tcl)                            <file>
# set vars(init,set_rc_factor,post_tcl)                           <file>
# set vars(init,set_rc_factor,replace_tcl)                        <file>
# set vars(init,set_rc_factor,skip)                               <true or false>
# set vars(init,derate_timing,pre_tcl)                            <file>
# set vars(init,derate_timing,post_tcl)                           <file>
# set vars(init,derate_timing,replace_tcl)                        <file>
# set vars(init,derate_timing,skip)                               <true or false>
# set vars(init,create_rc_corner,pre_tcl)                         <file>
# set vars(init,create_rc_corner,post_tcl)                        <file>
# set vars(init,create_rc_corner,replace_tcl)                     <file>
# set vars(init,create_rc_corner,skip)                            <true or false>
# set vars(init,create_library_set,pre_tcl)                       <file>
# set vars(init,create_library_set,post_tcl)                      <file>
# set vars(init,create_library_set,replace_tcl)                   <file>
# set vars(init,create_library_set,skip)                          <true or false>
# set vars(init,create_op_cond,pre_tcl)                           <file>
# set vars(init,create_op_cond,post_tcl)                          <file>
# set vars(init,create_op_cond,replace_tcl)                       <file>
# set vars(init,create_op_cond,skip)                              <true or false>
# set vars(init,create_delay_corner,pre_tcl)                      <file>
# set vars(init,create_delay_corner,post_tcl)                     <file>
# set vars(init,create_delay_corner,replace_tcl)                  <file>
# set vars(init,create_delay_corner,skip)                         <true or false>
# set vars(init,create_constraint_mode,pre_tcl)                   <file>
# set vars(init,create_constraint_mode,post_tcl)                  <file>
# set vars(init,create_constraint_mode,replace_tcl)               <file>
# set vars(init,create_constraint_mode,skip)                      <true or false>
# set vars(init,create_analysis_view,pre_tcl)                     <file>
# set vars(init,create_analysis_view,post_tcl)                    <file>
# set vars(init,create_analysis_view,replace_tcl)                 <file>
# set vars(init,create_analysis_view,skip)                        <true or false>
# set vars(init,update_delay_corner,pre_tcl)                      <file>
# set vars(init,update_delay_corner,post_tcl)                     <file>
# set vars(init,update_delay_corner,replace_tcl)                  <file>
# set vars(init,update_delay_corner,skip)                         <true or false>
# set vars(init,update_library_set,pre_tcl)                       <file>
# set vars(init,update_library_set,post_tcl)                      <file>
# set vars(init,update_library_set,replace_tcl)                   <file>
# set vars(init,update_library_set,skip)                          <true or false>
# set vars(init,derate_timing,pre_tcl)                            <file>
# set vars(init,derate_timing,post_tcl)                           <file>
# set vars(init,derate_timing,replace_tcl)                        <file>
# set vars(init,derate_timing,skip)                               <true or false>
# set vars(init,set_default_view,pre_tcl)                         <file>
# set vars(init,set_default_view,post_tcl)                        <file>
# set vars(init,set_default_view,replace_tcl)                     <file>
# set vars(init,set_default_view,skip)                            <true or false>
# set vars(init,set_power_analysis_mode,pre_tcl)                  <file>
# set vars(init,set_power_analysis_mode,post_tcl)                 <file>
# set vars(init,set_power_analysis_mode,replace_tcl)              <file>
# set vars(init,set_power_analysis_mode,skip)                     <true or false>
# set vars(init,load_config,pre_tcl)                              <file>
# set vars(init,load_config,post_tcl)                             <file>
# set vars(init,load_config,replace_tcl)                          <file>
# set vars(init,load_config,skip)                                 <true or false>
# set vars(init,init_design,pre_tcl)                              <file>
# set vars(init,init_design,post_tcl)                             <file>
# set vars(init,init_design,replace_tcl)                          <file>
# set vars(init,init_design,skip)                                 <true or false>
# set vars(init,load_floorplan,pre_tcl)                           <file>
# set vars(init,load_floorplan,post_tcl)                          <file>
# set vars(init,load_floorplan,replace_tcl)                       <file>
# set vars(init,load_floorplan,skip)                              <true or false>
# set vars(init,generate_tracks,pre_tcl)                          <file>
# set vars(init,generate_tracks,post_tcl)                         <file>
# set vars(init,generate_tracks,replace_tcl)                      <file>
# set vars(init,generate_tracks,skip)                             <true or false>
# set vars(init,load_cpf,pre_tcl)                                 <file>
# set vars(init,load_cpf,post_tcl)                                <file>
# set vars(init,load_cpf,replace_tcl)                             <file>
# set vars(init,load_cpf,skip)                                    <true or false>
# set vars(init,commit_cpf,pre_tcl)                               <file>
# set vars(init,commit_cpf,post_tcl)                              <file>
# set vars(init,commit_cpf,replace_tcl)                           <file>
# set vars(init,commit_cpf,skip)                                  <true or false>
# set vars(init,load_ieee1801,pre_tcl)                            <file>
# set vars(init,load_ieee1801,post_tcl)                           <file>
# set vars(init,load_ieee1801,replace_tcl)                        <file>
# set vars(init,load_ieee1801,skip)                               <true or false>
# set vars(init,commit_ieee1801,pre_tcl)                          <file>
# set vars(init,commit_ieee1801,post_tcl)                         <file>
# set vars(init,commit_ieee1801,replace_tcl)                      <file>
# set vars(init,commit_ieee1801,skip)                             <true or false>
# set vars(init,read_activity_file,pre_tcl)                       <file>
# set vars(init,read_activity_file,post_tcl)                      <file>
# set vars(init,read_activity_file,replace_tcl)                   <file>
# set vars(init,read_activity_file,skip)                          <true or false>
# set vars(init,specify_ilm,pre_tcl)                              <file>
# set vars(init,specify_ilm,post_tcl)                             <file>
# set vars(init,specify_ilm,replace_tcl)                          <file>
# set vars(init,specify_ilm,skip)                                 <true or false>
# set vars(init,load_ilm_non_sdc_file,pre_tcl)                    <file>
# set vars(init,load_ilm_non_sdc_file,post_tcl)                   <file>
# set vars(init,load_ilm_non_sdc_file,replace_tcl)                <file>
# set vars(init,load_ilm_non_sdc_file,skip)                       <true or false>
# set vars(init,initialize_timing,pre_tcl)                        <file>
# set vars(init,initialize_timing,post_tcl)                       <file>
# set vars(init,initialize_timing,replace_tcl)                    <file>
# set vars(init,initialize_timing,skip)                           <true or false>
# set vars(init,load_scan,pre_tcl)                                <file>
# set vars(init,load_scan,post_tcl)                               <file>
# set vars(init,load_scan,replace_tcl)                            <file>
# set vars(init,load_scan,skip)                                   <true or false>
# set vars(init,specify_spare_gates,pre_tcl)                      <file>
# set vars(init,specify_spare_gates,post_tcl)                     <file>
# set vars(init,specify_spare_gates,replace_tcl)                  <file>
# set vars(init,specify_spare_gates,skip)                         <true or false>
# set vars(init,set_dont_use,pre_tcl)                             <file>
# set vars(init,set_dont_use,post_tcl)                            <file>
# set vars(init,set_dont_use,replace_tcl)                         <file>
# set vars(init,set_dont_use,skip)                                <true or false>
# set vars(init,set_max_route_layer,pre_tcl)                      <file>
# set vars(init,set_max_route_layer,post_tcl)                     <file>
# set vars(init,set_max_route_layer,replace_tcl)                  <file>
# set vars(init,set_max_route_layer,skip)                         <true or false>
# set vars(init,set_design_mode,pre_tcl)                          <file>
# set vars(init,set_design_mode,post_tcl)                         <file>
# set vars(init,set_design_mode,replace_tcl)                      <file>
# set vars(init,set_design_mode,skip)                             <true or false>
# set vars(init,insert_welltaps_endcaps,pre_tcl)                  <file>
# set vars(init,insert_welltaps_endcaps,post_tcl)                 <file>
# set vars(init,insert_welltaps_endcaps,replace_tcl)              <file>
# set vars(init,insert_welltaps_endcaps,skip)                     <true or false>
# set vars(init,load_config,pre_tcl)                              <file>
# set vars(init,load_config,post_tcl)                             <file>
# set vars(init,load_config,replace_tcl)                          <file>
# set vars(init,load_config,skip)                                 <true or false>
# set vars(init,time_design,pre_tcl)                              <file>
# set vars(init,time_design,post_tcl)                             <file>
# set vars(init,time_design,replace_tcl)                          <file>
# set vars(init,time_design,skip)                                 <true or false>
# set vars(init,check_design,pre_tcl)                             <file>
# set vars(init,check_design,post_tcl)                            <file>
# set vars(init,check_design,replace_tcl)                         <file>
# set vars(init,check_design,skip)                                <true or false>
# set vars(init,check_timing,pre_tcl)                             <file>
# set vars(init,check_timing,post_tcl)                            <file>
# set vars(init,check_timing,replace_tcl)                         <file>
# set vars(init,check_timing,skip)                                <true or false>
# set vars(init,report_power_domains,pre_tcl)                     <file>
# set vars(init,report_power_domains,post_tcl)                    <file>
# set vars(init,report_power_domains,replace_tcl)                 <file>
# set vars(init,report_power_domains,skip)                        <true or false>
# set vars(place,set_distribute_host,pre_tcl)                     <file>
# set vars(place,set_distribute_host,post_tcl)                    <file>
# set vars(place,set_distribute_host,replace_tcl)                 <file>
# set vars(place,set_distribute_host,skip)                        <true or false>
# set vars(place,set_multi_cpu_usage,pre_tcl)                     <file>
# set vars(place,set_multi_cpu_usage,post_tcl)                    <file>
# set vars(place,set_multi_cpu_usage,replace_tcl)                 <file>
# set vars(place,set_multi_cpu_usage,skip)                        <true or false>
# set vars(place,restore_design,pre_tcl)                          <file>
# set vars(place,restore_design,post_tcl)                         <file>
# set vars(place,restore_design,replace_tcl)                      <file>
# set vars(place,restore_design,skip)                             <true or false>
# set vars(place,initialize_step,pre_tcl)                         <file>
# set vars(place,initialize_step,post_tcl)                        <file>
# set vars(place,initialize_step,replace_tcl)                     <file>
# set vars(place,initialize_step,skip)                            <true or false>
# set vars(place,set_design_mode,pre_tcl)                         <file>
# set vars(place,set_design_mode,post_tcl)                        <file>
# set vars(place,set_design_mode,replace_tcl)                     <file>
# set vars(place,set_design_mode,skip)                            <true or false>
# set vars(place,set_delay_cal_mode,pre_tcl)                      <file>
# set vars(place,set_delay_cal_mode,post_tcl)                     <file>
# set vars(place,set_delay_cal_mode,replace_tcl)                  <file>
# set vars(place,set_delay_cal_mode,skip)                         <true or false>
# set vars(place,set_place_mode,pre_tcl)                          <file>
# set vars(place,set_place_mode,post_tcl)                         <file>
# set vars(place,set_place_mode,replace_tcl)                      <file>
# set vars(place,set_place_mode,skip)                             <true or false>
# set vars(place,set_opt_mode,pre_tcl)                            <file>
# set vars(place,set_opt_mode,post_tcl)                           <file>
# set vars(place,set_opt_mode,replace_tcl)                        <file>
# set vars(place,set_opt_mode,skip)                               <true or false>
# set vars(place,set_tie_hilo_mode,pre_tcl)                       <file>
# set vars(place,set_tie_hilo_mode,post_tcl)                      <file>
# set vars(place,set_tie_hilo_mode,replace_tcl)                   <file>
# set vars(place,set_tie_hilo_mode,skip)                          <true or false>
# set vars(place,cleanup_specify_clock_tree,pre_tcl)              <file>
# set vars(place,cleanup_specify_clock_tree,post_tcl)             <file>
# set vars(place,cleanup_specify_clock_tree,replace_tcl)          <file>
# set vars(place,cleanup_specify_clock_tree,skip)                 <true or false>
# set vars(place,specify_clock_tree,pre_tcl)                      <file>
# set vars(place,specify_clock_tree,post_tcl)                     <file>
# set vars(place,specify_clock_tree,replace_tcl)                  <file>
# set vars(place,specify_clock_tree,skip)                         <true or false>
# set vars(place,specify_jtag,pre_tcl)                            <file>
# set vars(place,specify_jtag,post_tcl)                           <file>
# set vars(place,specify_jtag,replace_tcl)                        <file>
# set vars(place,specify_jtag,skip)                               <true or false>
# set vars(place,place_jtag,pre_tcl)                              <file>
# set vars(place,place_jtag,post_tcl)                             <file>
# set vars(place,place_jtag,replace_tcl)                          <file>
# set vars(place,place_jtag,skip)                                 <true or false>
# set vars(place,eco_place,pre_tcl)                               <file>
# set vars(place,eco_place,post_tcl)                              <file>
# set vars(place,eco_place,replace_tcl)                           <file>
# set vars(place,eco_place,skip)                                  <true or false>
# set vars(place,place_design,pre_tcl)                            <file>
# set vars(place,place_design,post_tcl)                           <file>
# set vars(place,place_design,replace_tcl)                        <file>
# set vars(place,place_design,skip)                               <true or false>
# set vars(place,add_tie_cells,pre_tcl)                           <file>
# set vars(place,add_tie_cells,post_tcl)                          <file>
# set vars(place,add_tie_cells,replace_tcl)                       <file>
# set vars(place,add_tie_cells,skip)                              <true or false>
# set vars(place,set_tie_hi_lo_mode,pre_tcl)                       <file>
# set vars(place,set_tie_hi_lo_mode,post_tcl)                      <file>
# set vars(place,set_tie_hi_lo_mode,replace_tcl)                   <file>
# set vars(place,set_tie_hi_lo_mode,skip)                          <true or false>
# set vars(place,time_design,pre_tcl)                             <file>
# set vars(place,time_design,post_tcl)                            <file>
# set vars(place,time_design,replace_tcl)                         <file>
# set vars(place,time_design,skip)                                <true or false>
# set vars(place,save_design,pre_tcl)                             <file>
# set vars(place,save_design,post_tcl)                            <file>
# set vars(place,save_design,replace_tcl)                         <file>
# set vars(place,save_design,skip)                                <true or false>
# set vars(place,report_power,pre_tcl)                            <file>
# set vars(place,report_power,post_tcl)                           <file>
# set vars(place,report_power,replace_tcl)                        <file>
# set vars(place,report_power,skip)                               <true or false>
# set vars(place,verify_power_domain,pre_tcl)                     <file>
# set vars(place,verify_power_domain,post_tcl)                    <file>
# set vars(place,verify_power_domain,replace_tcl)                 <file>
# set vars(place,verify_power_domain,skip)                        <true or false>
# set vars(place,run_clp,pre_tcl)                                 <file>
# set vars(place,run_clp,post_tcl)                                <file>
# set vars(place,run_clp,replace_tcl)                             <file>
# set vars(place,run_clp,skip)                                    <true or false>
# set vars(prects,set_distribute_host,pre_tcl)                    <file>
# set vars(prects,set_distribute_host,post_tcl)                   <file>
# set vars(prects,set_distribute_host,replace_tcl)                <file>
# set vars(prects,set_distribute_host,skip)                       <true or false>
# set vars(prects,set_multi_cpu_usage,pre_tcl)                    <file>
# set vars(prects,set_multi_cpu_usage,post_tcl)                   <file>
# set vars(prects,set_multi_cpu_usage,replace_tcl)                <file>
# set vars(prects,set_multi_cpu_usage,skip)                       <true or false>
# set vars(prects,initialize_step,pre_tcl)                        <file>
# set vars(prects,initialize_step,post_tcl)                       <file>
# set vars(prects,initialize_step,replace_tcl)                    <file>
# set vars(prects,initialize_step,skip)                           <true or false>
# set vars(prects,set_design_mode,pre_tcl)                        <file>
# set vars(prects,set_design_mode,post_tcl)                       <file>
# set vars(prects,set_design_mode,replace_tcl)                    <file>
# set vars(prects,set_design_mode,skip)                           <true or false>
# set vars(prects,set_analysis_mode,pre_tcl)                      <file>
# set vars(prects,set_analysis_mode,post_tcl)                     <file>
# set vars(prects,set_analysis_mode,replace_tcl)                  <file>
# set vars(prects,set_analysis_mode,skip)                         <true or false>
# set vars(prects,set_ilm_type,pre_tcl)                           <file>
# set vars(prects,set_ilm_type,post_tcl)                          <file>
# set vars(prects,set_ilm_type,replace_tcl)                       <file>
# set vars(prects,set_ilm_type,skip)                              <true or false>
# set vars(prects,cleanup_specify_clock_tree,pre_tcl)             <file>
# set vars(prects,cleanup_specify_clock_tree,post_tcl)            <file>
# set vars(prects,cleanup_specify_clock_tree,replace_tcl)         <file>
# set vars(prects,cleanup_specify_clock_tree,skip)                <true or false>
# set vars(prects,create_clock_tree_spec,pre_tcl)                 <file>
# set vars(prects,create_clock_tree_spec,post_tcl)                <file>
# set vars(prects,create_clock_tree_spec,replace_tcl)             <file>
# set vars(prects,create_clock_tree_spec,skip)                    <true or false>
# set vars(prects,specify_clock_tree,pre_tcl)                     <file>
# set vars(prects,specify_clock_tree,post_tcl)                    <file>
# set vars(prects,specify_clock_tree,replace_tcl)                 <file>
# set vars(prects,specify_clock_tree,skip)                        <true or false>
# set vars(prects,set_useful_skew_mode,pre_tcl)                   <file>
# set vars(prects,set_useful_skew_mode,post_tcl)                  <file>
# set vars(prects,set_useful_skew_mode,replace_tcl)               <file>
# set vars(prects,set_useful_skew_mode,skip)                      <true or false>
# set vars(prects,set_opt_mode,pre_tcl)                           <file>
# set vars(prects,set_opt_mode,post_tcl)                          <file>
# set vars(prects,set_opt_mode,replace_tcl)                       <file>
# set vars(prects,set_opt_mode,skip)                              <true or false>
# set vars(prects,set_design_mode,pre_tcl)                        <file>
# set vars(prects,set_design_mode,post_tcl)                       <file>
# set vars(prects,set_design_mode,replace_tcl)                    <file>
# set vars(prects,set_design_mode,skip)                           <true or false>
# set vars(prects,set_delay_cal_mode,pre_tcl)                     <file>
# set vars(prects,set_delay_cal_mode,post_tcl)                    <file>
# set vars(prects,set_delay_cal_mode,replace_tcl)                 <file>
# set vars(prects,set_delay_cal_mode,skip)                        <true or false>
# set vars(prects,set_dont_use,pre_tcl)                           <file>
# set vars(prects,set_dont_use,post_tcl)                          <file>
# set vars(prects,set_dont_use,replace_tcl)                       <file>
# set vars(prects,set_dont_use,skip)                              <true or false>
# set vars(prects,opt_design,pre_tcl)                             <file>
# set vars(prects,opt_design,post_tcl)                            <file>
# set vars(prects,opt_design,replace_tcl)                         <file>
# set vars(prects,opt_design,skip)                                <true or false>
# set vars(prects,ck_clone_gate,pre_tcl)                          <file>
# set vars(prects,ck_clone_gate,post_tcl)                         <file>
# set vars(prects,ck_clone_gate,replace_tcl)                      <file>
# set vars(prects,ck_clone_gate,skip)                             <true or false>
# set vars(prects,save_design,pre_tcl)                            <file>
# set vars(prects,save_design,post_tcl)                           <file>
# set vars(prects,save_design,replace_tcl)                        <file>
# set vars(prects,save_design,skip)                               <true or false>
# set vars(prects,report_power,pre_tcl)                           <file>
# set vars(prects,report_power,post_tcl)                          <file>
# set vars(prects,report_power,replace_tcl)                       <file>
# set vars(prects,report_power,skip)                              <true or false>
# set vars(prects,verify_power_domain,pre_tcl)                    <file>
# set vars(prects,verify_power_domain,post_tcl)                   <file>
# set vars(prects,verify_power_domain,replace_tcl)                <file>
# set vars(prects,verify_power_domain,skip)                       <true or false>
# set vars(prects,run_clp,pre_tcl)                                <file>
# set vars(prects,run_clp,post_tcl)                               <file>
# set vars(prects,run_clp,replace_tcl)                            <file>
# set vars(prects,run_clp,skip)                                   <true or false>
# set vars(cts,set_distribute_host,pre_tcl)                       <file>
# set vars(cts,set_distribute_host,post_tcl)                      <file>
# set vars(cts,set_distribute_host,replace_tcl)                   <file>
# set vars(cts,set_distribute_host,skip)                          <true or false>
# set vars(cts,set_multi_cpu_usage,pre_tcl)                       <file>
# set vars(cts,set_multi_cpu_usage,post_tcl)                      <file>
# set vars(cts,set_multi_cpu_usage,replace_tcl)                   <file>
# set vars(cts,set_multi_cpu_usage,skip)                          <true or false>
# set vars(cts,initialize_step,pre_tcl)                           <file>
# set vars(cts,initialize_step,post_tcl)                          <file>
# set vars(cts,initialize_step,replace_tcl)                       <file>
# set vars(cts,initialize_step,skip)                              <true or false>
# set vars(cts,set_design_mode,pre_tcl)                           <file>
# set vars(cts,set_design_mode,post_tcl)                          <file>
# set vars(cts,set_design_mode,replace_tcl)                       <file>
# set vars(cts,set_design_mode,skip)                              <true or false>
# set vars(cts,set_cts_mode,pre_tcl)                              <file>
# set vars(cts,set_cts_mode,post_tcl)                             <file>
# set vars(cts,set_cts_mode,replace_tcl)                          <file>
# set vars(cts,set_cts_mode,skip)                                 <true or false>
# set vars(cts,update_ccopt_rc_corner,pre_tcl)                    <file>
# set vars(cts,update_ccopt_rc_corner,post_tcl)                   <file>
# set vars(cts,update_ccopt_rc_corner,replace_tcl)                <file>
# set vars(cts,update_ccopt_rc_corner,skip)                       <true or false>
# set vars(cts,set_ccopt_mode,pre_tcl)                            <file>
# set vars(cts,set_ccopt_mode,post_tcl)                           <file>
# set vars(cts,set_ccopt_mode,replace_tcl)                        <file>
# set vars(cts,set_ccopt_mode,skip)                               <true or false>
# set vars(cts,set_nanoroute_mode,pre_tcl)                        <file>
# set vars(cts,set_nanoroute_mode,post_tcl)                       <file>
# set vars(cts,set_nanoroute_mode,replace_tcl)                    <file>
# set vars(cts,set_nanoroute_mode,skip)                           <true or false>
# set vars(cts,enable_clock_gate_cells,pre_tcl)                   <file>
# set vars(cts,enable_clock_gate_cells,post_tcl)                  <file>
# set vars(cts,enable_clock_gate_cells,replace_tcl)               <file>
# set vars(cts,enable_clock_gate_cells,skip)                      <true or false>
# set vars(cts,create_clock_tree_spec,pre_tcl)                    <file>
# set vars(cts,create_clock_tree_spec,post_tcl)                   <file>
# set vars(cts,create_clock_tree_spec,replace_tcl)                <file>
# set vars(cts,create_clock_tree_spec,skip)                       <true or false>
# set vars(cts,clock_design,pre_tcl)                              <file>
# set vars(cts,clock_design,post_tcl)                             <file>
# set vars(cts,clock_design,replace_tcl)                          <file>
# set vars(cts,clock_design,skip)                                 <true or false>
# set vars(cts,disable_clock_gate_cells,pre_tcl)                  <file>
# set vars(cts,disable_clock_gate_cells,post_tcl)                 <file>
# set vars(cts,disable_clock_gate_cells,replace_tcl)              <file>
# set vars(cts,disable_clock_gate_cells,skip)                     <true or false>
# set vars(cts,run_clock_eco,pre_tcl)                             <file>
# set vars(cts,run_clock_eco,post_tcl)                            <file>
# set vars(cts,run_clock_eco,replace_tcl)                         <file>
# set vars(cts,run_clock_eco,skip)                                <true or false>
# set vars(cts,update_timing,pre_tcl)                             <file>
# set vars(cts,update_timing,post_tcl)                            <file>
# set vars(cts,update_timing,replace_tcl)                         <file>
# set vars(cts,update_timing,skip)                                <true or false>
# set vars(cts,create_ccopt_clock_tree_spec,pre_tcl)              <file>
# set vars(cts,create_ccopt_clock_tree_spec,post_tcl)             <file>
# set vars(cts,create_ccopt_clock_tree_spec,replace_tcl)          <file>
# set vars(cts,create_ccopt_clock_tree_spec,skip)                 <true or false>
# set vars(cts,ccopt_design,pre_tcl)                              <file>
# set vars(cts,ccopt_design,post_tcl)                             <file>
# set vars(cts,ccopt_design,replace_tcl)                          <file>
# set vars(cts,ccopt_design,skip)                                 <true or false>
# set vars(cts,time_design,pre_tcl)                               <file>
# set vars(cts,time_design,post_tcl)                              <file>
# set vars(cts,time_design,replace_tcl)                           <file>
# set vars(cts,time_design,skip)                                  <true or false>
# set vars(cts,save_design,pre_tcl)                               <file>
# set vars(cts,save_design,post_tcl)                              <file>
# set vars(cts,save_design,replace_tcl)                           <file>
# set vars(cts,save_design,skip)                                  <true or false>
# set vars(cts,report_power,pre_tcl)                              <file>
# set vars(cts,report_power,post_tcl)                             <file>
# set vars(cts,report_power,replace_tcl)                          <file>
# set vars(cts,report_power,skip)                                 <true or false>
# set vars(cts,verify_power_domain,pre_tcl)                       <file>
# set vars(cts,verify_power_domain,post_tcl)                      <file>
# set vars(cts,verify_power_domain,replace_tcl)                   <file>
# set vars(cts,verify_power_domain,skip)                          <true or false>
# set vars(cts,run_clp,pre_tcl)                                   <file>
# set vars(cts,run_clp,post_tcl)                                  <file>
# set vars(cts,run_clp,replace_tcl)                               <file>
# set vars(cts,run_clp,skip)                                      <true or false>
# set vars(postcts,set_distribute_host,pre_tcl)                   <file>
# set vars(postcts,set_distribute_host,post_tcl)                  <file>
# set vars(postcts,set_distribute_host,replace_tcl)               <file>
# set vars(postcts,set_distribute_host,skip)                      <true or false>
# set vars(postcts,set_multi_cpu_usage,pre_tcl)                   <file>
# set vars(postcts,set_multi_cpu_usage,post_tcl)                  <file>
# set vars(postcts,set_multi_cpu_usage,replace_tcl)               <file>
# set vars(postcts,set_multi_cpu_usage,skip)                      <true or false>
# set vars(postcts,initialize_step,pre_tcl)                       <file>
# set vars(postcts,initialize_step,post_tcl)                      <file>
# set vars(postcts,initialize_step,replace_tcl)                   <file>
# set vars(postcts,initialize_step,skip)                          <true or false>
# set vars(postcts,set_design_mode,pre_tcl)                       <file>
# set vars(postcts,set_design_mode,post_tcl)                      <file>
# set vars(postcts,set_design_mode,replace_tcl)                   <file>
# set vars(postcts,set_design_mode,skip)                          <true or false>
# set vars(postcts,set_delay_cal_mode,pre_tcl)                    <file>
# set vars(postcts,set_delay_cal_mode,post_tcl)                   <file>
# set vars(postcts,set_delay_cal_mode,replace_tcl)                <file>
# set vars(postcts,set_delay_cal_mode,skip)                       <true or false>
# set vars(postcts,set_analysis_mode,pre_tcl)                     <file>
# set vars(postcts,set_analysis_mode,post_tcl)                    <file>
# set vars(postcts,set_analysis_mode,replace_tcl)                 <file>
# set vars(postcts,set_analysis_mode,skip)                        <true or false>
# set vars(postcts,set_opt_mode,pre_tcl)                          <file>
# set vars(postcts,set_opt_mode,post_tcl)                         <file>
# set vars(postcts,set_opt_mode,replace_tcl)                      <file>
# set vars(postcts,set_opt_mode,skip)                             <true or false>
# set vars(postcts,opt_design,pre_tcl)                            <file>
# set vars(postcts,opt_design,post_tcl)                           <file>
# set vars(postcts,opt_design,replace_tcl)                        <file>
# set vars(postcts,opt_design,skip)                               <true or false>
# set vars(postcts,save_design,pre_tcl)                           <file>
# set vars(postcts,save_design,post_tcl)                          <file>
# set vars(postcts,save_design,replace_tcl)                       <file>
# set vars(postcts,save_design,skip)                              <true or false>
# set vars(postcts,report_power,pre_tcl)                          <file>
# set vars(postcts,report_power,post_tcl)                         <file>
# set vars(postcts,report_power,replace_tcl)                      <file>
# set vars(postcts,report_power,skip)                             <true or false>
# set vars(postcts,verify_power_domain,pre_tcl)                   <file>
# set vars(postcts,verify_power_domain,post_tcl)                  <file>
# set vars(postcts,verify_power_domain,replace_tcl)               <file>
# set vars(postcts,verify_power_domain,skip)                      <true or false>
# set vars(postcts,run_clp,pre_tcl)                               <file>
# set vars(postcts,run_clp,post_tcl)                              <file>
# set vars(postcts,run_clp,replace_tcl)                           <file>
# set vars(postcts,run_clp,skip)                                  <true or false>
# set vars(postcts_hold,set_distribute_host,pre_tcl)              <file>
# set vars(postcts_hold,set_distribute_host,post_tcl)             <file>
# set vars(postcts_hold,set_distribute_host,replace_tcl)          <file>
# set vars(postcts_hold,set_distribute_host,skip)                 <true or false>
# set vars(postcts_hold,set_multi_cpu_usage,pre_tcl)              <file>
# set vars(postcts_hold,set_multi_cpu_usage,post_tcl)             <file>
# set vars(postcts_hold,set_multi_cpu_usage,replace_tcl)          <file>
# set vars(postcts_hold,set_multi_cpu_usage,skip)                 <true or false>
# set vars(postcts_hold,initialize_step,pre_tcl)                  <file>
# set vars(postcts_hold,initialize_step,post_tcl)                 <file>
# set vars(postcts_hold,initialize_step,replace_tcl)              <file>
# set vars(postcts_hold,initialize_step,skip)                     <true or false>
# set vars(postcts_hold,set_dont_use,pre_tcl)                     <file>
# set vars(postcts_hold,set_dont_use,post_tcl)                    <file>
# set vars(postcts_hold,set_dont_use,replace_tcl)                 <file>
# set vars(postcts_hold,set_dont_use,skip)                        <true or false>
# set vars(postcts_hold,set_opt_mode,pre_tcl)                     <file>
# set vars(postcts_hold,set_opt_mode,post_tcl)                    <file>
# set vars(postcts_hold,set_opt_mode,replace_tcl)                 <file>
# set vars(postcts_hold,set_opt_mode,skip)                        <true or false>
# set vars(postcts_hold,opt_design,pre_tcl)                       <file>
# set vars(postcts_hold,opt_design,post_tcl)                      <file>
# set vars(postcts_hold,opt_design,replace_tcl)                   <file>
# set vars(postcts_hold,opt_design,skip)                          <true or false>
# set vars(postcts_hold,save_design,pre_tcl)                      <file>
# set vars(postcts_hold,save_design,post_tcl)                     <file>
# set vars(postcts_hold,save_design,replace_tcl)                  <file>
# set vars(postcts_hold,save_design,skip)                         <true or false>
# set vars(postcts_hold,report_power,pre_tcl)                     <file>
# set vars(postcts_hold,report_power,post_tcl)                    <file>
# set vars(postcts_hold,report_power,replace_tcl)                 <file>
# set vars(postcts_hold,report_power,skip)                        <true or false>
# set vars(postcts_hold,verify_power_domain,pre_tcl)              <file>
# set vars(postcts_hold,verify_power_domain,post_tcl)             <file>
# set vars(postcts_hold,verify_power_domain,replace_tcl)          <file>
# set vars(postcts_hold,verify_power_domain,skip)                 <true or false>
# set vars(postcts_hold,run_clp,pre_tcl)                          <file>
# set vars(postcts_hold,run_clp,post_tcl)                         <file>
# set vars(postcts_hold,run_clp,replace_tcl)                      <file>
# set vars(postcts_hold,run_clp,skip)                             <true or false>
# set vars(route,set_distribute_host,pre_tcl)                     <file>
# set vars(route,set_distribute_host,post_tcl)                    <file>
# set vars(route,set_distribute_host,replace_tcl)                 <file>
# set vars(route,set_distribute_host,skip)                        <true or false>
# set vars(route,set_multi_cpu_usage,pre_tcl)                     <file>
# set vars(route,set_multi_cpu_usage,post_tcl)                    <file>
# set vars(route,set_multi_cpu_usage,replace_tcl)                 <file>
# set vars(route,set_multi_cpu_usage,skip)                        <true or false>
# set vars(route,initialize_step,pre_tcl)                         <file>
# set vars(route,initialize_step,post_tcl)                        <file>
# set vars(route,initialize_step,replace_tcl)                     <file>
# set vars(route,initialize_step,skip)                            <true or false>
# set vars(route,set_nanoroute_mode,pre_tcl)                      <file>
# set vars(route,set_nanoroute_mode,post_tcl)                     <file>
# set vars(route,set_nanoroute_mode,replace_tcl)                  <file>
# set vars(route,set_nanoroute_mode,skip)                         <true or false>
# set vars(route,add_filler_cells,pre_tcl)                        <file>
# set vars(route,add_filler_cells,post_tcl)                       <file>
# set vars(route,add_filler_cells,replace_tcl)                    <file>
# set vars(route,add_filler_cells,skip)                           <true or false>
# set vars(route,route_secondary_pg_nets,pre_tcl)                 <file>
# set vars(route,route_secondary_pg_nets,post_tcl)                <file>
# set vars(route,route_secondary_pg_nets,replace_tcl)             <file>
# set vars(route,route_secondary_pg_nets,skip)                    <true or false>
# set vars(route,check_place,pre_tcl)                             <file>
# set vars(route,check_place,post_tcl)                            <file>
# set vars(route,check_place,replace_tcl)                         <file>
# set vars(route,check_place,skip)                                <true or false>
# set vars(route_design,set_analysis_mode,pre_tcl)                <file>
# set vars(route_design,set_analysis_mode,post_tcl)               <file>
# set vars(route_design,set_analysis_mode,replace_tcl)            <file>
# set vars(route_design,set_analysis_mode,skip)                   <true or false>
# set vars(route,route_design,pre_tcl)                            <file>
# set vars(route,route_design,post_tcl)                           <file>
# set vars(route,route_design,replace_tcl)                        <file>
# set vars(route,route_design,skip)                               <true or false>
# set vars(route,run_clock_eco,pre_tcl)                           <file>
# set vars(route,run_clock_eco,post_tcl)                          <file>
# set vars(route,run_clock_eco,replace_tcl)                       <file>
# set vars(route,run_clock_eco,skip)                              <true or false>
# set vars(route,spread_wires,pre_tcl)                            <file>
# set vars(route,spread_wires,post_tcl)                           <file>
# set vars(route,spread_wires,replace_tcl)                        <file>
# set vars(route,spread_wires,skip)                               <true or false>
# set vars(route,set_extract_rc_mode,pre_tcl)                     <file>
# set vars(route,set_extract_rc_mode,post_tcl)                    <file>
# set vars(route,set_extract_rc_mode,replace_tcl)                 <file>
# set vars(route,set_extract_rc_mode,skip)                        <true or false>
# set vars(route,initialize_timing,pre_tcl)                       <file>
# set vars(route,initialize_timing,post_tcl)                      <file>
# set vars(route,initialize_timing,replace_tcl)                   <file>
# set vars(route,initialize_timing,skip)                          <true or false>
# set vars(route,time_design,pre_tcl)                             <file>
# set vars(route,time_design,post_tcl)                            <file>
# set vars(route,time_design,replace_tcl)                         <file>
# set vars(route,time_design,skip)                                <true or false>
# set vars(route,save_design,pre_tcl)                             <file>
# set vars(route,save_design,post_tcl)                            <file>
# set vars(route,save_design,replace_tcl)                         <file>
# set vars(route,save_design,skip)                                <true or false>
# set vars(route,report_power,pre_tcl)                            <file>
# set vars(route,report_power,post_tcl)                           <file>
# set vars(route,report_power,replace_tcl)                        <file>
# set vars(route,report_power,skip)                               <true or false>
# set vars(route,verify_power_domain,pre_tcl)                     <file>
# set vars(route,verify_power_domain,post_tcl)                    <file>
# set vars(route,verify_power_domain,replace_tcl)                 <file>
# set vars(route,verify_power_domain,skip)                        <true or false>
# set vars(route,run_clp,pre_tcl)                                 <file>
# set vars(route,run_clp,post_tcl)                                <file>
# set vars(route,run_clp,replace_tcl)                             <file>
# set vars(route,run_clp,skip)                                    <true or false>
# set vars(postroute,set_distribute_host,pre_tcl)                 <file>
# set vars(postroute,set_distribute_host,post_tcl)                <file>
# set vars(postroute,set_distribute_host,replace_tcl)             <file>
# set vars(postroute,set_distribute_host,skip)                    <true or false>
# set vars(postroute,set_multi_cpu_usage,pre_tcl)                 <file>
# set vars(postroute,set_multi_cpu_usage,post_tcl)                <file>
# set vars(postroute,set_multi_cpu_usage,replace_tcl)             <file>
# set vars(postroute,set_multi_cpu_usage,skip)                    <true or false>
# set vars(postroute,initialize_step,pre_tcl)                     <file>
# set vars(postroute,initialize_step,post_tcl)                    <file>
# set vars(postroute,initialize_step,replace_tcl)                 <file>
# set vars(postroute,initialize_step,skip)                        <true or false>
# set vars(postroute,set_design_mode,pre_tcl)                     <file>
# set vars(postroute,set_design_mode,post_tcl)                    <file>
# set vars(postroute,set_design_mode,replace_tcl)                 <file>
# set vars(postroute,set_design_mode,skip)                        <true or false>
# set vars(postroute,set_extract_rc_mode,pre_tcl)                 <file>
# set vars(postroute,set_extract_rc_mode,post_tcl)                <file>
# set vars(postroute,set_extract_rc_mode,replace_tcl)             <file>
# set vars(postroute,set_extract_rc_mode,skip)                    <true or false>
# set vars(postroute,set_analysis_mode,pre_tcl)                   <file>
# set vars(postroute,set_analysis_mode,post_tcl)                  <file>
# set vars(postroute,set_analysis_mode,replace_tcl)               <file>
# set vars(postroute,set_analysis_mode,skip)                      <true or false>
# set vars(postroute,set_delay_cal_mode,pre_tcl)                  <file>
# set vars(postroute,set_delay_cal_mode,post_tcl)                 <file>
# set vars(postroute,set_delay_cal_mode,replace_tcl)              <file>
# set vars(postroute,set_delay_cal_mode,skip)                     <true or false>
# set vars(postroute,add_metalfill,pre_tcl)                       <file>
# set vars(postroute,add_metalfill,post_tcl)                      <file>
# set vars(postroute,add_metalfill,replace_tcl)                   <file>
# set vars(postroute,add_metalfill,skip)                          <true or false>
# set vars(postroute,delete_filler_cells,pre_tcl)                 <file>
# set vars(postroute,delete_filler_cells,post_tcl)                <file>
# set vars(postroute,delete_filler_cells,replace_tcl)             <file>
# set vars(postroute,delete_filler_cells,skip)                    <true or false>
# set vars(postroute,opt_design,pre_tcl)                          <file>
# set vars(postroute,opt_design,post_tcl)                         <file>
# set vars(postroute,opt_design,replace_tcl)                      <file>
# set vars(postroute,opt_design,skip)                             <true or false>
# set vars(postroute,add_filler_cells,pre_tcl)                    <file>
# set vars(postroute,add_filler_cells,post_tcl)                   <file>
# set vars(postroute,add_filler_cells,replace_tcl)                <file>
# set vars(postroute,add_filler_cells,skip)                       <true or false>
# set vars(postroute,trim_metalfill,pre_tcl)                      <file>
# set vars(postroute,trim_metalfill,post_tcl)                     <file>
# set vars(postroute,trim_metalfill,replace_tcl)                  <file>
# set vars(postroute,trim_metalfill,skip)                         <true or false>
# set vars(route,verify_litho,pre_tcl)                            <file>
# set vars(route,verify_litho,post_tcl)                           <file>
# set vars(route,verify_litho,replace_tcl)                        <file>
# set vars(route,verify_litho,skip)                               <true or false>
# set vars(postroute,save_design,pre_tcl)                         <file>
# set vars(postroute,save_design,post_tcl)                        <file>
# set vars(postroute,save_design,replace_tcl)                     <file>
# set vars(postroute,save_design,skip)                            <true or false>
# set vars(postroute,report_power,pre_tcl)                        <file>
# set vars(postroute,report_power,post_tcl)                       <file>
# set vars(postroute,report_power,replace_tcl)                    <file>
# set vars(postroute,report_power,skip)                           <true or false>
# set vars(postroute,verify_power_domain,pre_tcl)                 <file>
# set vars(postroute,verify_power_domain,post_tcl)                <file>
# set vars(postroute,verify_power_domain,replace_tcl)             <file>
# set vars(postroute,verify_power_domain,skip)                    <true or false>
# set vars(postroute,run_clp,pre_tcl)                             <file>
# set vars(postroute,run_clp,post_tcl)                            <file>
# set vars(postroute,run_clp,replace_tcl)                         <file>
# set vars(postroute,run_clp,skip)                                <true or false>
# set vars(postroute_hold,set_distribute_host,pre_tcl)            <file>
# set vars(postroute_hold,set_distribute_host,post_tcl)           <file>
# set vars(postroute_hold,set_distribute_host,replace_tcl)        <file>
# set vars(postroute_hold,set_distribute_host,skip)               <true or false>
# set vars(postroute_hold,set_multi_cpu_usage,pre_tcl)            <file>
# set vars(postroute_hold,set_multi_cpu_usage,post_tcl)           <file>
# set vars(postroute_hold,set_multi_cpu_usage,replace_tcl)        <file>
# set vars(postroute_hold,set_multi_cpu_usage,skip)               <true or false>
# set vars(postroute_hold,initialize_step,pre_tcl)                <file>
# set vars(postroute_hold,initialize_step,post_tcl)               <file>
# set vars(postroute_hold,initialize_step,replace_tcl)            <file>
# set vars(postroute_hold,initialize_step,skip)                   <true or false>
# set vars(postroute_hold,set_design_mode,pre_tcl)                <file>
# set vars(postroute_hold,set_design_mode,post_tcl)               <file>
# set vars(postroute_hold,set_design_mode,replace_tcl)            <file>
# set vars(postroute_hold,set_design_mode,skip)                   <true or false>
# set vars(postroute_hold,set_extract_rc_mode,pre_tcl)            <file>
# set vars(postroute_hold,set_extract_rc_mode,post_tcl)           <file>
# set vars(postroute_hold,set_extract_rc_mode,replace_tcl)        <file>
# set vars(postroute_hold,set_extract_rc_mode,skip)               <true or false>
# set vars(postroute_hold,set_dont_use_mode,pre_tcl)              <file>
# set vars(postroute_hold,set_dont_use_mode,post_tcl)             <file>
# set vars(postroute_hold,set_dont_use_mode,replace_tcl)          <file>
# set vars(postroute_hold,set_dont_use_mode,skip)                 <true or false>
# set vars(postroute_hold,set_opt_mode,pre_tcl)                   <file>
# set vars(postroute_hold,set_opt_mode,post_tcl)                  <file>
# set vars(postroute_hold,set_opt_mode,replace_tcl)               <file>
# set vars(postroute_hold,set_opt_mode,skip)                      <true or false>
# set vars(postroute_hold,delete_filler_cells,pre_tcl)            <file>
# set vars(postroute_hold,delete_filler_cells,post_tcl)           <file>
# set vars(postroute_hold,delete_filler_cells,replace_tcl)        <file>
# set vars(postroute_hold,delete_filler_cells,skip)               <true or false>
# set vars(postroute_hold,opt_design,pre_tcl)                     <file>
# set vars(postroute_hold,opt_design,post_tcl)                    <file>
# set vars(postroute_hold,opt_design,replace_tcl)                 <file>
# set vars(postroute_hold,opt_design,skip)                        <true or false>
# set vars(postroute_hold,add_filler_cells,pre_tcl)               <file>
# set vars(postroute_hold,add_filler_cells,post_tcl)              <file>
# set vars(postroute_hold,add_filler_cells,replace_tcl)           <file>
# set vars(postroute_hold,add_filler_cells,skip)                  <true or false>
# set vars(postroute_hold,trim_metalfill,pre_tcl)                 <file>
# set vars(postroute_hold,trim_metalfill,post_tcl)                <file>
# set vars(postroute_hold,trim_metalfill,replace_tcl)             <file>
# set vars(postroute_hold,trim_metalfill,skip)                    <true or false>
# set vars(postroute_hold,save_design,pre_tcl)                    <file>
# set vars(postroute_hold,save_design,post_tcl)                   <file>
# set vars(postroute_hold,save_design,replace_tcl)                <file>
# set vars(postroute_hold,save_design,skip)                       <true or false>
# set vars(postroute_hold,report_power,pre_tcl)                   <file>
# set vars(postroute_hold,report_power,post_tcl)                  <file>
# set vars(postroute_hold,report_power,replace_tcl)               <file>
# set vars(postroute_hold,report_power,skip)                      <true or false>
# set vars(postroute_hold,verify_power_domain,pre_tcl)            <file>
# set vars(postroute_hold,verify_power_domain,post_tcl)           <file>
# set vars(postroute_hold,verify_power_domain,replace_tcl)        <file>
# set vars(postroute_hold,verify_power_domain,skip)               <true or false>
# set vars(postroute_hold,run_clp,pre_tcl)                        <file>
# set vars(postroute_hold,run_clp,post_tcl)                       <file>
# set vars(postroute_hold,run_clp,replace_tcl)                    <file>
# set vars(postroute_hold,run_clp,skip)                           <true or false>
# set vars(postroute_si_hold,set_distribute_host,pre_tcl)         <file>
# set vars(postroute_si_hold,set_distribute_host,post_tcl)        <file>
# set vars(postroute_si_hold,set_distribute_host,replace_tcl)     <file>
# set vars(postroute_si_hold,set_distribute_host,skip)            <true or false>
# set vars(postroute_si_hold,set_multi_cpu_usage,pre_tcl)         <file>
# set vars(postroute_si_hold,set_multi_cpu_usage,post_tcl)        <file>
# set vars(postroute_si_hold,set_multi_cpu_usage,replace_tcl)     <file>
# set vars(postroute_si_hold,set_multi_cpu_usage,skip)            <true or false>
# set vars(postroute_si_hold,initialize_step,pre_tcl)             <file>
# set vars(postroute_si_hold,initialize_step,post_tcl)            <file>
# set vars(postroute_si_hold,initialize_step,replace_tcl)         <file>
# set vars(postroute_si_hold,initialize_step,skip)                <true or false>
# set vars(postroute_si_hold,set_design_mode,pre_tcl)             <file>
# set vars(postroute_si_hold,set_design_mode,post_tcl)            <file>
# set vars(postroute_si_hold,set_design_mode,replace_tcl)         <file>
# set vars(postroute_si_hold,set_design_mode,skip)                <true or false>
# set vars(postroute_si_hold,set_dont_use,pre_tcl)                <file>
# set vars(postroute_si_hold,set_dont_use,post_tcl)               <file>
# set vars(postroute_si_hold,set_dont_use,replace_tcl)            <file>
# set vars(postroute_si_hold,set_dont_use,skip)                   <true or false>
# set vars(postroute_si_hold,set_opt_mode,pre_tcl)                <file>
# set vars(postroute_si_hold,set_opt_mode,post_tcl)               <file>
# set vars(postroute_si_hold,set_opt_mode,replace_tcl)            <file>
# set vars(postroute_si_hold,set_opt_mode,skip)                   <true or false>
# set vars(postroute_si_hold,set_extract_rc_mode,pre_tcl)         <file>
# set vars(postroute_si_hold,set_extract_rc_mode,post_tcl)        <file>
# set vars(postroute_si_hold,set_extract_rc_mode,replace_tcl)     <file>
# set vars(postroute_si_hold,set_extract_rc_mode,skip)            <true or false>
# set vars(postroute_si_hold,set_si_mode,pre_tcl)                 <file>
# set vars(postroute_si_hold,set_si_mode,post_tcl)                <file>
# set vars(postroute_si_hold,set_si_mode,replace_tcl)             <file>
# set vars(postroute_si_hold,set_si_mode,skip)                    <true or false>
# set vars(postroute_si_hold,set_delay_cal_mode,pre_tcl)          <file>
# set vars(postroute_si_hold,set_delay_cal_mode,post_tcl)         <file>
# set vars(postroute_si_hold,set_delay_cal_mode,replace_tcl)      <file>
# set vars(postroute_si_hold,set_delay_cal_mode,skip)             <true or false>
# set vars(postroute_si_hold,set_analysis_mode,pre_tcl)           <file>
# set vars(postroute_si_hold,set_analysis_mode,post_tcl)          <file>
# set vars(postroute_si_hold,set_analysis_mode,replace_tcl)       <file>
# set vars(postroute_si_hold,set_analysis_mode,skip)              <true or false>
# set vars(postroute_si_hold,add_metalfill,pre_tcl)               <file>
# set vars(postroute_si_hold,add_metalfill,post_tcl)              <file>
# set vars(postroute_si_hold,add_metalfill,replace_tcl)           <file>
# set vars(postroute_si_hold,add_metalfill,skip)                  <true or false>
# set vars(postroute_si_hold,delete_filler_cells,pre_tcl)         <file>
# set vars(postroute_si_hold,delete_filler_cells,post_tcl)        <file>
# set vars(postroute_si_hold,delete_filler_cells,replace_tcl)     <file>
# set vars(postroute_si_hold,delete_filler_cells,skip)            <true or false>
# set vars(postroute_si_hold,opt_design,pre_tcl)                  <file>
# set vars(postroute_si_hold,opt_design,post_tcl)                 <file>
# set vars(postroute_si_hold,opt_design,replace_tcl)              <file>
# set vars(postroute_si_hold,opt_design,skip)                     <true or false>
# set vars(postroute_si_hold,add_filler_cells,pre_tcl)            <file>
# set vars(postroute_si_hold,add_filler_cells,post_tcl)           <file>
# set vars(postroute_si_hold,add_filler_cells,replace_tcl)        <file>
# set vars(postroute_si_hold,add_filler_cells,skip)               <true or false>
# set vars(postroute_si_hold,trim_metalfill,pre_tcl)              <file>
# set vars(postroute_si_hold,trim_metalfill,post_tcl)             <file>
# set vars(postroute_si_hold,trim_metalfill,replace_tcl)          <file>
# set vars(postroute_si_hold,trim_metalfill,skip)                 <true or false>
# set vars(postroute_si_hold,save_design,pre_tcl)                 <file>
# set vars(postroute_si_hold,save_design,post_tcl)                <file>
# set vars(postroute_si_hold,save_design,replace_tcl)             <file>
# set vars(postroute_si_hold,save_design,skip)                    <true or false>
# set vars(postroute_si_hold,report_power,pre_tcl)                <file>
# set vars(postroute_si_hold,report_power,post_tcl)               <file>
# set vars(postroute_si_hold,report_power,replace_tcl)            <file>
# set vars(postroute_si_hold,report_power,skip)                   <true or false>
# set vars(postroute_si_hold,verify_power_domain,pre_tcl)         <file>
# set vars(postroute_si_hold,verify_power_domain,post_tcl)        <file>
# set vars(postroute_si_hold,verify_power_domain,replace_tcl)     <file>
# set vars(postroute_si_hold,verify_power_domain,skip)            <true or false>
# set vars(postroute_si_hold,run_clp,pre_tcl)                     <file>
# set vars(postroute_si_hold,run_clp,post_tcl)                    <file>
# set vars(postroute_si_hold,run_clp,replace_tcl)                 <file>
# set vars(postroute_si_hold,run_clp,skip)                        <true or false>
# set vars(postroute_si,set_distribute_host,pre_tcl)              <file>
# set vars(postroute_si,set_distribute_host,post_tcl)             <file>
# set vars(postroute_si,set_distribute_host,replace_tcl)          <file>
# set vars(postroute_si,set_distribute_host,skip)                 <true or false>
# set vars(postroute_si,set_multi_cpu_usage,pre_tcl)              <file>
# set vars(postroute_si,set_multi_cpu_usage,post_tcl)             <file>
# set vars(postroute_si,set_multi_cpu_usage,replace_tcl)          <file>
# set vars(postroute_si,set_multi_cpu_usage,skip)                 <true or false>
# set vars(postroute_si,initialize_step,pre_tcl)                  <file>
# set vars(postroute_si,initialize_step,post_tcl)                 <file>
# set vars(postroute_si,initialize_step,replace_tcl)              <file>
# set vars(postroute_si,initialize_step,skip)                     <true or false>
# set vars(postroute_si,set_design_mode,pre_tcl)                  <file>
# set vars(postroute_si,set_design_mode,post_tcl)                 <file>
# set vars(postroute_si,set_design_mode,replace_tcl)              <file>
# set vars(postroute_si,set_design_mode,skip)                     <true or false>
# set vars(postroute_si,set_extract_rc_mode,pre_tcl)              <file>
# set vars(postroute_si,set_extract_rc_mode,post_tcl)             <file>
# set vars(postroute_si,set_extract_rc_mode,replace_tcl)          <file>
# set vars(postroute_si,set_extract_rc_mode,skip)                 <true or false>
# set vars(postroute_si,set_si_mode,pre_tcl)                      <file>
# set vars(postroute_si,set_si_mode,post_tcl)                     <file>
# set vars(postroute_si,set_si_mode,replace_tcl)                  <file>
# set vars(postroute_si,set_si_mode,skip)                         <true or false>
# set vars(postroute_si,set_analysis_mode,pre_tcl)                <file>
# set vars(postroute_si,set_analysis_mode,post_tcl)               <file>
# set vars(postroute_si,set_analysis_mode,replace_tcl)            <file>
# set vars(postroute_si,set_analysis_mode,skip)                   <true or false>
# set vars(postroute_si,set_delay_cal_mode,pre_tcl)               <file>
# set vars(postroute_si,set_delay_cal_mode,post_tcl)              <file>
# set vars(postroute_si,set_delay_cal_mode,replace_tcl)           <file>
# set vars(postroute_si,set_delay_cal_mode,skip)                  <true or false>
# set vars(postroute_si,add_metalfill,pre_tcl)                    <file>
# set vars(postroute_si,add_metalfill,post_tcl)                   <file>
# set vars(postroute_si,add_metalfill,replace_tcl)                <file>
# set vars(postroute_si,add_metalfill,skip)                       <true or false>
# set vars(postroute_si,delete_filler_cells,pre_tcl)              <file>
# set vars(postroute_si,delete_filler_cells,post_tcl)             <file>
# set vars(postroute_si,delete_filler_cells,replace_tcl)          <file>
# set vars(postroute_si,delete_filler_cells,skip)                 <true or false>
# set vars(postroute_si,opt_design,pre_tcl)                       <file>
# set vars(postroute_si,opt_design,post_tcl)                      <file>
# set vars(postroute_si,opt_design,replace_tcl)                   <file>
# set vars(postroute_si,opt_design,skip)                          <true or false>
# set vars(postroute_si,add_filler_cells,pre_tcl)                 <file>
# set vars(postroute_si,add_filler_cells,post_tcl)                <file>
# set vars(postroute_si,add_filler_cells,replace_tcl)             <file>
# set vars(postroute_si,add_filler_cells,skip)                    <true or false>
# set vars(postroute_si,trim_metalfill,pre_tcl)                   <file>
# set vars(postroute_si,trim_metalfill,post_tcl)                  <file>
# set vars(postroute_si,trim_metalfill,replace_tcl)               <file>
# set vars(postroute_si,trim_metalfill,skip)                      <true or false>
# set vars(postroute_si,save_design,pre_tcl)                      <file>
# set vars(postroute_si,save_design,post_tcl)                     <file>
# set vars(postroute_si,save_design,replace_tcl)                  <file>
# set vars(postroute_si,save_design,skip)                         <true or false>
# set vars(postroute_si,report_power,pre_tcl)                     <file>
# set vars(postroute_si,report_power,post_tcl)                    <file>
# set vars(postroute_si,report_power,replace_tcl)                 <file>
# set vars(postroute_si,report_power,skip)                        <true or false>
# set vars(postroute_si,verify_power_domain,pre_tcl)              <file>
# set vars(postroute_si,verify_power_domain,post_tcl)             <file>
# set vars(postroute_si,verify_power_domain,replace_tcl)          <file>
# set vars(postroute_si,verify_power_domain,skip)                 <true or false>
# set vars(postroute_si,run_clp,pre_tcl)                          <file>
# set vars(postroute_si,run_clp,post_tcl)                         <file>
# set vars(postroute_si,run_clp,replace_tcl)                      <file>
# set vars(postroute_si,run_clp,skip)                             <true or false>
# set vars(signoff,fix_litho,pre_tcl)                             <file>
# set vars(signoff,fix_litho,post_tcl)                            <file>
# set vars(signoff,fix_litho,replace_tcl)                         <file>
# set vars(signoff,fix_litho,skip)                                <true or false>
# set vars(signoff,add_metalfill,pre_tcl)                         <file>
# set vars(signoff,add_metalfill,post_tcl)                        <file>
# set vars(signoff,add_metalfill,replace_tcl)                     <file>
# set vars(signoff,add_metalfill,skip)                            <true or false>
# set vars(signoff,set_distribute_host,pre_tcl)                   <file>
# set vars(signoff,set_distribute_host,post_tcl)                  <file>
# set vars(signoff,set_distribute_host,replace_tcl)               <file>
# set vars(signoff,set_distribute_host,skip)                      <true or false>
# set vars(signoff,set_multi_cpu_usage,pre_tcl)                   <file>
# set vars(signoff,set_multi_cpu_usage,post_tcl)                  <file>
# set vars(signoff,set_multi_cpu_usage,replace_tcl)               <file>
# set vars(signoff,set_multi_cpu_usage,skip)                      <true or false>
# set vars(signoff,set_design_mode,pre_tcl)                       <file>
# set vars(signoff,set_design_mode,post_tcl)                      <file>
# set vars(signoff,set_design_mode,replace_tcl)                   <file>
# set vars(signoff,set_design_mode,skip)                          <true or false>
# set vars(signoff,initialize_timing,pre_tcl)                     <file>
# set vars(signoff,initialize_timing,post_tcl)                    <file>
# set vars(signoff,initialize_timing,replace_tcl)                 <file>
# set vars(signoff,initialize_timing,skip)                        <true or false>
# set vars(signoff,initialize_step,pre_tcl)                       <file>
# set vars(signoff,initialize_step,post_tcl)                      <file>
# set vars(signoff,initialize_step,replace_tcl)                   <file>
# set vars(signoff,initialize_step,skip)                          <true or false>
# set vars(signoff,set_analysis_mode,pre_tcl)                     <file>
# set vars(signoff,set_analysis_mode,post_tcl)                    <file>
# set vars(signoff,set_analysis_mode,replace_tcl)                 <file>
# set vars(signoff,set_analysis_mode,skip)                        <true or false>
# set vars(signoff,set_delay_cal_mode,pre_tcl)                    <file>
# set vars(signoff,set_delay_cal_mode,post_tcl)                   <file>
# set vars(signoff,set_delay_cal_mode,replace_tcl)                <file>
# set vars(signoff,set_delay_cal_mode,skip)                       <true or false>
# set vars(signoff,set_extract_rc_mode,pre_tcl)                   <file>
# set vars(signoff,set_extract_rc_mode,post_tcl)                  <file>
# set vars(signoff,set_extract_rc_mode,replace_tcl)               <file>
# set vars(signoff,set_extract_rc_mode,skip)                      <true or false>
# set vars(signoff,extract_rc,pre_tcl)                            <file>
# set vars(signoff,extract_rc,post_tcl)                           <file>
# set vars(signoff,extract_rc,replace_tcl)                        <file>
# set vars(signoff,extract_rc,skip)                               <true or false>
# set vars(signoff,dump_spef,pre_tcl)                             <file>
# set vars(signoff,dump_spef,post_tcl)                            <file>
# set vars(signoff,dump_spef,replace_tcl)                         <file>
# set vars(signoff,dump_spef,skip)                                <true or false>
# set vars(signoff,time_design_setup,pre_tcl)                     <file>
# set vars(signoff,time_design_setup,post_tcl)                    <file>
# set vars(signoff,time_design_setup,replace_tcl)                 <file>
# set vars(signoff,time_design_setup,skip)                        <true or false>
# set vars(signoff,time_design_hold,pre_tcl)                      <file>
# set vars(signoff,time_design_hold,post_tcl)                     <file>
# set vars(signoff,time_design_hold,replace_tcl)                  <file>
# set vars(signoff,time_design_hold,skip)                         <true or false>
# set vars(signoff,stream_out,pre_tcl)                            <file>
# set vars(signoff,stream_out,post_tcl)                           <file>
# set vars(signoff,stream_out,replace_tcl)                        <file>
# set vars(signoff,stream_out,skip)                               <true or false>
# set vars(signoff,oasis_out,pre_tcl)                             <file>
# set vars(signoff,oasis_out,post_tcl)                            <file>
# set vars(signoff,oasis_out,replace_tcl)                         <file>
# set vars(signoff,oasis_out,skip)                                <true or false>
# set vars(signoff,save_oa_design,pre_tcl)                        <file>
# set vars(signoff,save_oa_design,post_tcl)                       <file>
# set vars(signoff,save_oa_design,replace_tcl)                    <file>
# set vars(signoff,save_oa_design,skip)                           <true or false>
# set vars(signoff,create_ilm,pre_tcl)                            <file>
# set vars(signoff,create_ilm,post_tcl)                           <file>
# set vars(signoff,create_ilm,replace_tcl)                        <file>
# set vars(signoff,create_ilm,skip)                               <true or false>
# set vars(signoff,summary_report,pre_tcl)                        <file>
# set vars(signoff,summary_report,post_tcl)                       <file>
# set vars(signoff,summary_report,replace_tcl)                    <file>
# set vars(signoff,summary_report,skip)                           <true or false>
# set vars(signoff,verify_connectivity,pre_tcl)                   <file>
# set vars(signoff,verify_connectivity,post_tcl)                  <file>
# set vars(signoff,verify_connectivity,replace_tcl)               <file>
# set vars(signoff,verify_connectivity,skip)                      <true or false>
# set vars(signoff,verify_geometry,pre_tcl)                       <file>
# set vars(signoff,verify_geometry,post_tcl)                      <file>
# set vars(signoff,verify_geometry,replace_tcl)                   <file>
# set vars(signoff,verify_geometry,skip)                          <true or false>
# set vars(signoff,verify_metal_density,pre_tcl)                  <file>
# set vars(signoff,verify_metal_density,post_tcl)                 <file>
# set vars(signoff,verify_metal_density,replace_tcl)              <file>
# set vars(signoff,verify_metal_density,skip)                     <true or false>
# set vars(signoff,verify_process_antenna,pre_tcl)                <file>
# set vars(signoff,verify_process_antenna,post_tcl)               <file>
# set vars(signoff,verify_process_antenna,replace_tcl)            <file>
# set vars(signoff,verify_process_antenna,skip)                   <true or false>
# set vars(signoff,save_design,pre_tcl)                           <file>
# set vars(signoff,save_design,post_tcl)                          <file>
# set vars(signoff,save_design,replace_tcl)                       <file>
# set vars(signoff,save_design,skip)                              <true or false>
# set vars(signoff,report_power,pre_tcl)                          <file>
# set vars(signoff,report_power,post_tcl)                         <file>
# set vars(signoff,report_power,replace_tcl)                      <file>
# set vars(signoff,report_power,skip)                             <true or false>
# set vars(signoff,verify_power_domain,pre_tcl)                   <file>
# set vars(signoff,verify_power_domain,post_tcl)                  <file>
# set vars(signoff,verify_power_domain,replace_tcl)               <file>
# set vars(signoff,verify_power_domain,skip)                      <true or false>
# set vars(signoff,run_clp,pre_tcl)                               <file>
# set vars(signoff,run_clp,post_tcl)                              <file>
# set vars(signoff,run_clp,replace_tcl)                           <file>
# set vars(signoff,run_clp,skip)                                  <true or false>
# set vars(partition,initialize_timing,pre_tcl)                   <file>
# set vars(partition,initialize_timing,post_tcl)                  <file>
# set vars(partition,initialize_timing,replace_tcl)               <file>
# set vars(partition,initialize_timing,skip)                      <true or false>
# set vars(partition,load_cpf,pre_tcl)                            <file>
# set vars(partition,load_cpf,post_tcl)                           <file>
# set vars(partition,load_cpf,replace_tcl)                        <file>
# set vars(partition,load_cpf,skip)                               <true or false>
# set vars(partition,commit_cpf,pre_tcl)                          <file>
# set vars(partition,commit_cpf,post_tcl)                         <file>
# set vars(partition,commit_cpf,replace_tcl)                      <file>
# set vars(partition,commit_cpf,skip)                             <true or false>
# set vars(partition,load_ieee1801,pre_tcl)                       <file>
# set vars(partition,load_ieee1801,post_tcl)                      <file>
# set vars(partition,load_ieee1801,replace_tcl)                   <file>
# set vars(partition,load_ieee1801,skip)                          <true or false>
# set vars(partition,commit_ieee1801,pre_tcl)                     <file>
# set vars(partition,commit_ieee1801,post_tcl)                    <file>
# set vars(partition,commit_ieee1801,replace_tcl)                 <file>
# set vars(partition,commit_ieee1801,skip)                        <true or false>
# set vars(partition,run_clp_init,pre_tcl)                        <file>
# set vars(partition,run_clp_init,post_tcl)                       <file>
# set vars(partition,run_clp_init,replace_tcl)                    <file>
# set vars(partition,run_clp_init,skip)                           <true or false>
# set vars(partition,save_init_dbs,pre_tcl)                       <file>
# set vars(partition,save_init_dbs,post_tcl)                      <file>
# set vars(partition,save_init_dbs,replace_tcl)                   <file>
# set vars(partition,save_init_dbs,skip)                          <true or false>
# set vars(partition,set_budgeting_mode,pre_tcl)                  <file>
# set vars(partition,set_budgeting_mode,post_tcl)                 <file>
# set vars(partition,set_budgeting_mode,replace_tcl)              <file>
# set vars(partition,set_budgeting_mode,skip)                     <true or false>
# set vars(partition,update_constraint_mode,pre_tcl)              <file>
# set vars(partition,update_constraint_mode,post_tcl)             <file>
# set vars(partition,update_constraint_mode,replace_tcl)          <file>
# set vars(partition,update_constraint_mode,skip)                 <true or false>
# set vars(partition,set_ptn_user_cns_file,pre_tcl)               <file>
# set vars(partition,set_ptn_user_cns_file,post_tcl)              <file>
# set vars(partition,set_ptn_user_cns_file,replace_tcl)           <file>
# set vars(partition,set_ptn_user_cns_file,skip)                  <true or false>
# set vars(partition,set_place_mode,pre_tcl)                      <file>
# set vars(partition,set_place_mode,post_tcl)                     <file>
# set vars(partition,set_place_mode,replace_tcl)                  <file>
# set vars(partition,set_place_mode,skip)                         <true or false>
# set vars(partition,place_design,pre_tcl)                        <file>
# set vars(partition,place_design,post_tcl)                       <file>
# set vars(partition,place_design,replace_tcl)                    <file>
# set vars(partition,place_design,skip)                           <true or false>
# set vars(partition,save_place_dbs,pre_tcl)                      <file>
# set vars(partition,save_place_dbs,post_tcl)                     <file>
# set vars(partition,save_place_dbs,replace_tcl)                  <file>
# set vars(partition,save_place_dbs,skip)                         <true or false>
# set vars(partition,trial_route,pre_tcl)                         <file>
# set vars(partition,trial_route,post_tcl)                        <file>
# set vars(partition,trial_route,replace_tcl)                     <file>
# set vars(partition,trial_route,skip)                            <true or false>
# set vars(partition,assign_ptn_pins,pre_tcl)                     <file>
# set vars(partition,assign_ptn_pins,post_tcl)                    <file>
# set vars(partition,assign_ptn_pins,replace_tcl)                 <file>
# set vars(partition,assign_ptn_pins,skip)                        <true or false>
# set vars(partition,check_pin_assignment,pre_tcl)                <file>
# set vars(partition,check_pin_assignment,post_tcl)               <file>
# set vars(partition,check_pin_assignment,replace_tcl)            <file>
# set vars(partition,check_pin_assignment,skip)                   <true or false>
# set vars(partition,report_unaligned_nets,pre_tcl)               <file>
# set vars(partition,report_unaligned_nets,post_tcl)              <file>
# set vars(partition,report_unaligned_nets,replace_tcl)           <file>
# set vars(partition,report_unaligned_nets,skip)                  <true or false>
# set vars(partition,set_ptn_pin_status,pre_tcl)                  <file>
# set vars(partition,set_ptn_pin_status,post_tcl)                 <file>
# set vars(partition,set_ptn_pin_status,replace_tcl)              <file>
# set vars(partition,set_ptn_pin_status,skip)                     <true or false>
# set vars(partition,derive_timing_budget,pre_tcl)                <file>
# set vars(partition,derive_timing_budget,post_tcl)               <file>
# set vars(partition,derive_timing_budget,replace_tcl)            <file>
# set vars(partition,derive_timing_budget,skip)                   <true or false>
# set vars(partition,save_budget_dbs,pre_tcl)                     <file>
# set vars(partition,save_budget_dbs,post_tcl)                    <file>
# set vars(partition,save_budget_dbs,replace_tcl)                 <file>
# set vars(partition,save_budget_dbs,skip)                        <true or false>
# set vars(partition,run_clp,pre_tcl)                             <file>
# set vars(partition,run_clp,post_tcl)                            <file>
# set vars(partition,run_clp,replace_tcl)                         <file>
# set vars(partition,run_clp,skip)                                <true or false>
# set vars(partition,partition,pre_tcl)                           <file>
# set vars(partition,partition,post_tcl)                          <file>
# set vars(partition,partition,replace_tcl)                       <file>
# set vars(partition,partition,skip)                              <true or false>
# set vars(partition,save_partition,pre_tcl)                      <file>
# set vars(partition,save_partition,post_tcl)                     <file>
# set vars(partition,save_partition,replace_tcl)                  <file>
# set vars(partition,save_partition,skip)                         <true or false>
# set vars(rebudget,initialize_timing,pre_tcl)                    <file>
# set vars(rebudget,initialize_timing,post_tcl)                   <file>
# set vars(rebudget,initialize_timing,replace_tcl)                <file>
# set vars(rebudget,initialize_timing,skip)                       <true or false>
# set vars(assemble,assemble_design,pre_tcl)                      <file>
# set vars(assemble,assemble_design,post_tcl)                     <file>
# set vars(assemble,assemble_design,replace_tcl)                  <file>
# set vars(assemble,assemble_design,skip)                         <true or false>
# set vars(assemble,specify_ilm,pre_tcl)                          <file>
# set vars(assemble,specify_ilm,post_tcl)                         <file>
# set vars(assemble,specify_ilm,replace_tcl)                      <file>
# set vars(assemble,specify_ilm,skip)                             <true or false>
# set vars(assemble,load_ilm_non_sdc_file,pre_tcl)                <file>
# set vars(assemble,load_ilm_non_sdc_file,post_tcl)               <file>
# set vars(assemble,load_ilm_non_sdc_file,replace_tcl)            <file>
# set vars(assemble,load_ilm_non_sdc_file,skip)                   <true or false>
# set vars(assemble,load_cpf,pre_tcl)                             <file>
# set vars(assemble,load_cpf,post_tcl)                            <file>
# set vars(assemble,load_cpf,replace_tcl)                         <file>
# set vars(assemble,load_cpf,skip)                                <true or false>
# set vars(assemble,commit_cpf,pre_tcl)                           <file>
# set vars(assemble,commit_cpf,post_tcl)                          <file>
# set vars(assemble,commit_cpf,replace_tcl)                       <file>
# set vars(assemble,commit_cpf,skip)                              <true or false>
# set vars(assemble,initialize_timing,pre_tcl)                    <file>
# set vars(assemble,initialize_timing,post_tcl)                   <file>
# set vars(assemble,initialize_timing,replace_tcl)                <file>
# set vars(assemble,initialize_timing,skip)                       <true or false>
# set vars(assemble,update_timing,pre_tcl)                        <file>
# set vars(assemble,update_timing,post_tcl)                       <file>
# set vars(assemble,update_timing,replace_tcl)                    <file>
# set vars(assemble,update_timing,skip)                           <true or false>
# set vars(assemble,pre_pac_verify_connectivity,pre_tcl)          <file>
# set vars(assemble,pre_pac_verify_connectivity,post_tcl)         <file>
# set vars(assemble,pre_pac_verify_connectivity,replace_tcl)      <file>
# set vars(assemble,pre_pac_verify_connectivity,skip)             <true or false>
# set vars(assemble,pre_pac_verify_geometry,pre_tcl)              <file>
# set vars(assemble,pre_pac_verify_geometry,post_tcl)             <file>
# set vars(assemble,pre_pac_verify_geometry,replace_tcl)          <file>
# set vars(assemble,pre_pac_verify_geometry,skip)                 <true or false>
# set vars(assemble,set_module_view,pre_tcl)                      <file>
# set vars(assemble,set_module_view,post_tcl)                     <file>
# set vars(assemble,set_module_view,replace_tcl)                  <file>
# set vars(assemble,set_module_view,skip)                         <true or false>
# set vars(assemble,delete_filler_cells,pre_tcl)                  <file>
# set vars(assemble,delete_filler_cells,post_tcl)                 <file>
# set vars(assemble,delete_filler_cells,replace_tcl)              <file>
# set vars(assemble,delete_filler_cells,skip)                     <true or false>
# set vars(assemble,opt_design,pre_tcl)                           <file>
# set vars(assemble,opt_design,post_tcl)                          <file>
# set vars(assemble,opt_design,replace_tcl)                       <file>
# set vars(assemble,opt_design,skip)                              <true or false>
# set vars(assemble,add_filler_cells,pre_tcl)                     <file>
# set vars(assemble,add_filler_cells,post_tcl)                    <file>
# set vars(assemble,add_filler_cells,replace_tcl)                 <file>
# set vars(assemble,add_filler_cells,skip)                        <true or false>
# set vars(assemble,post_pac_verify_connectivity,pre_tcl)         <file>
# set vars(assemble,post_pac_verify_connectivity,post_tcl)        <file>
# set vars(assemble,post_pac_verify_connectivity,replace_tcl)     <file>
# set vars(assemble,post_pac_verify_connectivity,skip)            <true or false>
# set vars(assemble,post_pac_verify_geometry,pre_tcl)             <file>
# set vars(assemble,post_pac_verify_geometry,post_tcl)            <file>
# set vars(assemble,post_pac_verify_geometry,replace_tcl)         <file>
# set vars(assemble,post_pac_verify_geometry,skip)                <true or false>
# set vars(flexilm,clear_active_logic_view,pre_tcl)               <file>
# set vars(flexilm,clear_active_logic_view,post_tcl)              <file>
# set vars(flexilm,clear_active_logic_view,replace_tcl)           <file>
# set vars(flexilm,clear_active_logic_view,skip)                  <true or false>
# set vars(flexilm,commit_module_model,pre_tcl)                   <file>
# set vars(flexilm,commit_module_model,post_tcl)                  <file>
# set vars(flexilm,commit_module_model,replace_tcl)               <file>
# set vars(flexilm,commit_module_model,skip)                      <true or false>
# set vars(flexilm,create_active_logic_view,pre_tcl)              <file>
# set vars(flexilm,create_active_logic_view,post_tcl)             <file>
# set vars(flexilm,create_active_logic_view,replace_tcl)          <file>
# set vars(flexilm,create_active_logic_view,skip)                 <true or false>
# set vars(flexilm,get_module_view,pre_tcl)                       <file>
# set vars(flexilm,get_module_view,post_tcl)                      <file>
# set vars(flexilm,get_module_view,replace_tcl)                   <file>
# set vars(flexilm,get_module_view,skip)                          <true or false>
# set vars(flexilm,report_resource,pre_tcl)                       <file>
# set vars(flexilm,report_resource,post_tcl)                      <file>
# set vars(flexilm,report_resource,replace_tcl)                   <file>
# set vars(flexilm,report_resource,skip)                          <true or false>
# set vars(flexilm,restore_design,pre_tcl)                        <file>
# set vars(flexilm,restore_design,post_tcl)                       <file>
# set vars(flexilm,restore_design,replace_tcl)                    <file>
# set vars(flexilm,restore_design,skip)                           <true or false>
# set vars(flexilm,save_dbs,pre_tcl)                              <file>
# set vars(flexilm,save_dbs,post_tcl)                             <file>
# set vars(flexilm,save_dbs,replace_tcl)                          <file>
# set vars(flexilm,save_dbs,skip)                                 <true or false>
# set vars(flexilm,set_hier_mode,pre_tcl)                         <file>
# set vars(flexilm,set_hier_mode,post_tcl)                        <file>
# set vars(flexilm,set_hier_mode,replace_tcl)                     <file>
# set vars(flexilm,set_hier_mode,skip)                            <true or false>
# set vars(flexilm,set_module_model,pre_tcl)                      <file>
# set vars(flexilm,set_module_model,post_tcl)                     <file>
# set vars(flexilm,set_module_model,replace_tcl)                  <file>
# set vars(flexilm,set_module_model,skip)                         <true or false>
# set vars(flexilm,update_partition,pre_tcl)                      <file>
# set vars(flexilm,update_partition,post_tcl)                     <file>
# set vars(flexilm,update_partition,replace_tcl)                  <file>
# set vars(flexilm,update_partition,skip)                         <true or false>

