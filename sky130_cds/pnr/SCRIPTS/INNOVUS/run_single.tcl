###############################################################################
#                       CADENCE COPYRIGHT NOTICE
#         © 2008-2009 Cadence Design Systems, Inc. All rights reserved.
#------------------------------------------------------------------------------
#
# This Foundation Flow is provided as an example of how to perform specialized
# tasks within Innovus System.
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

global env 

if {![info exists env(VPATH)]} {
   set env(VPATH) "./make"
}

if {![info exists vars]} {
   source FF/vars.tcl
}
foreach file $vars(config_files) {
   source $file
}

set vars(codegen) false

if {[info exists env(FF_START)]} {
   if {[file exists $env(VPATH)/$env(FF_START)]} {
      exec rm $env(VPATH)/$env(FF_START)
   }
   set start_step $env(FF_START)
} else {
   set start_step init
}
if {[info exists env(FF_STOP)]} {
   set stop_step $env(FF_STOP)
} else {
   set stop_step signoff
}

source $vars(script_root)/INNOVUS/procs.tcl

set step_list $vars(bsteps)

set time 0
set index 0
foreach step $step_list {
   if {[file exists $env(VPATH)/$step]} {
      if {[file mtime $env(VPATH)/$step] > $time} {
         if {[lindex $step_list $index] == "signoff"} {
            Puts "<FF> Step signoff complete ... nothing to do"
            exit
         } else { 
            set start_step [lindex $step_list [expr $index + 1]]
         }
      }
   } else {
      set start_step $step
      break
   }
   incr index
}

if {[lsearch $step_list $start_step] > [lsearch $step_list $stop_step]} {
   Puts "<FF> -----------------------------------------------------"
   Puts "<FF> $stop_step step is up to date"
   Puts "<FF> -----------------------------------------------------"
   exit
}
Puts "<FF> -----------------------------------------------------"
if {$start_step == $stop_step} {
   Puts "<FF> RUNNING STEP $start_step ..."
} else { 
   Puts "<FF> RUNNING STEP $start_step through $stop_step ..."
}
Puts "<FF> -----------------------------------------------------"
sleep 5

if {[info exists vars(script_root)]} {
   source $vars(script_root)/INNOVUS/procs.tcl
   source $vars(script_root)/ETC/utils.tcl
#   source $vars(script_root)/ETC/INNOVUS/utils.tcl
} else  {
   Puts "<FF> ERROR: vars(script_root) not defined ... please define your in setup.tcl"
   exit 1
}

set found 0
set index 0
set proc_list [list] 
foreach step $step_list {
   if {$step == $start_step} {
      set vars(step) $step
      eval "::FF_EDI::initialize_flow"
      if {$step == "init"} {
         eval ::FF_EDI::run_init 0
      } else {
         set next_step [lindex $step_list [expr $index-1]]
         if {!$vars(fix_hold)} {
            switch $step {
               "route" { set next_step "postcts" }
               "postroute_si" { set next_step "postroute" }
            }
         }
         eval "::FF_EDI::load_design 0 $next_step"
         eval "::FF_EDI::run_$step 0"
      }
      eval "::FF_EDI::save_results 0 $step"
      if {$step == $stop_step} {
         Puts "<FF> =============================================="
         Puts "<FF>          FOUNDATION FLOW COMPLETE"
         Puts "<FF> =============================================="
         exit
      }
      set found 1
   } else {
      if {$found} {
         eval "::FF_EDI::run_$step 0"
         eval "::FF_EDI::save_results 0 $step"
         if {$step == $stop_step} {
            Puts "<FF> =============================================="
            Puts "<FF>          FOUNDATION FLOW COMPLETE"
            Puts "<FF> =============================================="
            set found 0
         } 
      } 
   }
   incr index   
}

exit
