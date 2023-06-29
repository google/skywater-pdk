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

set vars(step) debug

###############################################################################
# Source script to define design specific variables
###############################################################################
if {[info exists env(FF_SETUP_PATH)]} {
   if {[file exists $env(FF_SETUP_PATH)]} {
      Puts "<FF> LOADING $env(FF_SETUP_PATH)/setup.tcl ..."
      if { [ catch { source $env(FF_SETUP_PATH)/setup.tcl} setup_error ] } {
         Puts "<FF> ============= SETUP ERROR =================="
         Puts "<FF> $errorInfo"
         Puts "<FF> $setup_error"
         Puts "<FF> =============================================="
         set return_code 99
         exit $return_code
      }
   } else {
      Puts "<FF> ERROR: $env(FF_SETUP_PATH)/setup.tcl does not exist"
      exit
   }
} else {
   if {[file exists setup.tcl]} {
      Puts "<FF> LOADING setup.tcl ..."
      if { [ catch { source setup.tcl} setup_error ] } {
         Puts "<FF> ============= SETUP ERROR =================="
         Puts "<FF> $errorInfo"
         Puts "<FF> $setup_error"
         Puts "<FF> =============================================="
         set return_code 99
         exit $return_code
      }
   } else {
      Puts "<FF> ERROR: setup.tcl does not exist"
      exit
   }
}

source $vars(script_root)/EDI/procs.tcl
source $vars(script_root)/ETC/utils.tcl

::FF_EDI::initialize_flow

if {[info exists env(STEP)]} {
   ::FF_EDI::load_design 0 $env(STEP)
}

###############################################################################
# Load "always source" plug-in script
###############################################################################
::FF::source_plug always_source_tcl

win
