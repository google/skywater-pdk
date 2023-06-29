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
# Low power configuration file overlay.  This file contains foundation flow variables
# that are specific to the LP/CPF flow and should be used in addition to the setup.tcl
# and innovus_config.tcl files
##########################################################################################
#                           Placement Options
# ----------------------------------------------------------------------------------------
# set vars(resize_shifter_and_iso_insts) <true | false>
#
##########################################################################################
#                           Tie cell information
# ----------------------------------------------------------------------------------------
# The variable vars(tie_cells) is defined in the innovus_config.tcl and is used to define a 
# "global" tie cell list. This list will be used by default for each power domain.
# It can be overridden for a given power domain by setting vars(<power_domain>,tie_cells).
# ----------------------------------------------------------------------------------------
# set vars(domain,tie_cells) <tie cells for <power_domain>>
#
##########################################################################################
#                         Filler cell information
# ----------------------------------------------------------------------------------------
# The variable vars(filler_cells) is defined in the innovus_config.tcl and is used to define a 
# "global" filler cell list. This list will be used by default for each power domain.
# It can be overridden for a given power domain by setting vars(<power_domain>,filler_cells).
# ----------------------------------------------------------------------------------------
# set vars(domain,filler_cells) <filler cells for <power_domain>>
#
##########################################################################################
#                          Welltap cell information
# ----------------------------------------------------------------------------------------
# The variable vars(welltaps) is defined in the innovus_config.tcl and is used to define a 
# "global" welltap cell list. This list will be used by default for each power domain.
# It can be overridden for a given power domain by setting vars(<power_domain>,welltaps).
# ----------------------------------------------------------------------------------------
#    verify_rule : maximum distance (in microns) between welltap cells and standard cells 
#                  in microns
#        max_gap : specifies the maximum distance from the right edge of one well-tap cell 
#                  to the left edge of  the following well-tap cell in the same row
#  cell_interval : specifies the maximum distance from the center of one well-tap cell 
#                  to the center of the following well-tap cell in the same row
#
# NOTE: max_gap and cell_interval parameters are mutually exclusive, user has to define 
#       only one of these parameters to add welltap cells
#
# ----------------------------------------------------------------------------------------
# set vars(<power_domain>,welltaps) 		        <welltap cell list for <power_domain>>
# set vars(<power_domain>,welltaps,checkerboard)  <true or false>
# set vars(<power_domain>,welltaps,max_gap)       <max gap in microns>
# set vars(<power_domain>,welltaps,cell_interval) <cell interval in microns>
# set vars(<power_domain>,welltaps,row_offset)    <row offset in microns>
# set vars(<power_domain>,welltaps,verify_rule)   <verify rule distance>
#
##########################################################################################
#                          Endcap cell information
# ----------------------------------------------------------------------------------------
# The variables vars(pre_endcap) and vars(post_endcap) are set in the innovus_config.tcl file and
# are used to define "global" endcap cells. These used by default for each power domain.
# They can be overridden for a given power domain setting vars(<power_domain>,pre_endcap)
# and/or vars(<power_domain>,post_endcap).
# ----------------------------------------------------------------------------------------
# set vars(<power_domain>,pre_endcap)  <pre endcap cell for <power_domain>>
# set vars(<power_domain>,post_endcap) <post endcap cell for <power_domain>>
#
##########################################################################################
#                            Always on net buffering
# ----------------------------------------------------------------------------------------
# By default SOCE does always-on-net synthesis for SRPG control signal and PSO enable 
# signals as part of optDesign -preCTS, but this can be manually done for specific nets if
# necessary.  To do this, define the following variables and uncomment the pre_prects.tcl
# plug-in template
# ----------------------------------------------------------------------------------------
# set vars(always_on_buffers)                	<list of always on buffers>
# set vars(always_on_nets)                  	<list of always on nets>
# set vars(always_on_nets,max_fanout)       	<max fanout limit for always on nets> (optional)
# set vars(always_on_nets,max_tran)         	<max transition on always on nets> (optional)
# set vars(always_on_nets,max_skew)         	<max skew for always on nets> (optional)
# set vars(always_on_nets,max_delay)        	<max delay for always on nets> (optional)
# set vars(<power_domain>,always_on_buffers)  <buffers for <power domain>>
#
##########################################################################################
#                      Secondary power/ground routing
# ----------------------------------------------------------------------------------------
# Automatic secondary power routing can be enabled the foundation flows by setting 
# vars(route_secondary_pg_nets) to true and providing cell pin pair information to
# identify the connections requiring routing (PTBUFFD1:TVDD LVLLHCD4:VDDL, e.g.) 
# ----------------------------------------------------------------------------------------
# set vars(route_secondary_pg_nets)         [true | false]
# set vars(secondary_pg,cell_pin_pairs)     <secondary power cell pin pair list>
# ----------------------------------------------------------------------------------------
#In addition, the following can optionally defined either globally or per p/g net
# ----------------------------------------------------------------------------------------
# set vars(secondary_pg,max_fanout)       	<max fanout for secondary power routing>
# set vars(secondary_pg,pattern)          	<secondary power routing pattern trunk | steiner>
# set vars(secondary_pg,non_default_rule) 	<non-default rule for secondary p/g/ routing>
# ----------------------------------------------------------------------------------------
# To optionally override for a given p/g net(s), use the vars(route_secondary_pg_nets) to 
# define the list of nets to be overridden and then override vars(<p/g net>,<option>)
# ----------------------------------------------------------------------------------------
# set vars(secondary_pg,nets)          	    <list of power/ground nets>
# set vars(<p/g_net>,max_fanout)       	    <max fanout>
# set vars(<p/g_net>,pattern)          	    <trunk | steiner>
# set vars(<p/g_net>,non_default_rule) 	    <non default rule>
#
##########################################################################################
#                              runCLP options
# ----------------------------------------------------------------------------------------
# set vars(clp_options)  <options for runCLP>
# ----------------------------------------------------------------------------------------
# set vars(clp_options)  ""
#
##########################################################################################
#              Modify power domains, row creation for power domains
# ----------------------------------------------------------------------------------------
# The foundation flows contain a sample post_init_tcl (PLUG/post_init.tcl) plug-in to do 
# power domain modification automatically based on the folloing variables:
# ----------------------------------------------------------------------------------------
# set vars(<power_domain>,bbox)         <llx lly urx ury>; bondary coordinates in microns
# set vars(<power_domain>,rs_exts)      <top bot left right>; distance in microns  
# set vars(<power_domain>,min_gaps)     <top bot left right>; distance in microns
#
##########################################################################################
#                           Power Shut-off Planning 
# ----------------------------------------------------------------------------------------
# The foundation flows contain a sample post_init_tcl (PLUG/post_init.tcl) plug-in to do 
# power switch insertion automatically based on the following information:
# ----------------------------------------------------------------------------------------
# set vars(<power_domain>,switchable)         <true | false>
# set vars(<power_domain>,switch_type)        <column | ring>
# set vars(<power_domain>,switch_cell)        <PSO cell name>
# set vars(<power_domain>,input_enable_pin)   <PSO cell input enable pin>
# set vars(<power_domain>,output_enable_pin)  <PSO cell output enable pin>
# set vars(<power_domain>,input_enable_net)   <PSO cell input enable net>
# set vars(<power_domain>,output_enable_net)  <PSO cell output enable net>
# set vars(<power_domain>,switch_instance)    <switchModuleInstance>
# set vars(<power_domain>,top_offset)         <top offset in microns>
# set vars(<power_domain>,bottom_offset)      <bottom offset in microns>
# set vars(<power_domain>,right_offset)       <right offset in microns>
# set vars(<power_domain>,left_offset)        <left offset in microns>
# ----------------------------------------------------------------------------------------
# Below variables are for column based pso implemetation
# ----------------------------------------------------------------------------------------
# set vars(<power_domain>,checker_board)     <true | false>
# set vars(<power_domain>,horizonal_pitch)   <in microns>
# set vars(<power_domain>,column_height)     <Switch cell column height in microns>
# set vars(<power_domain>,skip_rows)         <Number of rows to skip>
# set vars(<power_domain>,back_to_back_chain) <true|false>
# ... Connects the enableNetOut at the top of a column to the enableNetIn at the top of 
# ... the next column, and connects the enableNetOut at the bottom of the column to the 
# ... enableNetIn at the bottom of the next column
# ----------------------------------------------------------------------------------------
# Below variables are for ring based pso implemetation
# ----------------------------------------------------------------------------------------
# set vars(<power_domain>,top_ring)     <1|0>
# set vars(<power_domain>,bottom_ring)  <1|0>
# set vars(<power_domain>,right_ring)   <1|0>
# set vars(<power_domain>,left_ring)    <1|0>
# ... defines which side of the power domain to insert switches:
# ----------------------------------------------------------------------------------------
# set vars(<power_domain>,top_switch_cell)    <pso cell name>
# set vars(<power_domain>,bottom_switch_cell) <pso cell name>
# set vars(<power_domain>,left_switch_cell)   <pso cell name>
# set vars(<power_domain>,right_switch_cell)  <pso cell name>
# ... define pso cell name for each side of the power domain
# ----------------------------------------------------------------------------------------
# set vars(<power_domain>,top_filler_cell)    <filler cell name>
# set vars(<power_domain>,bottom_filler_cell) <filler cell name>
# set vars(<power_domain>,left_filler_cell)   <filler cell name>
# set vars(<power_domain>,right_filler_cell)  <filler cell name>
# set vars(<power_domain>,corner_cell_list)   <corner cell name>
# ... define filler cell name for each side of the power domain
# ----------------------------------------------------------------------------------------
# set vars(<power_domain>,top_switches)       <"<number> -distribute">
# set vars(<power_domain>,bottom_switches)    <"<number> -distribute">
# set vars(<power_domain>,left_switches)      <"<number> -distribute">
# set vars(<power_domain>,right_switches)     <"<number> -distribute">
# ... define the number of switches for each side of the power domain
##########################################################################################
