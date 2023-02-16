#!/usr/bin/env tclsh
# -*-TCL-*-

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

############################################################################
# Foundation Flow Code Generator
# Version : 17.10-p003_1
############################################################################# 

##############################################################################
# Parse the arguments passed in to the script.  These set up the environment #
# for the rest of the system                                                 #
##############################################################################

if {([file tail [info nameofexecutable]] == "encounter") || ([file tail [info nameofexecutable]] == "velocity") ||\
    ([file tail [info nameofexecutable]] == "genus") || ([file tail [info nameofexecutable]] == "innovus")} {
   puts "<FF> ==================================================="
   puts "<FF> Loading the Foundation Flow Code Generator"
   puts "<FF> Version : 17.10-p003_1"
#   puts "<FF> Available Procedures:"
   puts "<FF> ==================================================="
   if {[info exists vars(script_root)]} { 
     set default_script_path  $vars(script_root)
     set vars(execute_string) [format "%s %s" $vars(script_root)/gen_edi_flow.tcl $argv]
   } else {
      if {[info exists vars(script_path)]} {
         set vars(script_root)  $vars(script_path)
         set default_script_path  $vars(script_path)
         set vars(execute_string) [format "%s %s" $vars(script_path)/gen_edi_flow.tcl $argv]
      } else { 
#      puts "<FF> Variable vars(script_root) required for Makefile generation ..."
         puts "<FF> Variable vars(script_root) not defined ... setting to [file dirname [file dirname [file dirname [file dirname [file dirname [info nameofexecutable]]]]]]/share/FoundationFlows/SCRIPTS"
         set default_script_path [file dirname [file dirname [file dirname [file dirname [file dirname [info nameofexecutable]]]]]]/share/FoundationFlows/SCRIPTS
         set vars(script_root) $default_script_path
      }
   }
} else {
   set vars(execute_string) [format "%s %s %s" [info nameofexecutable] [file normalize $argv0] $argv]
   
   set normalized [file normalize $argv0]
   if {[file isdirectory $normalized]} {
      set default_script_path $normalized
   } elseif {[file isdirectory [file dirname $normalized]]} {
      set default_script_path [file dirname $normalized]
   }
   
}

set vars(script_path) $default_script_path
#puts $vars(script_path)
#
# Check the paths to make sure that the files that we need actually exist
#
if {![file exists $vars(script_path)/INNOVUS/procs.tcl]} {
   puts [format $FFMM::missingFiles $vars(script_path)/INNOVUS/procs.tcl]
   exit -1
}
if {![file exists $vars(script_path)/ETC/utils.tcl]} {
   puts [format $FFMM::missingFiles $vars(script_path)/ETC/utils.tcl]
   exit -1
}

#
# Source the other Tcl files to execute the flow.  Then do so
#
#puts "<FF> Sourcing $vars(script_path)/INNOVUS/procs.tcl"
source "$vars(script_path)/INNOVUS/procs.tcl"
if {[file exists $vars(script_path)/RC/procs.tcl]} {
#   puts "<FF> Sourcing $vars(script_path)/RC/procs.tcl"
   source "$vars(script_path)/RC/procs.tcl"
}
#puts "<FF> Sourcing $vars(script_path)/INNOVUS/utils.tcl"
source "$vars(script_path)/ETC/utils.tcl"

if {([file tail [info nameofexecutable]] == "tclsh")} {
   set command "FF::gen_flow $argv"
   eval $command
   exit 0
}
