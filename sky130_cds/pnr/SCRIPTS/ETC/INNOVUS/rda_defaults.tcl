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
if {[lindex [split $vars(version) "."]  0] > 10} {
   if {[lindex [split $vars(version) "."]  0] < 15} {
      set rda_defaults(assign_buffer) {1}
   }
   set rda_defaults(import_mode) {-treatUndefinedCellAsBbox 0 -keepEmptyModule 1 -useLefDef56 1 }
   set rda_defaults(uniquify_netlist) {1}
} else {
   set rda_defaults(assign_buffer) {1}
   set rda_defaults(shr_scale) {1.0}
   set rda_defaults(delay_limit) {1000}
   set rda_defaults(default_net_delay) {1000.0ps}
   set rda_defaults(default_net_load) {0.5pf}
   set rda_defaults(default_slew) {0ps}
   set rda_defaults(flip_first_row) {1}
   set rda_defaults(core_control) {aspect}
   set rda_defaults(import_mode) {-treatUndefinedCellAsBbox 0 -keepEmptyModule 1 -useLefDef56 1 }
   set rda_defaults(core_util) {0.7}
   if {[info exists vars(netlist_type)]} {
      set rda_defaults(netlist_type) $vars(netlist_type)
   } else {
      set rda_defaults(netlist_type) Verilog
   }
   set rda_defaults(uniquify_netlist) {1}
   set rda_defaults(rtl_list) ""
   set rda_defaults(ilm_dir) ""
   set rda_defaults(ilm_list) ""
   set rda_defaults(ilm_spef) ""
   set rda_defaults(set_top_cell) {0}
   set rda_defaults(celllib) ""
   set rda_defaults(io_lib) ""
   set rda_defaults(area_io_lib) ""
   set rda_defaults(blk_lib) ""
   set rda_defaults(kbox_lib) ""
   set rda_defaults(oa2lefversion) {}
   set rda_defaults(view_definition_file) ""
   set rda_defaults(smod_def) ""
   set rda_defaults(smod_data) ""
   set rda_defaults(locv_lib) ""
   set rda_defaults(data_path) ""
   set rda_defaults(tech_file) ""
   set rda_defaults(io_file) ""
   set rda_defaults(latency_file) ""
   set rda_defaults(scheduling_file) ""
   set rda_defaults(buf_footprint) {}
   set rda_defaults(del_footprint) {}
   set rda_defaults(inv_footprint) {}
   set rda_defaults(cts_cell_footprint) {}
   set rda_defaults(cts_cell_list) {}
   set rda_defaults(aspect_ratio) {1.0}
   set rda_defaults(core_height) {}
   set rda_defaults(core_width) {}
   set rda_defaults(core_to_left) {}
   set rda_defaults(core_to_right) {}
   set rda_defaults(core_to_top) {}
   set rda_defaults(core_to_bottom) {}
   set rda_defaults(max_io_height) {0}
   set rda_defaults(row_height) {}
   set rda_defaults(hor_track_half_pitch) {0}
   set rda_defaults(ver_track_half_pitch) {1}
   set rda_defaults(io_orientation) {R0}
   set rda_defaults(center_origin) {0}
   set rda_defaults(vertical_rows) {0}
   set rda_defaults(exclude_nets) ""
   set rda_defaults(time_unit) {none}
   set rda_defaults(cap_unit) {}
   set rda_defaults(oa_ref_lib) ""
   set rda_defaults(oa_abstract_name) {}
   set rda_defaults(oa_layout_name) {}
   set rda_defaults(oa_design_lib) {}
   set rda_defaults(oa_design_cell) {}
   set rda_defaults(oa_design_view) {}
   set rda_defaults(signalstorm_lib) ""
   set rda_defaults(echo_file,min) ""
   set rda_defaults(echo_file,max) ""
   set rda_defaults(echo_file) ""
   set rda_defaults(xtalk_twf_file) ""
   set rda_defaults(double_back) {1}
   set rda_defaults(gen_footprint) {0}
   set rda_defaults(pwrnet) ""
   set rda_defaults(gndnet) ""
   set rda_defaults(gds_files) ""
}
