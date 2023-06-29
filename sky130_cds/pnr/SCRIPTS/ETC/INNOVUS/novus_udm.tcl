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
if {[info exists vars(netlist)]} {
   set init(verilog)                  $vars(netlist)
}
if {[info exists vars(set_top_module)]} {
   set init(design_settop)            $vars(set_top_module)
}
if {[info exists vars(design)]} {
   set init(top_cell)                 $vars(design)
#   set init(topcell)                  $vars(design)
}
#set init(netlist_type)                $vars(netlist_type)
if {[info exists vars(oa_design_lib)]} {
   set init(oa_lib)                   $vars(oa_design_lib)
}
if {[info exists vars(oa_design_cell)]} {
   set init(oa_cell)                  $vars(oa_design_cell)
}
if {[info exists vars(oa_design_view)]} {
   set init(oa_view)                  $vars(oa_design_view)
}
if {[info exists vars(oa_ref_lib)]} {
   set init(oa_ref_lib)               $vars(oa_ref_lib)
}
if {[info exists vars(oa_abstract_name)]} {
   set init(abstract_view)            $vars(oa_abstract_name)
}
if {[info exists vars(oa_abstract_view)]} {
   set init(abstract_view)            $vars(oa_abstract_view)
}
if {[info exists vars(oa_layout_name)]} {
   set init(layout_view)              $vars(oa_layout_name)
}
if {[info exists vars(oa_layout_view)]} {
   set init(layout_view)              $vars(oa_layout_view)
}
if {[info exists vars(power_nets)]} {
   set init(pwr_net)                  $vars(power_nets)
}
if {[info exists vars(ground_nets)]} {
   set init(gnd_net)                  $vars(ground_nets)
}
set init(mmmc_file)                   $vars(script_dir)/view_definition.tcl
if {[info exists vars(cpf_file)]} {
   set init(cpf_file)                 $vars(cpf_file)
}
if {[info exists vars(io_file)]} {
   set init(io_file)                  $vars(io_file)
}
if {[info exists vars(lef_files)] && $vars(lef_files) != "NONE"} {
   set init(lef_file)                 $vars(lef_files)
}
if {[info exists vars(cap_unit)]} {
   set init(cap_unit)                 $vars(cap_unit)
}
if {[info exists vars(time_unit)]} {
   set init(time_unit)                $vars(time_unit)
}
if {[lindex [split $vars(version) "."]  0] <= 14} {
   if {[info exists vars(assign_buffer)]} {
      if {($vars(assign_buffer) != 1) && ([string tolower $vars(assign_buffer)] != "true") && \
          ([string tolower $vars(assign_buffer)] != "false") && ($vars(assign_buffer) != 0)} {
         if {[llength $vars(assign_buffer)] == 1} {
               set init(assign_buffer)            "1 -buffer $vars(assign_buffer)"
         } else {
            set init(assign_buffer)            $vars(assign_buffer)
         }
      } else {
            set init(assign_buffer)            $vars(assign_buffer)
      }
   }
}

if {[info exists vars(buf_footprint)]} {
   set opt(buf_footprint)              $vars(buf_footprint)
}
if {[info exists vars(inv_footprint)]} {
   set opt(inv_footprint)              $vars(inv_footprint)
}
if {[info exists vars(del_footprint)]} {
   set opt(delay_footprint)            $vars(del_footprint)
}
if {[info exists vars(cts_cell_footprint)]} {
   set cts(cts_cell_footprint)         $vars(cts_cell_footprint)
}
if {[info exists vars(cts_cell_list)]} {
   set cts(cell_list)                  $vars(cts_cell_list)
}
if {[info exists vars(delay_limit)]} {
   set delaycal(delay_limit)                 $vars(delay_limit)
}
if {[info exists vars(default_net_delay)]} {
   set delaycal(net_delay)                   $vars(default_net_delay)
}
if {[info exists vars(default_net_load)]} {
   set delaycal(net_load)                    $vars(default_net_load)
}
if {[info exists vars(default_slew)]} {
   set delaycal(in_tran_delay)               $vars(default_slew)
}
if {[info exists vars(exclude_nets)]} {
   set delaycal(exclude_net) $vars(exclude_nets)
}
if {[info exists vars(delay_limit)]} {
   set delaycal(use_default_delay_limit) $vars(delay_limit)
}
if {[info exists vars(default_net_delay)]} {
   set delaycal(default_net_delay) $vars(default_net_delay)
}
if {[info exists vars(default_net_load)]} {
   set delaycal(default_net_load) $vars(default_net_load)
}
if {[info exists vars(input_transition_delay)]} {
   set delaycal(input_transition_delay) $vars(input_transition_delay)
}

if {[info exists vars(shrink_factor)]} {
   set extract(shrink_factor) $vars(shrink_factor)
}

# init_oa_search_lib

# conf variables?
#rda_Input(ui_ilmdir)	Specifies the directory from which to read the ILM files.	
#rda_Input(ui_fmdir)	Specified the flex model dir	
#rda_Input(ui_conf_oa_oa2lefversion)	For native oa2lef translator.	
#keep_files	keeps temp files	
#RTL Compiler Related (in use)		
#set rda_Input(ui_netlisttype) {RTL}		
#rda_Input(ui_rtl_verilog_list) 		
#set rda_Input(ui_rtl_verilog_version)		
#set rda_Input(ui_rtl_verilog_case) {orig}		
#set rda_Input(ui_rtl_vhdl_list) {}		
#set rda_Input(ui_rtl_vhdl_version)		
#set rda_Input(ui_rtl_vhdl_case) {orig}		
#rda_Input(ui_rtllist)		
#rda_Input(ui_rtl_path)		
