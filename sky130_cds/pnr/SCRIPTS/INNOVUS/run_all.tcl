#!/usr/bin/env tclsh
# -*-TCL-*-
#
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

source FF/vars.tcl

if {![info exists env(VPATH)]} {
   set env(VPATH) "make"
}

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

#
# Start with all possible steps in the flow that we can execute.  Then find
# the subset of steps that we generated a Tcl control file for
#

set vars(single) true

set found_steps [list]
foreach step $vars(bsteps) {
   set run_file($step) "$vars(script_dir)/INNOVUS/run_$step.tcl"
   if {[file exists $run_file($step)]} {
      lappend found_steps $step
   }
}
#set steps $found_steps

set time 0
set index 0
foreach step $found_steps {
   if {[file exists $env(VPATH)/$step]} {
      if {[file mtime $env(VPATH)/$step] > $time} {
         if {[lindex $found_steps $index] == "signoff"} {
            puts "<FF> STEP signoff COMPLETE ... NOTHING TO DO"
            exit
         } else {
            set start_step [lindex $found_steps [expr $index + 1]]
         }
      }
   } else {
      set start_step $step
      break
   }
   incr index
}

puts "<FF> -----------------------------------------------------"
if {$start_step == $stop_step} {
   puts "<FF> RUNNING STEP $start_step ..."
} else {
   puts "<FF> RUNNING STEP $start_step through $stop_step ..."
}
puts "<FF> -----------------------------------------------------"
sleep 5

#
# Emulate the functionality of the "make" program.  If a file doesn't exist,
# or if it's predecessor step has executed more recently, run the current
# step and update the time/date stamps of the files we track progress with
#

set vars(stop_step) $stop_step

set last_step ""
set vars(single) 1
if {$vars(enable_qor_check)} {
   set check_qor $vars(script_dir)/check_qor.tcl
}
exec mkdir -p make
foreach step $found_steps {
   set vars(step) $step
   puts "<FF> STEP $vars(step) ..."
   set this_semaphore "$env(VPATH)/$step"
   set last_semaphore "$env(VPATH)/$last_step"

   set run_step false
   if {![file exists $this_semaphore]} {
      set run_step true
   } elseif {$last_step != ""} {
      file stat $this_semaphore this_stat
      file stat $last_semaphore last_stat
      if {$this_stat(mtime) < $last_stat(mtime)} {
         set run_step true
      }
   }

   #
   # Check the quality of results from the last step.  If the results aren't
   # as expected, don't proceed to the next step
   #
   if {$vars(enable_qor_check)} {
      if {$step != "init"} {
         set qor [catch {exec $check_qor $last_semaphore} msg]
         if {$qor} {
            puts "<FF> ERROR: QOR RESULT CHECK INDICATES A PROBLEM IN STEP $last_step"
            exit -111
         }
      }
   }

   set last_step $step
   if {!$run_step} {
      continue
   }

   #
   # Source the control file that runs the step.  If it had an error, exit
   # immediately.  Otherwise, update the time/date stamp of the corresponding
   #
   #

   if {[catch {source $run_file($step)} message]} {
      puts $message
      exit -111
   }

   #
   # If there is a QOR check file for this step, execute it and place the
   # result into the make file.  Otherwise just touch the file
   #

   if {$vars(enable_qor_check)} {
      if {[info exists vars($step,qor_tcl]} {
         set qor_file $vars($step,qor_tcl)
         if {[file exists $qor_file]} {
            set qor [catch {exec $qor_file} msg]
            set make_file [open $this_semaphore w]
            puts $make_file "$qor"
            close $make_file
         }
      }
   }
   exec /bin/touch $this_semaphore

   if {$step == $stop_step} {
      exit 
   }
}
