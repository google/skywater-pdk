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

##########################################################################################"
#                             CDNS FOUNDATION FLOW"
#-----------------------------------------------------------------------------------------"
# This is the foundation flow setup file.  It contains all the necessary design"
# data to drive all the CDNS foundation flows. Each flow will also require an"
# additional configuration file to define flow specific information:"
#-----------------------------------------------------------------------------------------"
# INNOVUS ->   innovus_config.tcl (for flat and hier implementation flows)"
#         +     lp_config.tcl (additional information for flat and hier lp flows)"
#         -> proto_config.tcl (for the prototyping flow)"
##########################################################################################"

global vars
set vars(version) 15.1

###############################################################################
# Define some variables to point to data, libraries, and scripts;
# script_root is required and must point to the foundation flow
# SCRIPTS directory.  Recommendation is that the SCRIPTS directory
# should reside within the RUN directory 
###############################################################################
set vars(design_root) <path to design data>
set vars(script_root) "./SCRIPTS"

###############################################################################
# The following variables are used to define 
# the design data for the flow.  Either a fp_file, 
# def_file or both can be defined
# --------------------------------------------------------------------
set vars(design)          <string> 
set vars(netlist)         <file>
set vars(fp_file)         <file>
#set vars(oa_fp)           "<lib> <cell> <view>"
#set vars(def_files)       <list>
#set vars(fp_tcl_file)    <TCL file>
#set vars(fp_tcl_proc)    <TCL procedure name>
set vars(cts_spec)        <list>
#set vars(scan_def)       <list>
# --------------------------------------------------------------------
set vars(process)         <string>
set vars(max_route_layer) <integer> 
set vars(generate_tracks) <boolean> (OPTIONAL)
#set vars(honor_pitch)     <boolean> (OPTIONAL)
###############################################################################
# One of cpf_file and ieee1801_file is REQUIRED for low power flows
# --------------------------------------------------------------------
#set vars(cpf_file)               <file>
#set vars(ieee1801_file)          <file>
# --------------------------------------------------------------------
# Optionally set the following to keep the previously defined rows
# If using IEEE 1801, replace "cpf" with "ieee1801".
#set vars(cpf_keep_rows)          <boolean>

###############################################################################
# Define power/ground nets
###############################################################################
#set vars(power_nets)             <list>
#set vars(ground_nets)            <list>
###############################################################################
# The following are for defining user ILMs for flat or hierarchical flows.
# vars(<ilm>,lef_file) is only necessary if the ILM lef file does not 
# exist in the vars(lef_files) list.
# --------------------------------------------------------------------
#set vars(ilm_list)               <list> 
#set vars(<ilm>,ilm_dir)          <directory> 
#set vars(<ilm>,lef_file)         <file>  
###############################################################################
# The following are REQUIRED for the ILM based 
# hierarchical flow but are not necessary for
# the flat implementation flows.
# - cts spec for each partiition
# - latency sdc for each partition
# - edi config file for each (when applicable)
# --------------------------------------------------------------------
#set vars(partition_list)         <list> 
#set vars(<ptn1>,cts_spec)        <file> 
#set vars(<ptn1>,latency_sdc)     <file>
#set vars(<ptn1>,<innovus_config_tcl) <file>

###############################################################################
# Define library sets ... (REQUIRED) 
# --------------------------------------------------------------------
set vars(library_sets)        <list>

set vars(<set1>,timing)       <list>
set vars(<set1>,si)           <list>

###############################################################################
# Define lef library files ... (REQUIRED)
# --------------------------------------------------------------------
set vars(lef_files)           <list>

###############################################################################
# Define rc corners ... (REQUIRED)
# --------------------------------------------------------------------
set vars(rc_corners)             <list>
set vars(<corner1>,T)            <integer>
set vars(<corner1>,cap_table)    <file>
#set vars(<corner1>,atf_file)    <file>
set vars(<corner1>,qx_tech_file) <file>
# set vars(<corner>,qx_lib_file)  <file>
# set vars(<corner>,qx_conf_file) <file>

###############################################################################
# Scale factors are also optional but are strongly encouraged for 
# obtaining the best flow convergence and QoR.  
# Scaling factors are applied per rc corner
# --------------------------------------------------------------------
# set vars(<corner1>,def_res_factor)     <pre-route resistance scale factor>
# set vars(<corner1>,det_res_factor)     <post-route resistance scale factor>
# set vars(<corner1>,def_cap_factor)     <pre-route capacitance scale factor>
# set vars(<corner1>,det_cap_factor)     <post-route capacitance scale factor>
# set vars(<corner1>,def_clk_res_factor) <pre-route clock resistance scale factor>
# set vars(<corner1>,det_clk_res_factor) <post-route clock resistance scale factor>
# set vars(<corner1>,def_clk_cap_factor) <pre-route clock capacitance scale factor>
# set vars(<corner1>,det_clk_cap_factor) <post-route clock capacitance scale factor>
# set vars(<corner1>,xcap_factor)        <coupling capacitance scale factor>
###############################################################################
set vars(<corner1>,def_res_factor)     <float>
set vars(<corner1>,det_res_factor)     <float | triplet>
set vars(<corner1>,def_cap_factor)     <float>
set vars(<corner1>,det_cap_factor)     <float | triplet>
set vars(<corner1>,def_clk_res_factor) <float>
set vars(<corner1>,det_clk_res_factor) <float>
set vars(<corner1>,def_clk_cap_factor) <float>
set vars(<corner1>,det_clk_cap_factor) <float>
set vars(<corner1>,xcap_factor)        <float | triplet>

###############################################################################
# Define operating conditions (optional)
# --------------------------------------------------------------------
# set vars(opconds) "<opcond1> <opcond2> ..."
# set vars(<opcond1>,library_file) <library file >
# set vars(<opcond1>,process) <process scale factor>
# set vars(<opcond1>,voltage) <voltage>
# set vars(<opcond1>,temperature) <temperature>
###############################################################################

###############################################################################
# Define delay corners ...
# --------------------------------------------------------------------
set vars(delay_corners)         <list>
set vars(<corner1>,library_set) <string>
set vars(<corner1>,rc_corner)   <string>
#---------------------------------------------------------------------
# Define derating factors for OCV here (clock and data). 
# Derating factors are applied per delay corner ...
# OR, simply define vars(derate_tcl) plug-in with ALL
# your set_timing_derate commands and it will be used
#---------------------------------------------------------------------
set vars(<corner1>,data_cell_late)   <float>
set vars(<corner1>,data_cell_early)  <float>
set vars(<corner1>,data_net_late)    <float>
set vars(<corner1>,data_net_early)   <float>
set vars(<corner1>,clock_cell_late)  <float>
set vars(<corner1>,clock_cell_early) <float>
set vars(<corner1>,clock_net_late)   <float>
set vars(<corner1>,clock_net_early)  <float>
#set vars(<corner1>,cell_check_late)  <float>
#set vars(<corner1>,cell_check_early) <float>

###############################################################################
# Define constraints modes ... (REQUIRED)
# --------------------------------------------------------------------
set vars(constraint_modes)      <list>
set vars(<mode1>,pre_cts_sdc)   <file>
# --------------------------------------------------------------------
# The following are optional for each mode ...
# Use EITHER incremental OR full post cts sdc
# --------------------------------------------------------------------
#set vars(<mode1>,post_cts_sdc)  <file>
#set vars(<mode1>,incr_cts_sdc)  <file>

###############################################################################
# Define analysis views ... (REQUIRED)
# --------------------------------------------------------------------
set vars(setup_analysis_views)    <list>
set vars(hold_analysis_views)     <list>

set vars(<view1>,delay_corner)    <string>
set vars(<view1>,constraint_mode) <string>

###############################################################################
# Define active setup and hold views and denote 
# which are default (REQUIRED)
###############################################################################
set vars(default_setup_view)      <string>
set vars(default_hold_view)       <string>
set vars(active_setup_views)      <list>
set vars(active_hold_views)       <list>

set vars(power_analysis_view)     <string>
###############################################################################
# Define GDS information ... (OPTIONAL)
# --------------------------------------------------------------------
#set vars(gds_files)             <list> 
#set vars(gds_layer_map)         <file>
#set vars(qrc_layer_map)         <file>
#set vars(qrc_library)           <directory>
#set vars(qrc_config_file)       <file>

###############################################################################
# Define extraction thresholds.  Below are the recommended settings for 90nm 
# and below.  The are not the flow defaultsso they need to be set here. 
###############################################################################
#set vars(relative_c_thresh)         <float>
#set vars(total_c_thresh)            <float> 
#set vars(coupling_c_thresh)         <float>

###############################################################################
# Define noise analysis settings.  Below are the recommended settings for 
# 90nm and below.  They are not the flow defaults as they come with a 
# run time penalty
###############################################################################
#set vars(delta_delay_threshold)     <float> 

#########################################################################################
# Variables for OA design import and export (OPTIONAL)
# ---------------------------------------------------------------------------------------
#set vars(oa_design_lib)         <string>
#set vars(oa_design_cell)        <string>
#set vars(oa_design_view)        <string>
# ---------------------------------------------------------------------------------------
#set vars(oa_ref_lib)            <string>
#set vars(oa_abstract_name)      <string>
#set vars(oa_layout_name)        <string>
#########################################################################################

#######################################################################
# Distribution setup - lsf, rsh, local, or custom
#######################################################################
#set vars(distribute)                <local | custom | lsf | rsh>
#set vars(distribute_timeout)        <seconds>
#set vars(custom,script)             <string>
#set vars(lsf,queue)                 <string>
#set vars(lsf,resource)              <string>
#set vars(lsf,args)                  <string>
#set vars(local_cpus)                <integer>
#set vars(remote_hosts)              <integer>
#set vars(cpus_per_remote_host)      <integer>
#set vars(rsh,hosts)                 <list>
#set vars(rsh,hosts)                 <list>

#######################################################################
# Design variables to handel large designs 10+M instances
# set placement_based_ptn to 1 to get place based flow
# set abutted_design to 1 to get steps like feedthrrouh with correct
# trialRoute settings
# set insert_feedthrough to 1 to add feedthrough for channel-based
# designs (feedthrough is always inserted for channelless designs,
# i.e. those where abutted_design is 1)
#######################################################################
#set vars(placement_based_ptn)                <boolean>
#set vars(abutted_design)                     <boolean>
#set vars(insert_feedthrough)                 <boolean>

#######################################################################
# Variables controlling the use of flexmodels in the top-down
# hierarchical flow.
#######################################################################
#set vars(use_flexmodels)                     <boolean>
#set vars(model_gen,art_based)                <boolean>
#set vars(model_gen,no_hold_view)             <boolean>
#set vars(model_gen,min_inst)                 <integer>

Puts "<FF> Finished loading setup.tcl"
