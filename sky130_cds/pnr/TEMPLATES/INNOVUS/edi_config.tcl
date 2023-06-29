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

##########################################################################################
#                        INNOVUS FOUNDATION FLOW
#-----------------------------------------------------------------------------------------
# This is the Innovus foundation flow configuration file.  It contains all the necessary flow
# options to drive the CDNS flat and/or hier implementation flows. For low power flow,
# an addition low power configuration file (lp_config.tcl) is also required if power
# domain specific information needs to be defined.
##########################################################################################
# Optionally define the following when applicable
# --------------------------------------------------------------------
#set vars(assign_buffer)                  {1 -buffer <buffer name>}"
#set vars(buffer_tie_assign)              <true | false>
#set vars(dont_use_list)                  <list>
#set vars(delay_cells)                    <list>
#set vars(tie_cells)                      <list>
#set vars(tie_cells,max_distance)         <float>
#set vars(tie_cells,max_fanout)           <integer>
#set vars(skew_buffers)                   <list>
#set vars(filler_cells)                   <list>
#set vars(clock_gate_cells)               <list>
#set vars(jtag_cells)                     <list>
#set vars(jtag_rows)                      <integer>
#set vars(spare_cells)                    <list>
#set vars(enable_ocv)                     <string>
#set vars(enable_cppr)                    <string>
#set vars(enable_ss)                      <string>
#set vars(place_io_pins)                  <boolean> 
#set vars(clock_gate_aware)               <boolean>
#set vars(clock_gate_clone)               <boolean>
#set vars(clock_eco)                      <postcts | postroute | both>
#set vars(high_timing_effort)             <boolean>
#set vars(congestion_effort)              <low | medium | high>
#set vars(in_place_opt)                   <boolean>
#set vars(leakage_power_effort)           <none | low | high>
#set vars(dynamic_power_effort)           <none | low | high>
#set vars(useful_skew)                    <boolean>
#set vars(preserve_assertions)            <boolean>
#set vars(critical_range)                 <float> 
#set vars(all_end_points)                 <boolean>
#set vars(size_only_file)                 <file> 
#set vars(fix_fanout_load)                <boolean>
#set vars(run_cts)                        <boolean>
#set vars(cts_engine)                     <cts | ccopt | ccopt_cts> 
#set vars(cts_cell_list)                  <list of buffers/inverters>
#set vars(cts_buffer_cells)               <list of buffers>
#set vars(cts_inverter_cells)             <list of invertes>
#set vars(cts_use_inverters)              <boolean>
#set vars(cts_effort)                     <low | medium | high>
#set vars(cts_io_opt)                     <boolean>
#set vars(clk_tree_top_layer)             <integer>
#set vars(clk_leaf_top_layer)             <integer>
#set vars(clk_tree_bottom_layer)          <integer>
#set vars(clk_leaf_bottom_layer)          <integer>
#set vars(clk_tree_ndr)                   <valid non-default rule>
#set vars(clk_tree_extra_space)           <integer>
#set vars(clk_leaf_ndr)                   <valid non-default rule>
#set vars(clk_leaf_extra_space)           <integer>
#set vars(route_clock_nets)               <boolean>
#set vars(postcts_setup_hold)             <true or false>
#set vars(fix_hold)                       <boolean>
#set vars(fix_hold_ignore_ios)            <boolean>
#set vars(fix_hold_allow_tns_degradation) <boolean>
#set vars(multi_cut_effort)               <low | medium | high>
#set vars(litho_driven_routing)           <boolean>
#set vars(verify_litho)                   <boolean>
#set vars(lpa_tech_file)                  <file name>
#set vars(postroute_spread_wires)         <true | false>
#set vars(track_opt)                      <true or false>
#set vars(postroute_extraction_effort)    <low | medium | high>
#set vars(postroute_setup_hold)           <true or false>
#set vars(signoff_extraction_effort)      <low | medium | high>
#set vars(si_analysis_type)               <default | pessimistic>
#set vars(acceptable_wns)                 <string>
#set vars(report_power)                   <true or false>
#set vars(report_run_time)                <true or false>
#set vars(save_rc)                        <true of false>
#set vars(save_constraints)               <true of false>
#set vars(absolute_lib_path)              <true of false>
#set vars(relative_path)                  <true of false>
#set vars(time_design_options,setup)      "list of valid timeDesign options EXCLUDING -preCTS/postCTS/postRoute -prefix and -outDir"
#set vars(time_design_options,hold)       "list of valid timeDesign options EXCLUDING -preCTS/postCTS/postRoute -prefix and -outDir"
# --------------------------------------------------------------------
#  For hierarchical flows ...
#set vars(insert_feedthrough)              <true of false>
#set vars(placement_based_ptn)             <true of false>
#set vars(use_flexmodels)                  <true of false>
#set vars(use_proto_net_delay_model)       <true of false>
#set vars(budget_mode)                     "trial_ipo proto_net_delay_model giga_opt"
#set vars(flexmodel_as_ptn)                <true of false>
#set vars(flexmodel_art_based)             <true of false>

###############################################################################
# Below are the available plug-ins for the flat foundation flow.  Each 
# should point to a file. If the file doesn't exist, the flow will print
# a warning an continue.  The place_tcl and cts_tcl are unique in that 
# they REPLACE the placeDesign and clockDesign calls, respectively.
# --------------------------------------------------------------------
#set vars(always_source_tcl)              <file>
#set vars(final_always_source_tcl)        <file>
#set vars(pre_init_tcl)                   <file>
#set vars(post_init_tcl)                  <file>
#set vars(pre_place_tcl)                  <file>
#set vars(place_tcl)                      <file>
#set vars(post_place_tcl)                 <file>
#set vars(pre_prects_tcl)                 <file>
#set vars(post_prects_tcl)                <file>
#set vars(pre_cts_tcl)                    <file>
#set vars(cts_tcl)                        <file>
#set vars(post_cts_tcl)                   <file>
#set vars(pre_postcts_tcl)                <file>
#set vars(post_postcts_tcl)               <file>
#set vars(pre_postcts_hold_tcl)           <file>
#set vars(post_postcts_hold_tcl)          <file>
#set vars(pre_route_tcl)                  <file>
#set vars(post_route_tcl)                 <file>
#set vars(pre_postroute_tcl)              <file>
#set vars(post_postroute_tcl)             <file>
#set vars(pre_postroute_hold_tcl)         <file>
#set vars(post_postroute_hold_tcl)        <file>
#set vars(pre_postroute_si_tcl)           <file>
#set vars(post_postroute_si_tcl)          <file>
#set vars(pre_postroute_si_hold_tcl)      <file>
#set vars(post_postroute_si_hold_tcl)     <file>
#set vars(pre_signoff_tcl)                <file>
#set vars(post_signoff_tcl)               <file>
# --------------------------------------------------------------------
# Below are the plug-ins available for the hierarhical flow ... note
# the additional plug-ins for the partition and assemble steps.  
# Keep in mind 
#    - The partitioning step will also load the pre/post init
#      and pre/post place plug-ins.
#    - The assemble step will also load the pre/post signoff
#      plug-ins as well.  
# --------------------------------------------------------------------
#set vars(always_source_tcl)              <file>
#set vars(final_always_source_tcl)        <file>
#set vars(pre_init_tcl)                   <file>
#set vars(post_init_tcl)                  <file>
#set vars(pre_place_tcl)                  <file>
#set vars(place_tcl)                      <file>
#set vars(post_place_tcl)                 <file>
#set vars(pre_pin_assign_tcl)             <file> 
#set vars(post_pin_assign_tcl)            <file> 
#set vars(pre_partition_tcl)              <file> 
#set vars(post_partition_tcl)             <file> 
#set vars(pre_assemble_tcl)               <file> 
#set vars(post_assemble_tcl)              <file> 
#set vars(pre_signoff_tcl)                <file>
#set vars(post_signoff_tcl)               <file>
# --------------------------------------------------------------------
# All other plug-ins are only used during the flat implementation
# of the partitions. To enable plug-ins for partition implementation
# define in the vars(<part>,edi_config) file for that partition
# --------------------------------------------------------------------
# set vars(<ptn1>,edi_config_tcl)         <file>
# set vars(<ptn2>,edi_config_tcl)         <file>
# --------------------------------------------------------------------
# There are additional variables called command tags that provide more
# granular customization control.  See tags.tcl for more information

#######################################################################
# To insert metal fill during the flow define the following two
# variables:
# - vars(metalfill) [pre_postroute, pre_postroute_si, pre_signoff]
# - vars(metalfill_tcl) <path to metalfill plug-in>
#######################################################################
#set vars(metalfill)                  pre_postroute
#set vars(metalfill_tcl)              <file>

#######################################################################
# There are some flow control variables that can be set:
# - vars(abort) controls whether codegen aborts when error is found
#   in the variable setup.  This default to true.  When disabled,
#   possible TCL errors can occur during flow execution
# - vars(catch_errors) controls whether a catch is included around
#   each set of flow step commands.  The default is true.
# - vars(save_on_catch) controls whether a database is saved when
#   an error is caught. This defaults to true and only works
#   when vars(catch_errors) is true
# - vars(mail,to) and vars(mail,steps) control whether a mail message
#   is sent after each step completes.  When enabled a mail message
#   will be sent (containing the timing summary if available) for 
#   any step in vars(steps).  If vars(steps) is undefined, a message
#   will be sent for every step.
# 
# --------------------------------------------------------------------
# set vars(abort)                          <true or false>"
# set vars(catch_errors)                   <true or false>"
# set vars(save_on_catch)                  <true or false>"
# set vars(mail,to)                        [list of email addresses]
# set vasr(mail,steps)                     [list of steps]
# set vars(tags,verbose)                   <true or false>"
# set vars(tags,verbosity_level)           [high | low]"

#######################################################################
# Brief description of the above variables
# --------------------------------------------------------------------
# - dont_use_list (list of cell names to disable during optimization)
# - delay_cells (list of delay cells to enable during hold fixing)
# - cts_cell_list (list of cells for clockDesign)
# - skew_buffers (list of buffers to use during useful skew)
# - filler_cells (list of filler cells)
# - clock_gate_cells (list of clock gating elements)
# - jtag_cells (list of jtag instances)
# - jtag_rows (number of rows to use during  jtag placement)
# - spare_cells (list of spare cells instances)
# - gds_layer_map (gds layer map file)
# - gds_files (list of gds files)
# - oa_ref_lib (OA reference library name)
# - oa_abstract_view (OA abstract view name)
# - oa_layout_view (OA layout view name)
# - buffer_tie_assign (buffer logic 1/0 tie nets)
# - assign_buffer (buffer assign statements)
# --------------------------------------------------------------------
# The flow includes some options to enable some commonly used command options.  
# These flags provide easy access to certain options/commands within SOCE.  
# They should be set based on the needs of the design/methodology.  
# The inclusion of these options does not represent a recommendation. 
# --------------------------------------------------------------------
# For early runs, you may want to skip the cts step. To do this, use
# 'set vars(run_cts) false'
# --------------------------------------------------------------------
# To select ccoptDesign for CTS, use 
# 'set vars(cts_engine) 'ccopt' (default is cts)
# --------------------------------------------------------------------
# To select ccoptDesign -cts for CTS, use 
# 'set vars(cts_engine) 'ccopt_cts' (default is cts)
# --------------------------------------------------------------------
# To specify the integration method for CCOPT, use
# 'set vars(ccopt_integration) <native | scripted>
# --------------------------------------------------------------------
# To point to your own ccopt executable for scripted integration, use
# 'set vars(ccopt_executable) <path to executable>'
# --------------------------------------------------------------------
# Some other options that affect ccopt are:
# - vars(cts_buffer_list)
# - vars(cts_inverter_list)
# - vars(cts_use_inverters)
# - vars(cts_effort)
# - vars(cts_io_opt)
# --------------------------------------------------------------------
# Options for clock routing:
# -vars(clk_tree_top_layer)    (top layer for non-leaf nets)
# -vars(clk_leaf_top_layer)    (top layer for leaf nets) 
# -vars(clk_tree_bottom_layer) (bottom layer for non-leaf nets)
# -vars(clk_leaf_bottom_layer) (bottom layer for leaf nets)
# -vars(clk_tree_ndr)          (non-default rule for non-leaf nets)
# -vars(clk_tree_extra_space)  (extra space for non-leaf nets)
# -vars(clk_leaf_ndr)          (non-default rule for leaf nets0
# -vars(clk_leaf_extra_space)  (extra space for non-leaf nets)
# ====================================================================
# Common path pessimism removal will be enabled by default after cts
# To disable 'set vars(enable_cppr) false'
# --------------------------------------------------------------------
# Analysis mode 'onChipVariation' will be enabled by default prior
# to post-route optimization. To disable 'set vars(enable_ocv) false'
# To enable it elsewhere in the flow, use 'set vars(enable_ocv) <value>'
# Where <value> = "pre_place | pre_prects | pre_postcts |
#                  pre_postroute | pre_postroute_si | pre_signoff"
# --------------------------------------------------------------------
# The default leakage power effort is "none". For low power flows,
# 'set vars(leakage_power_effort) high'
# --------------------------------------------------------------------
# The default dynamic power effort is "none". For low power flows,
# 'set vars(dynamic_power_effort) high'
# --------------------------------------------------------------------
# The default recommendation is to NOT place IO pins during
# cell placement.  To enable pin placement,  
# set vars(place_io_pins) true 
# --------------------------------------------------------------------
# The enable clock gate aware placement, 
# 'set vars(clock_gate_aware) true'
# --------------------------------------------------------------------
# The enable clock gate cloning, use
# 'set vars(clock_gate_clone) true'
# --------------------------------------------------------------------
# The default recommendation is to route all clock nets
# during CTS.  To disable this 'set vars(route_clock_nets) false'
# --------------------------------------------------------------------
# To update IO latency after CTS, use
# 'set vars(update_io_latency) false'
# --------------------------------------------------------------------
# For congested designs, 'set vars(congestion_effort) high'
# --------------------------------------------------------------------
# To preserve constraints on IO ports (useful for hierarchical
# designs), 'set vars(preserve_assertions) true'
# --------------------------------------------------------------------
# To enable useful skew optimization, 'set vars(useful_skew) true'
# --------------------------------------------------------------------
# To enable TNS optimization, use
# 'set vars(all_end_points) <value>'
# ... critical range is no longer support 
# --------------------------------------------------------------------
# To use a size only file, 
# 'set vars(size_only_file) <file>'
# --------------------------------------------------------------------
# To enable fanout load fixing,
# 'set vars(fix_fanout_load) true'
# --------------------------------------------------------------------
# For difficult timing designs, 'set vars(high_timing_effort) true'
# This overrides certain user settings to enable a variety of options
# throughout the flow for optimal QoR at the expense of runtime
# --------------------------------------------------------------------
# To enable -inPlaceOpt, 'set vars(in_place_opt) true
# --------------------------------------------------------------------
# To enable useful skew optimization, 'set vars(useful_skew) true'
# Also, set vars(skew_buffers) to the list of useable clock buffers
# --------------------------------------------------------------------
# To disable hold fixing,
# 'set vars(fix_hold) false'
# --------------------------------------------------------------------
# To disable hold fixing for IO, 
# 'set vars(fix_hold_ignore_ios) true'
# --------------------------------------------------------------------
# To disallow hold fixing from degrading setup tns, use
# 'set vars(fix_hold_allow_tns_degradation) false'
# --------------------------------------------------------------------
# The flow default is to disable multi-cut via insertion.  For 90nm
# and below, it is recommended to insert multi-cut vias using
# 'set vars(multi_cut_effort) medium. This will come with a runtime and
# memory penalty and will also affect QoR.
# For maximum multi-cut via coverage 'set vars(multi_cut_effort) high'
# This will come with additional runtime/memory overhead.
# --------------------------------------------------------------------
# The default is not to do litho driven routing,
# To enable, use 'set vars(litho_driven_routing) true'
# To enable litho verify and repair, use 'set vars(verify_litho) true'
# --------------------------------------------------------------------
# To enable postroute wire spreading, use
# 'set vars(spread_wires) true'
# --------------------------------------------------------------------
# To enable diode based antenna fixing, use
# 'set vars(antenna_diode) <antenna cell>'
# --------------------------------------------------------------------
# The default postroute extraction effort, is detail extraction (low).
# To enable tQRC (medium), or iQRC (high) for the postroute closure
# flow, use 
# 'set vars(postroute_extraction_effort) <low | medium |  high>
# --------------------------------------------------------------------
# To disable AAE (default) delay calculation
# 'set vars(enable_si_aware) false'
# --------------------------------------------------------------------
# To enable third party SI correlation, use
# 'set vars(si_analysis_type) pessimistic'
# --------------------------------------------------------------------
# To enable celtic based analysis/fixing, use 
# 'set vars(enable_celtic_steps) true'
# --------------------------------------------------------------------
# To enable power reporting at each step in the flow, use
# 'set vars(report_power) true'
# To provide an activity for power optimization and reporting,
# 'set vars(activity_file)        <file>'
# 'set vars(activity_file_format) <TCF | SAIF | VCD>'
# --------------------------------------------------------------------
# There are some options to saveDesign:
# To save rcdb information for postroute steps, use
# 'set vars(save_rc) true '
# To save timing constraints, use:
# 'set vars(save_constraints) true'
# The folowing are used to control how the paths are written out:
# - vars(relative_path)
# - vars(absolute_lib_path)
# --------------------------------------------------------------------
# The default is to abort if there are errors found during the setup 
# check; to disable this, use
# set vars(abort) false"
