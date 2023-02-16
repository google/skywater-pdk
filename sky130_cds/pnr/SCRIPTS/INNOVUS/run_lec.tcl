//##############################################################################
//                       CADENCE COPYRIGHT NOTICE
//         © 2008-2009 Cadence Design Systems, Inc. All rights reserved.
//------------------------------------------------------------------------------
//
// This Foundation Flow is provided as an example of how to perform specialized
// tasks within Innovus System.
//
// This work may not be copied, re-published, uploaded, or distributed in any way,
// in any medium, whether in whole or in part, without prior written permission
// from Cadence. Notwithstanding any restrictions herein, subject to compliance
// with the terms and conditions of the Cadence software license agreement under
// which this material was provided, this material may be copied and internally
// distributed solely for internal purposes for use with Cadence tools.
//
// This work is Cadence intellectual property and may under no circumstances be
// given to third parties, neither in original nor in modified versions, without
// explicit written permission from Cadence. The information contained herein is
// the proprietary and confidential information of Cadence or its licensors, and
// is supplied subject to, and may be used only by Cadence's current customers
// in accordance with, a previously executed license agreement between Cadence
// and its customer.
//
//------------------------------------------------------------------------------
// THIS MATERIAL IS PROVIDED BY CADENCE "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
// IN NO EVENT SHALL CADENCE BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL
// OR CONSEQUENTIAL DAMAGES HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT  (INCLUDING NEGLIGENCE OR
// OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS  MATERIAL, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//##############################################################################

vpxmode
set dofile abort exit
set undefined cell black_box -noascend -both
tclmode
// setup variables 
global vars
proc Puts {args} {
	puts $args
}
//##############################################################################
// Source script to define design specific variables
//##############################################################################
if {[info exists env(FF_SETUP_PATH)]} {
   if {[file exists $env(FF_SETUP_PATH)]} {
      Puts "<FF> LOADING $env(FF_SETUP_PATH)/setup.tcl ..."
      catch {source $env(FF_SETUP_PATH)/setup.tcl}
   } else {
      Puts "<FF> ERROR: $env(FF_SETUP_PATH)/setup.tcl does not exist"
      exit
   }
} else {
   if {[file exists setup.tcl]} {
      catch {source setup.tcl}
   } else {
      Puts "<FF> ERROR: setup.tcl does not exist"
      exit
   }
}

//Define the netlist to be verify
if {[info exists env(STEP)] && [file exists DBS/$env(STEP).enc.dat/$vars(design).v.gz]} {
	set revisedNetlist DBS/$env(STEP).enc.dat/$vars(design).v.gz
} else {
   Puts "<FF> Failed to find netlist  DBS/$env(STEP).enc.dat/$vars(design).v.gz"
}

set rc [catch {source $vars(script_root)/ETC/utils.tcl}]
if {[info exists vars(threads)]} {
	vpx set compare option -threads $vars(threads)
}


// read Liberty cell definitions
set libSet $vars($vars($vars(default_setup_view),delay_corner),library_set)
vpx read library -statetable -both -liberty $vars(${libSet},timing)

// read reference netlist
vpx read design -verilog -sensitive -golden $vars(netlist)

// read post-implementation netlist
vpx read design -verilog -sensitive -revised $revisedNetlist

//set top level
vpx set root module $vars(design) -both

ff_source_plug pre_lec_check_tcl

vpxmode
report design data
report black box

set mapping method -name first
set flatten model -seq_constant -seq_constant_x_to 0
set flatten model -nodff_to_dlat_zero -nodff_to_dlat_feedback
set flatten model -gated_clock

set system mode lec
add compare point -all
compare -gate_to_gate
usage
//   vpx report compare data
report compare data -class nonequivalent -class abort -class notcompared
report verification -verbose
report statistics

tclmode
set points_count [get_compare_points -count]
set diff_count [get_compare_points -diff -count]
set abort_count [get_compare_points -abort -count]
set unknown_count [get_compare_points -unknown -count]
if {$points_count == 0} {
    puts "---------------------------------"
    puts "ERROR: No compare points detected"
    puts "---------------------------------"
}
if {$diff_count > 0} {
    puts "------------------------------------"
    puts "ERROR: Different Key Points detected"
    puts "------------------------------------"
}
if {$abort_count > 0} {
    puts "-----------------------------"
    puts "ERROR: Abort Points detected "
    puts "-----------------------------"
}
if {$unknown_count > 0} {
    puts "----------------------------------"
    puts "ERROR: Unknown Key Points detected"
    puts "----------------------------------"
}
puts "No of compare points = $points_count"
puts "No of diff points    = $diff_count"
puts "No of abort points   = $abort_count"
puts "No of unknown points = $unknown_count"
exit 0
