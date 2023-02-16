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

proc gen_options {file} {

   global names
   global notes
   global default
   global type
   global category

   set names [list]

   set ip [open $file]
   while {[gets $ip temp]>=0} {
      if {[regexp "^#" $temp]} { continue }
      set line [split $temp "\^"]
      puts $line
      set var [lindex $line 0]
      lappend names $var
      set category($var) [lindex $line 1]
      set type($var) [lindex $line 2]
      set default($var) [lindex $line 3]
      set notes($var) [lindex $line 4]
   }
   close $ip

   puts "[llength $names] variables processed"

   set op [open options.tcl w]
   foreach var $names {
      switch -glob $var  {
         "library_sets" {
            puts $op "set vars($var) \[list library_set\]"
         }
         "<library_set*" {
            regsub "<" $var "" temp
            regsub ">" $temp "" svar
            puts $op "set vars($svar) $notes($var)"
         } 
         "rc_corners" {
            puts $op "set vars($var) \[list rc_corner\]"
         }
         "<rc_corner*" {
            regsub "<" $var "" temp
            regsub ">" $temp "" svar
            switch -glob [lindex [split $svar ","] 1] {
               "cap_table" { 
                  puts $op "set vars($svar) $notes($var)"
               }
               "qx_tech_file" { 
                  puts $op "set vars($svar) $notes($var)"
               }
               "default" {
                  if {[regexp "post_route" $svar]} {
                     puts $op "set vars($svar) {1.00 1.00 1.00}"
                  } else {
                     puts $op "set vars($svar) 1.00"
                  }
               }
            }
         } 
         "delay_corners" {
            puts $op "set vars($var) \[list delay_corner\]"
         }
         "<delay_corner*" {
            regsub "<" $var "" temp
            regsub ">" $temp "" var
            switch -glob [lindex [split $var ","] 1] {
               "rc_corner" {
                  puts $op "set vars($var) {rc_corner}"
               }
               "library_set" {
                  puts $op "set vars($var) {library_set}"
               }
               "default" {
                  puts $op "set vars($var) 1.00"
               }
            } 
         }
         "constraint_modes" {
            puts $op "set vars($var) \[list constraint_mode\]"
         }
         "<constraint_mode*" {
            regsub "<" $var "" temp
            regsub ">" $temp "" var
            switch -glob [lindex [split $var ","] 1] {
               "pre_cts_sdc" {
                  puts $op "set vars($var) {sdc_file}"
               }
               "post_cts_sdc" {
                  puts $op "set vars($var) {sdc_file}"
               }
            } 
         }
         "*setup*view*" {
            puts $op "set vars($var) {setup_view}"
            puts $op "set vars(setup_view,delay_corner) {delay_corner}"
            puts $op "set vars(setup_view,constraint_mode) {constraint_mode}"
         }
         "*hold*view*" {
            puts $op "set vars($var) {hold_view}"
            puts $op "set vars(hold_view,delay_corner) {delay_corner}"
            puts $op "set vars(hold_view,constraint_mode) {constraint_mode}"
         }
         "analysis_views" {
            puts $op "set vars(analysis_views) {setup_view hold_view}"
         }
         default {
            if {$type($var) == "enum"} {
               puts $op "set vars($var) $notes($var)"
            } elseif {$type($var) == "list"} {
               regsub "<" $notes($var) "" temp
               regsub ">" $temp "" notes($var)
               regsub "{" $notes($var) "" temp
               regsub "}" $temp "" notes($var)
               puts $op "set vars($var) {list of $notes($var)}"
            } elseif {$category($var) == "plug-in"} {
               puts $op "set vars($var) $notes($var)"
            } elseif {$default($var) != "UNDEFINED"} {
               puts $op "set vars($var) $default($var)"
            } else {
               puts $op "set vars($var) {$type($var)}"
            }
         }
      }
   }
   close $op

}

gen_options $argv
