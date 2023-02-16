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

global vars

###############################################################################
# Define some variables to point to data, libraries, and scripts
###############################################################################
set vars(design_root)  [pwd]/../..
set vars(data_root) "../synth/"
set vars(library_root) "../sky130_osu_sc_t18/18T_ms/"
set vars(script_root)  [pwd]/SCRIPTS
#set init_io_file encounter.io

###############################################################################
# The following variables define the design data
# --------------------------------------------------------------------
# vars(design)       <design name> REQUIRED
# vars(netlist)      <verilog netlist file> REQUIRED
# vars(cts_spec)     <cts spec file list > REQUIRED
# --------------------------------------------------------------------
# Either fp_file, def_files or both MUST be defined
# --------------------------------------------------------------------
# vars(fp_file)      <floorplan file>
# vars(fp_file)      <floorplan TCL file>
# vars(def_files)     <floorplan DEF file>
# --------------------------------------------------------------------
set vars(design)           "mult_seq"
set vars(netlist)          "$vars(data_root)/mult_seq.vh"
#set vars(fp_file)    $vars(data_root)/dtmf_recvr_core.fp
#set vars(cts_spec)  "$vars(data_root)/dtmf_recvr_core.ctstch"
#set vars(def_files) "$vars(data_root)/dtmf_recvr_core.scan.def.gz"
# --------------------------------------------------------------------
# vars(cpf_file)    <REQUIRED for LP flows>
# --------------------------------------------------------------------
#set vars(cpf_file)   $vars(data_root)/dtmf_recvr_core.cpf

###############################################################################
# The following are for the ILM based hierarchical flow
# vars(partition_list)                     <ptn1> <ptn2> ... REQUIRED
# vars(<ptn1>,cts_spec)                    <cts spec for ptn1> 
# vars(<ptn1>,latency_sdc)                 <latency sdc for ptn1> 
# vars(<ptn1>,incr_cts_sdc)                <post cts incr sdc for ptn1> OPTIONAL
# vars(<ptn1>,post_cts_sdc)                <post cts (full) sdc for ptn1> OPTIONAL
###############################################################################
#set vars(partition_list)                   "tdsp_core results_conv"
#set vars(dtmf_recvr_core,cts_spec)         $vars(data_root)/dtmf_recvr_core.ctstch
#set vars(dtmf_recvr_core,latency_sdc)      $vars(data_root)/dtmf_recvr_core.latency.sdc
#set vars(tdsp_core,cts_spec)               $vars(data_root)/tdsp_core.ctstch
#set vars(tdsp_core,setup_func,latency_sdc) $vars(data_root)/tdsp_core.latency.sdc
#set vars(results_conv,cts_spec)            $vars(data_root)/results_conv.ctstch
#set vars(results_conv,latency_sdc)         $vars(data_root)/results_conv.latency.sdc

###############################################################################
# The following are REQUIRED
# --------------------------------------------------------------------
# vars(process)                            <process node> (65nm, 90nm, e.g.)
# vars(max_route_layers)                   <top routing layer>
###############################################################################
set vars(process)                          130nm
set vars(max_route_layer)                  5

###############################################################################
# Define library sets ...
# --------------------------------------
# set vars(library_sets) "<set1> <set2> ..."
# set vars(<set1>,timing) <list of lib files> (REQUIRED)
# set vars(<set1>,si)     <list of cdb/udn files> (OPTIONAL)
###############################################################################
set vars(library_sets)   "libs_tt"
set vars(libs_tt,timing) "../sky130_osu_sc_t18/18T_ms/lib/sky130_osu_sc_18T_ms_TT_1P8_25C.ccs.lib"
set vars(lef_files) "../sky130_osu_sc_t18/sky130_osu_sc_18T.tlef \
		     ../sky130_osu_sc_t18/18T_ms/lef/sky130_osu_sc_18T_ms.lef "

###############################################################################
# Define rc corners ...
# --------------------------------------
# set vars(rc_corners)          "<corner1> <corner2> ..."
# set vars(<corner1>,T)          <temperature>
# set vars(<corner1>,cap_table)  <cap table for corner1>
###############################################################################
# Optionally define QRC technology information
# --------------------------------------
# set vars(<corner>,qx_tech_file) <qx_tech_file for corner1>
# set vars(<corner>,qx_lib_file)  <qx_lib_file for corner1>
# set vars(<corner>,qx_conf_file) <qx_conf_file for corner1>
###############################################################################
set vars(rc_corners)          "rc_typ"
set vars(rc_typ,T)            25
set vars(rc_typ,qx_tech_file) "./qrcTechFile"
#set vars(rc_max,cap_table)    $vars(design_root)/LIBS/N45/capTbl/cln45lp_edram_1p08m_cworst.capTbl
#set vars(rc_min,cap_table)    $vars(design_root)/LIBS/N45/capTbl/cln45lp_edram_1p08m_cbest.capTbl
#set vars(rc_max,qx_tech_file) $vars(design_root)/LIBS/N45/qrc/cln45lp_edram_1p08m_cworst/icecaps.tch
#set vars(rc_min,qx_tech_file) $vars(design_root)/LIBS/N45/qrc/cln45lp_edram_1p08m_cbest/icecaps.tch
#set vars(qx_layer_map_file)   $vars(design_root)/LIBS/N45/qrc/layer.map
#set vars(signoff_extraction_engine) qrc

###############################################################################
# Scale factors are also optional but are strongly encouraged for 
# obtaining the best flow convergence and QoR.  
# Scaling factors are applied per rc corner
# --------------------------------------------------------------------
# set vars(<rc_corner>,def_res_factor)     <pre-route resistance scale factor>
# set vars(<rc_corner>,def_clk_res_factor) <pre-route clock resistance scale factor>
# set vars(<rc_corner>,det_res_factor)     <post-route resistance scale factor>
# set vars(<rc_corner>,det_clk_res_factor) <post-route clock resistance scale factor>
# set vars(<rc_corner>,def_cap_factor)     <pre-route capacitance scale factor>
# set vars(<rc_corner>,def_clk_cap_factor) <pre-route clock capacitance scale factor>
# set vars(<rc_corner>,det_cap_factor)     <post-route capacitance scale factor>
# set vars(<rc_corner>,det_clk_cap_factor) <post-route clock capacitance scale factor>
# set vars(<rc_corner>,xcap_factor)        <post-route coupling capacitance scale factor>
###############################################################################
set vars(rc_max,def_res_factor)     1.00
set vars(rc_max,def_clk_res_factor) 1.00
set vars(rc_max,det_res_factor)     1.00
set vars(rc_max,det_clk_res_factor) 1.00
set vars(rc_max,def_cap_factor)     1.09
set vars(rc_max,def_clk_cap_factor) 1.00
set vars(rc_max,det_cap_factor)     1.00
set vars(rc_max,det_clk_cap_factor) 1.00
set vars(rc_max,xcap_factor)        1.00

set vars(rc_min,def_res_factor)     1.00
set vars(rc_min,det_res_factor)     1.00
set vars(rc_min,def_cap_factor)     1.00
set vars(rc_min,det_cap_factor)     1.00
set vars(rc_min,xcap_factor)        1.00

###############################################################################
# Define operating conditions (optional)
# --------------------------------------------------------------------
# set vars(opconds)                "<opcond1> <opcond2> ..."
# set vars(<opcond1>,library_file)  <library file >
# set vars(<opcond1>,process)       <process scale factor>
# set vars(<opcond1>,voltage)       <voltage>
# set vars(<opcond1>,temperature)   <temperature>
###############################################################################

###############################################################################
# Define delay corners ...
# --------------------------------------------------------------------
# set vars(delay_corners)          "<corner1> <corner2> ..."
# set vars(<corner1>,library_set)   <library_set> (previously defined)
# set vars(<corner1>,opcond)        <opcond> (previously defined) (optional)
# set vars(<corner1>,rc_corner)     <rc_corner> (previously defined)
###############################################################################
set vars(delay_corners) "corner_tt"
set vars(corner_tt,library_set) libs_tt
set vars(corner_tt,rc_corner) rc_typ

###############################################################################
# Define constraints modes ... 
# --------------------------------------------------------------------
# set vars(constraint_modes)          "<mode1> <mode2> ..."
# set vars(<mode1>,pre_cts_sdc)        <pre cts constraint file>
# set vars(<mode1>,post_cts_sdc)       <post cts constraint file> (optional)
###############################################################################

set vars(constraint_modes) "setup_func_mode"
set vars(setup_func_mode,pre_cts_sdc) "$vars(data_root)/mult_seq.sdc"

#set vars(constraint_modes)             "setup_func_mode hold_func_mode"
#set vars(setup_func_mode,pre_cts_sdc)  "$vars(data_root)/dtmf_recvr_core.sdc $vars(data_root)/prects.sdc"
#set vars(setup_func_mode,post_cts_sdc) "$vars(data_root)/dtmf_recvr_core.sdc $vars(data_root)/postcts.sdc"
#set vars(setup_func_mode,incr_cts_sdc)  $vars(data_root)/postcts.sdc

#set vars(hold_func_mode,pre_cts_sdc)    $vars(setup_func_mode,pre_cts_sdc)
#set vars(hold_func_mode,post_cts_sdc)   $vars(setup_func_mode,post_cts_sdc)

###############################################################################
# Define analysis views ...
# --------------------------------------------------------------------
# set vars(setup_analysis_views)    "<view1> <view2>"
# set vars(hold_analysis_views)     "<view1> <view2>"
# set vars(<view1>,delay_corner)     <delay corner>
# set vars(<view1>,constraint_mode)  <constraint mode>
###############################################################################
set vars(hold_analysis_views) "setup_func"
set vars(setup_analysis_views) "hold_func"
set vars(hold_func,delay_corner) corner_tt
set vars(hold_func,constraint_mode) setup_func_mode
set vars(setup_func,delay_corner) corner_tt
set vars(setup_func,constraint_mode) setup_func_mode

###############################################################################
# Define active setup and hold views and denote which are default
###############################################################################
set vars(default_setup_view) "setup_func"
set vars(default_hold_view)  "hold_func"
set vars(active_setup_views) "setup_func"
set vars(active_hold_views)  "hold_func"

###############################################################################
# Define derating factors for OCV here (clock and data). 
# Derating factors are applied per delay corner
###############################################################################
set vars(slow_max,data_cell_late)   1.00
set vars(slow_max,data_cell_early)  1.00
set vars(slow_max,data_net_late)    1.00
set vars(slow_max,data_net_early)   1.00
set vars(slow_max,clock_cell_late)  1.00
set vars(slow_max,clock_cell_early) 1.00
set vars(slow_max,clock_net_late)   1.00
set vars(slow_max,clock_net_early)  1.00

set vars(fast_min,data_cell_late)   1.00
set vars(fast_min,data_cell_early)  1.00
set vars(fast_min,data_net_late)    1.00
set vars(fast_min,data_net_early)   1.00
set vars(fast_min,clock_cell_late)  1.00
set vars(fast_min,clock_cell_early) 1.00
set vars(fast_min,clock_net_late)   1.00
set vars(fast_min,clock_net_early)  1.00

###############################################################################
# Define power/ground nets
###############################################################################
set vars(power_nets) "VDD"
set vars(ground_nets) "VSS"

#######################################################################
# Distribution setup
# lsf, rsh, local, or custom
#######################################################################
#set vars(distribute)           custom
#set vars(custom,script)        {/grid/sfi/farm/bin/gridsub -W 72:00 -P SOC7.1 \
#                                -R "SFIARCH==OPT64 && OSREL==EE40" -q lnx64}
#set vars(local_cpus)           2
#set vars(remote_hosts)         4
#set vars(cpu_per_remote_host)  2

Puts "<FF> Finished loading setup.tcl"
