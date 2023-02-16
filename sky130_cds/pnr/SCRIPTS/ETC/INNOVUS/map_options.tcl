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

################################################################################
# Map option names ...
################################################################################
set map(switch_instance)    switchModuleInstance
set map(input_enable_pin)   enablePinIn
set map(output_enable_pin)  enablePinOut
set map(input_enable_net)   enableNetIn
set map(output_enable_net)  enableNetOut
set map(switch_cell)        globalSwitchCellName
set map(top_offset)         topOffset
set map(bottom_offset)      bottomOffset
set map(right_offset)       rightOffset
set map(left_offset)        leftOffset
set map(horizonal_pitch)    horizontalPitch
set map(column_height)      height
set map(skip_rows)          skipRows
set map(top_ring)           topSide
set map(bottom_ring)        bottomSide
set map(right_ring)         rightSide
set map(left_ring)          leftSide
set map(corner_cell_list)   cornerCellList
set map(top_filler_cell)    fillerCellNameTop
set map(bottom_filler_cell) fillerCellNameBottom
set map(left_filler_cell)   fillerCellNameLeft
set map(right_filler_cell)  fillerCellNameRight
set map(top_switch_cell)    switchCellNameTop
set map(bottom_switch_cell) switchCellNameBottom
set map(left_switch_cell)   switchCellNameLeft
set map(right_switch_cell)  switchCellNameRight
set map(top_switches)       topNumSwitch
set map(bottom_switches)    bottomNumSwitch
set map(left_switches)      leftNumSwitch
set map(right_switches)     rightNumSwitch

