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

package provide foundation_flow 1.0

namespace eval FFMM:: {

   set validModes [list "flat" "hier" "top_down" "bottom_up" "user"]

   set missingFiles "<FF> ERROR: Could not find Foundation Flow script files in directory \"%s\""

   set missingSetupFile "<FF> ERROR: Could not find setup.tcl in directory \"%s\""

   set missingRC "<FF> ERROR: Could not find 'rc' executable"

   set noMode "<FF> ERROR: \"-m\" option specified without a runtime mode"

   set noFlat "<FF> ERROR: \"-f\" option specified without a valid option"

   set noVersion "<FF> ERROR: \"-v\" option specified without a valid option"

   set noPath "<FF> ERROR: \"-d\" option specified without a directory path"

   set noStyle "<FF> ERROR: \"-y\" option specified without a style option \[date|increment\]"

   set noRundir "<FF> ERROR: \"-u\" option specified without a directory path"

   set noSetupPath "<FF> ERROR: \"-s\" option specified without a directory path"

   set noAppletPath "<FF> ERROR: \"-a\" option specified without a directory path"

   set nosynth_flow "<FF> WARNING: \"-r\" option specified without a synthesis flow"

   set noSuchPath "<FF> ERROR: Directory path \"%s\" not found."

   set unknownMode "<FF> ERROR: Unknown runtime mode specified \"%s\" "

   set unknownOption "<FF> ERROR: Unrecognized option \"%s\" "

   
   set usage "
Usage: tclsh <path_to>/SCRIPTS/gen_flow.tcl <options> step ?step? ... ?step?
   The \"step\" is the portion of the flow that you want to execute.  To find
   the valid list of steps for a given mode, simply omit the step from the
   command-line invocation.  You can also specify step as either of the two
   forms:
       a-b : Execute all steps between step a and b, inclusive
       a-  : Execute all steps in the flow from step a, inclusive
   Obviously, \"a\" and \"b\" should be valid steps for the specific mode.

   Options may be one or more of the following:
     -h | --help     : Print this message
     -H | --Help     : Print step help
     -m | --mode     : Set the script mode.  The default is \"flat\".
                       Valid modes are: $validModes
     -d | --dir      : Output directory for generated scripts.
     -f | --flat     : Level of unrolling ... full, partial, none
     -n | --nomake   : Skip Makefile generation
     -y | --style    : Rundir naming style \[date|increment\]
     -r | --rtl      : Enable RTL Script Generation
     -N | --Novus  : Enable novus_ui flowkit generation
     -s | --setup    : Provide the directory containing the setup.tcl setup file
     -u | --rundir   : Directory to execute the flow
                       requried to run the Foundation Flow.  
     -v | --version  : Target version (17.1.0, 16.2.0, 16.1.0, 15.2.0, 15.1.0, ...)
     -V | --Verbose  : Verbose mode

    Examples:
    ---------

    tclsh SCRIPTS/gen_innovus_flow.tcl all

    tclsh SCRIPTS/gen_innovus_flow.tcl -m top_down all

    tclsh SCRIPTS/gen_innovus_flow.tcl -d prects_scripts init-prects

    tclsh SCRIPTS/gen_innovus_flow.tcl -u work/run -y date -r default_synthesis_flow_3step all

"
}

namespace eval FF:: {
   variable valid_versions {
      17.1.0
      16.2.0 16.1.0
      15.2.0 15.1.0
      14.2.0 14.1.0 
      13.2.0 13.1.0
      12.1.0
      11.1.3 11.1.2 11.1.1 11.1.0
      10.1.3 10.1.2 10.1.1 10.1.0
      9.1.3 9.1.2
   }

   proc wrap_command {tag command} {

      global vars
      global env
      global errors

#      if {$vars(debug)} {
#         puts "<FF> Wrapping command: $command in step $vars(step) ..."
#      }

      if {![info exists vars(tags,verbose)]} {
         set verbose FALSE
      }  else {
         set verbose $vars(tags,verbose)
      }

      if {![info exists vars(tags,verbosity_level)]} {
         set verbosity_level LOW
      } else {
         switch [string toupper $vars(tags,verbosity_level)] { 
            "LOW" {
               set verbosity_level LOW
            }
            "HIGH" {
               set verbosity_level HIGH
            }
            default {
               set verbosity_level LOW
            }
         }
      }

      if {[info exists vars($tag,pre_tcl)] || \
          [info exists vars($tag,post_tcl)] || \
          [info exists vars($tag,skip)] || \
          [info exists vars($tag,replace_tcl)]} {
         if {![info exists vars(tagged)]} {
            set vars(tagged) [list]
         }
      }

      if {$verbosity_level == "HIGH"} {
         set commands "# <BEGIN TAG> $tag\n"
      } else {
         set commands ""
      }
#      set commands ""
      if {[info exists vars($tag,skip)] && $vars($tag,skip)} {
         lappend vars(tagged) $tag,skip
         regsub  -all "\\\n" "\n\n$command\n" "\n# " skip
#         append skip "\n"
         if {$verbose} {
            append commands "\n# <begin tag $tag,skip>"
         } 
         append commands $skip
         if {$verbose} {
            append commands "<end tag $tag,skip>\n\n"
         }
         append commands "\n"
         if {$verbose} {
            return $commands
         } else {
            return
         }
      }

      if {[info exists vars($tag,pre_tcl)]} {
         if {[file exists $vars($tag,pre_tcl)]} {
            lappend vars(tagged) $tag,pre_tcl
            if {$vars(flat) == "full"} {
               set ip [open $vars($tag,pre_tcl) r]
               if {$verbose} {
                  append commands "\n# <begin tag $tag,pre_tcl>\n"
               } 
               while {[gets $ip line]>=0} {
                  append commands "$line\n"
               }
               close $ip
               if {$verbose} {
                  append commands "# <end tag $tag,pre_tcl>\n\n"
               } 
            } else {
               append commands "source $vars($tag,pre_tcl)\n"
            }
         } else {
            puts "<FF> ERROR: $tag pre_tcl file ($vars($tag,pre_tcl)) not found"
            set errors($vars(error_count)) "$tag pre_tcl file ($vars($tag,pre_tcl)) not found"
            incr vars(error_count)
            if {$verbose} {
               append commands "# <end tag $tag,pre_tcl>\n\n"
            }
         }
      }
      if {[info exists vars($tag,replace_tcl)]} {
         if {[file exists $vars($tag,replace_tcl)]} {
            lappend vars(tagged) $tag,replace_tcl
            set ip [open $vars($tag,replace_tcl) r]
            if {$verbose} {
               append commands "\n# <begin tag $tag,replace_tcl>\n"
            } 
            while {[gets $ip line]>=0} {
               append commands "$line\n"
            }
            close $ip
         } else {
            puts "<FF> ERROR: $tag replace_tcl file ($vars($tag,replace_tcl)) not found"
            set errors($vars(error_count)) "$tag replace_tcl file ($vars($tag,replace_tcl)) not found"
            incr vars(error_count)
         }
         if {$verbose} {
            append commands "# <end tag $tag,replace_tcl>\n\n"
         }
      } else {
         # Insert original command here
         append commands $command
      }

      if {[info exists vars($tag,post_tcl)]} {
         if {[file exists $vars($tag,post_tcl)]} {
            lappend vars(tagged) $tag,post_tcl
            if {$verbose} {
               append commands "\n# <begin tag $tag,post_tcl>\n"
            } 
            if {$vars(flat) == "full"} {
               set ip [open $vars($tag,post_tcl) r]
               while {[gets $ip line]>=0} {
                  append commands "$line\n"
               }
               close $ip
#               if {$verbose} {
#                  append commands "#<<<\n"
#               } 
            } else {
               append commands "source $vars($tag,post_tcl)\n"
            }
         } else {
            puts "<FF> ERROR: $tag post_tcl file ($vars($tag,post_tcl)) not found"
            set errors($vars(error_count)) "$tag post_tcl file ($vars($tag,post_tcl)) not found"
            incr vars(error_count)
         }
         if {$verbose} {
            append commands "# <end tag $tag,post_tcl>\n\n"
         }
      }
      if {$verbosity_level == "HIGH"} {
         append commands "\n# <END TAG> $tag\n"
      }

      return $commands
   }

   proc get_line_match {pattern file} {

      set ip [open $file r]

      while {[gets $ip line]>=0} {
         if {[regexp "$pattern" $line]>0} {
           set match $line
         }
      }

     return $match
   }

   proc singular {val {false "s"} {true ""}} {
     if {$val==1} { return $true } else { return $false }
   }

   proc size {val {suffix "byte"}} {
     set level 0
     set prefixes [list "" kilo mega giga tera peta]
     while {$val>1024} {
       set val [expr $val/1024.0]
       incr level
     }
     set val [expr int($val+0.5)]
     return "$val [lindex $prefixes $level]$suffix[singular $val]"
   }

   proc system_info {} {

      global vars

      set uname [exec uname]

      if {[lsearch "Linux" $uname] != -1} {

         set inFile "$vars(script_root)/ETC/status.dat"

         if {![file exists $inFile]} {
             return
         }

         set upId [open "/proc/uptime" r]
         set info(uptime) [lindex [split [gets $upId] .] 0]
         close $upId

         foreach {var val} {mon 2592000 wks 604800 day 86400 hrs 3600 min 60 sec 1} {
           set info(uptime.${var}) [expr $info(uptime)/${val}]
           set info(uptime) [expr $info(uptime)-($info(uptime.${var})*${val})]
         }

         set info(host.fqdn) [info hostname]
         set info(host.name) [lindex [split $info(host.fqdn) .] 0]
         set info(host.domain) [string range $info(host.fqdn) [expr [string length $info(host.name)]+1] end]
         set info(host.os) $::tcl_platform(os)
         set info(host.osver) $::tcl_platform(osVersion)
         set info(host.machine) $::tcl_platform(machine)

         if {$info(host.os)=="Linux"} {
           if {[file exists /etc/slackware-version]} { set info(host.distribution) "Slackware" }
           if {[file exists /etc/redhat-release]} { set info(host.distribution) "RedHat" }
           if {[file exists /etc/mandrake-release]} { set info(host.distribution) "Mandrake" }
           if {![info exists info(host.distribution)]} { set info(host.distribution) "Unknown" }
         } else {
           return
         }

         set cpuId [open "/proc/cpuinfo" r]
         set info(cpu.total) 0
         set info(cpu.cpucores) 1
         while {![eof $cpuId]} {
           gets $cpuId ln
           set ln [split $ln :]
           set item [string trim [lindex $ln 0]]
           set value [string trim [lindex $ln 1]]
           set info(cpu.[lindex $item 0][lindex $item 1]) $value
           if {[lindex $item 0] == "processor"} {incr info(cpu.total)}
         }
         close $cpuId

         set memId [open "/proc/meminfo" r]
         set info(mem.free) 0
         while {![eof $memId]} {
           gets $memId ln
           set ln [split $ln :]
           set item [string trim [lindex $ln 0]]
           catch { set value [expr [string trim [lindex [lindex $ln 1] 0]]*1024] }
           switch -- "$item" {
             MemTotal { set info(mem.total) $value }
             SwapTotal { set info(mem.swap.total) $value }
             SwapFree { set info(mem.swap.free) $value }
             MemFree { incr info(mem.free) $value }
             Cached { incr info(mem.free) $value }
             Buffers { incr info(mem.free) $value }
           }
         }

         set parseId [open $inFile r]
         while 1 {
           gets $parseId ln
           if {[eof $parseId]} { break }
           catch { puts [subst $ln] } err
         }
         close $parseId
      }
   }

   ############################################################################
   # This routine iterates over variables that maintain lists of files.  If
   # any element of the list is a wildcard, that entry is replaced with the
   # Tcl command that will expand the name at runtime
   ############################################################################

   proc process_file_lists {} {

      global vars

      if {![info exists vars(globbed)]} {
         set vars(globbed) false
      }
      if {$vars(globbed)} {
         return
      }
      set vars(globbed) true

      if {[regexp "^11" $vars(version)]} {
         return
      }
      # BCL: Removed def_files from this list
      set var_indices [list "cts_spec" "lef_files" \
                            "timing" "si" "ecsm" "cts_sdc"]

      # BCL: Add def_files to list only if it doesn't have [subst] in the name (other wise we need to keep [subst... unexpanded)
      if {[info exists vars(def_files)] && ![regexp {\[subst \$vars} $vars(def_files)]} {lappend var_indices def_files}

      foreach index $var_indices {
         set all_names [array names vars -glob "*$index"]
         foreach name $all_names {
            set expanded_files ""
            # BCL: Added subst around final variable to resolve vars(rundir) references
            foreach file [subst $vars($name)] {
               if {([string first "*" $file] != -1) ||
                   ([string first "?" $file] != -1)} {
                  if {![catch {set files [glob $file]}]} {
                     lappend expanded_files $files
                  }
               } else {
                  lappend expanded_files $file
               }
            }
            set vars($name) $expanded_files
         }
      }
   }

   proc get_required_procs {file} {
      #
      # Given a list of required procedures, return the lines that represent
      # those procedures from the utils.tcl file
      #

      global vars
      global errors

      #
      # Read the file and gather all of the contents
      #

      set all_lines ""
      set length 0
      set ip [open $file]
      while {[gets $ip line]>=0} {
         if {[info exists vars(novus)] && $vars(novus)} {
            set utils_lines($length) [regsub "Puts" $line "puts"]
         } else {
            set utils_lines($length) $line
         }
         incr length
      }
      close $ip

      #
      # Iterate across each line and pull out relevant procedures
      #

      set lines ""
      set i 0
      while {$i < $length} {
         set line $utils_lines($i)
         foreach proc $vars(required_procs) {
            if {[regexp "proc $proc" $line] > 0} {
               append lines " $line\n"
               incr i
               while {$i < $length} {
                  set line $utils_lines($i)
                  if {[regexp "proc " $line] > 0} {
                     incr i -1
                     break
                  }
                  if {![regexp "^#" [string trimleft $line] ] && ($i != [expr $length-1])} {
                     append lines "$line\n"
                  }
                  incr i
               }
               break
            }
         }
         incr i
      }

      set lines [string trimright $lines]
      return "$lines\n"
   }


   proc source_plug {plugin {abort 1}} {

      global vars
      global env
      global warnings
      global plugin_error
      global errorInfo
      global return_code

      # Added for ETS/EPS
      if {![info exists vars(flat)]} {
         set vars(flat) full
      }

      if {[info exists vars(codegen)] && !$vars(codegen)} {
         set vars(flat) full
      }
  
      set flat $vars(flat)

      if {$vars(generate_flow_steps)} {
         #set vars(flat) full
      }

      if {[info exists vars(verbose)] && $vars(verbose)} {
         set verbose true
      } else {
         set verbose false
      }

      set commands "puts \"<FF> Plugin -> $plugin\"\n"
      set no_comments ""

      if {[info exists vars($plugin)]} {
         if {![info exists vars(plugins)]} {
            set vars(plugins) [list]
         }
         if {[lsearch $vars(plugins) $plugin] == -1} {
            set suffix [lindex [split $plugin ","] 1]
            if {($suffix != "derate_tcl") && ($suffix != "scale_tcl")} {
               lappend vars(plugins) $plugin
            }
         }
         set found 0 
         set plug_list []
         foreach plug_file $vars($plugin) {
            if {[file exists $plug_file]} {
               set found 1 
               lappend plug_list $plug_file
               continue 
            } elseif {[file exists $vars(plug_dir)/$plug_file]} {
                  set found 1 
#                  lappend plug_list $plug_file
                   lappend plug_list $vars(plug_dir)/$plug_file
                  continue 
            } else {
               if {[file exists $vars(cwd)/$plug_file]} {
                  set found 1 
                  lappend plug_list $vars(cwd)/$plug_file
                  continue 
               }
            }
         }
         if {!$found} {
            if {![info exists vars(missing_plugins)]} {
               set vars(missing_plugins) [list]
            }
            if {[lsearch $vars(missing_plugins) $plugin] == -1} {
               lappend vars(missing_plugins) $plugin
               set warnings($vars(warning_count)) "Plug-in $plugin defined but file(s) not found"
               incr vars(warning_count)
            }
         }
         if {$vars(flat) == "partial"} {
            foreach plug_file $plug_file {
               if {[file exists $plug_file]} {
                  append commands "puts \"<FF> LOADING \'$plug_file\' PLUG-IN FILE(s) \"\n"
                  append commands "if { \[ catch { source $plug_file } plugin_error \] } {\n"
                  append commands "   puts \"<FF> ============= PLUG-IN ERROR ==================\"\n"
                  append commands "   puts \"<FF> \$errorInfo\"\n"
                  append commands "   puts \"<FF> \$plugin_error\"\n"
                  append commands "   puts \"<FF> ==============================================\"\n"
                  append commands "   set return_code 99\n"
                  if {$abort} {
                     append commands "    exit \$return_code\n"
                  }
                  append commands "}\n"
               }
            }
         } elseif {$vars(flat) == "full"} {
            if {!$found} {
               append commands "ff_procs::source_plug $plugin\n"
            } else {
               if {$verbose && ![regexp "," $plugin]} {
                  set commands "\n# <begin plug-in $plugin>\n"
               }
               if {![info exists vars(plug_files)]} {
                  set vars(plug_files) [list]
               }
               foreach plug_file $plug_list {
                  if {[file exists $plug_file]} {
#                     if {$verbose} {
#                        append commands "#>>>\n"
#                     }
                     append commands "# <begin $plug_file>\n"
                     if {[info exists vars(old_plugins)] && $vars(old_plugins) && ([lsearch $vars(edi_plugins) $plugin] != -1)} {
                        append commands "eval_enc \{\n"
                     }
                     if {[lsearch $vars(plug_files) $plugin] == -1} {
                        set suffix [lindex [split $plugin ","] 1]
                        if {($suffix != "derate_tcl") && ($suffix != "scale_tcl")} {
                           lappend vars(plug_files) "$plugin"
                        }
                     }
                     set ip [open $plug_file r]
                     while {[gets $ip line]>=0} {
#                        if {![regexp "^$" $line]} { 
                           if {$vars(generate_flow_steps)} {
                              append commands "   $line\n"
                           } else {
                              append commands "$line\n"
                           }
                           if {![regexp "^#" $line]} { 
                              append no_comments "   $line\n"
                           }
#                        }
                     }
                     close $ip
                     append commands "# <end $plug_file>\n"
                     if {[info exists vars(old_plugins)] && $vars(old_plugins) && ([lsearch $vars(edi_plugins) $plugin] != -1)} {
                        append commands "\}\n"
                     }
#                     if {$verbose} {
#                        append commands "#<<<\n"
#                     }
                  } elseif {[file exists $vars(plug_dir)/$plug_file]} {
#                     if {$verbose} {
#                        append commands "#>>>\n"
#                     }
                     if {[lsearch $vars(plug_files) $plugin] == -1} {
                        set suffix [lindex [split $plugin ","] 1]
                        if {($suffix != "derate_tcl") && ($suffix != "scale_tcl")} {
                           lappend vars(plug_files) "$plugin"
                        }
                     }
                     set ip [open $vars(plug_dir)/$plug_file r]
                     while {[gets $ip line]>=0} {
                        if {![regexp "^$" $line]} { 
                           append commands "$line\n"
                        }
                        if {![regexp "^#" $line]} { 
                           append no_comments "   $line\n"
                        }
                     }
                     close $ip
#                     if {$verbose} {
#                        append commands "#<<<\n"
#                     }
                  } 
               }
               if {$verbose && ![regexp "," $plugin]} {
                  append commands "# <end plug-in $plugin>\n\n"
               }
            }
         } else {
            append commands "ff_procs::source_plug $plugin\n"
         }
      }
      set vars(flat) $flat
      if {$vars(generate_flow_steps) && ($no_comments != "") && ![regexp ff_procs $commands] && ![regexp derate_tcl $plugin]} {
         if {$no_comments == ""} {
            set commands ""
         }
         if {[lindex [split $vars(version) "."]  0] > 14} {
           if {![file exists $vars(cwd)/.plugins]} {
              set op [open $vars(cwd)/.plugins w]
           } else {
              set op [open $vars(cwd)/.plugins a]
           }

           if {[regexp "^pre_$vars(step)" $plugin] && ($vars(step) != "partition_place")} {
              set type begin_tcl
           } else {
              if {[regexp "^post_$vars(step)" $plugin] && ($vars(step) != "partition_place")} {
                 set type end_tcl
              } else {
                if {[regexp "^syn" $plugin] || [regexp "^always" $plugin] || [regexp "^final_always" $plugin] || [regexp "^pre_syn" $plugin]} {
                  set type import 
                } else {
                  if {$vars(step) != "partition_place"} {
                     set type skip 
                  } else {
                     set type import
                  } 
                }
              }
           }

           set step_plug [format %s_%s $vars(step) $plugin]
           if {![info exists vars(processed_plugins)]} {
              set vars(processed_plugins) [list]
              lappend vars(processed_plugins) $step_plug
           } else {
#              puts "$vars(processed_plugins) : $step_plug"
              if {[lsearch $vars(processed_plugins) $step_plug] == -1} {
                 lappend vars(processed_plugins) $step_plug
              } else {
                 if {($vars(step) != "partition_place") && ![regexp "always" $plugin]} {
                    set type skip
                 }
              }
           }
           if {$type != "skip"} {
#              if {$type == "import"} {
#                 set ip [open $plug_file r]
#                 while {[gets $ip line]>=0} {
#                    if {![regexp "^$" $line]} { 
#                       append commands "   $line\n"
#                       if {![regexp "^#" $line]} { 
#                          append no_comments "   $line\n"
#                       }
#                    }
#                 }
#                 close $ip
                 return $commands
              } else {
                 if {[info exists vars(old_plugins)] && ![regexp syn_ $vars(step)]} {
                     set temp "set_db flow_step:$vars(step) .$type { eval_enc {\n"
                     append temp $no_comments
                     append temp "}}\n"
                     puts $op $temp
                 } else {
                     set temp "set_db flow_step:$vars(step) .$type {\n"
                     append temp $no_comments
                     append temp "}\n"
                     puts $op $temp
                 }
              }
           } else {
              puts "Skipping plugin $plugin as it cannot be (or already has been) tied to a flow_step attribute"
           }
           close $op
         } else {
           return $commands
         }
      } else {
        return $commands
      }
   }

   namespace export get_tool 
   proc get_tool {} {
     set tool_name ""
     set path_to_exe [info nameofexecutable]
     if {[regexp {/rc(64)?(-\w)?$} $path_to_exe]} {
       set tool_name "rc"
     } elseif {[regexp {/genus(64)?(-\w)?$} $path_to_exe]} {
       set tool_name "rc"
     } elseif {[regexp {.*\/(LEC|lec)} $path_to_exe]} {
       set tool_name "lec"
     } elseif {[regexp {.*\/verify} $path_to_exe]} {
       set tool_name "clp"
     } elseif {[regexp {.*\/CCD} $path_to_exe]} {
       set tool_name "ccd"
     } elseif {[regexp {.*\/ctos} $path_to_exe]} {
       set tool_name "ctos"
     } elseif {[regexp {.*\/tclsh} $path_to_exe]} {
       set tool_name "tclsh"
     } elseif {[regexp {.*\/innovus} $path_to_exe]} {
       set tool_name "edi"
     } elseif {[regexp {.*\/encounter} $path_to_exe]} {
       set tool_name "edi"
     } elseif {[regexp {.*\/velocity} $path_to_exe]} {
       set tool_name "edi"
     } elseif {[regexp {.*\/ncsim} $path_to_exe]} {
       set tool_name "ies"
     }
     return $tool_name
   }

   proc source_file {file {abort 1}} {
      global vars
      global source_error
      global errorInfo
      global return_code

#      puts "<FF> LOADING '$file' FILE"
      if {[file exists $file]} {
         if {[info command FF::get_tool] ne "" && [FF::get_tool] eq "rc" } {
             set sourceResult [catch { uplevel tcl_source $file } source_error ]
         } else {
             set sourceResult [catch { uplevel source $file } source_error ]
         }
         if { $sourceResult } {
            puts "<FF> =============== TCL ERROR ===================="
            puts "<FF> Error loading $file file"
            puts "<FF> $errorInfo"
            puts "<FF> $source_error"
            puts "<FF> =============================================="
            set return_code 99
            if {$abort} {
               exit $return_code
            }
         }
      }
   }

   proc get_by_suffix {passed_array {suffix ""}} {
      #
      # Get the list of array indices that have a suffix of the
      # passed string sequence
      #

      upvar $passed_array the_array

      #
      # If there is no suffix, return every name
      #

      if {[string length $suffix] == 0} {
         return array names the_array
      }

      #
      # If there is a suffix, find the matching names and return
      # the list of those names (without the suffix attached to it).
      # This is most helpful when looking for "multi-dimensional array
      # indices" (in quotes because Tcl doesn't support multiple
      # dimensions for array indices)
      #

      set suffix_length [string length $suffix]
      set all_names [array names the_array -glob "*$suffix"]
      set names [list]
      foreach name $all_names {
         set length [string length $name]
         set index [string range $name 0 [expr $length - $suffix_length - 1]]
         lappend names $index
      }
      return $names
   }

   ###########################################################################
   # Utility procedures on lists
   ###########################################################################

   proc lintersection {lista listb} {
      #
      # Return the intersection of lista and listb, removing any duplicates
      #

      set intersect [list]
      foreach a $lista {
         if {([lsearch $listb $a] != -1) && \
                ([lsearch $intersect $a] == -1)} {
            lappend intersect $a
         }
      }
      return $intersect
   }


   proc lunion {lista listb} {
      #
      # Return the union of lista and listb, removing any duplicates
      #

      set union [list]
      foreach a $lista {
         if {[lsearch $union $a] == -1} {
            lappend union $a
         }
      }
      foreach b $listb {
         if {[lsearch $union $b] == -1} {
            lappend union $b
         }
      }
      return $union
   }

   ###########################################################################
   # Utilities to handle different control structure output (if-then-else,
   # foreach, etc.)
   ###########################################################################

   proc for_each {var var_list code_block} {
      #
      # Return a string for a Tcl foreach block
      #

      set code ""
      if {![llength $code_block]} {
         return $code
      }

      set code "foreach $var $var_list \{\n"
      foreach line [getLines $code_block] {
         append code "   $line"
      }
      append code "\}\n"
      return $code
   }

   proc get_lines {code_block} {
      #
      # Return a list of lines from the strings in code_block
      #

      set block [list]
      while {[llength $code_block]} {
         set index [string first "\n" $code_block]
         if {$index == -1} {
            set index [string length $code_block]
         }
         set line [string range $code_block 0 $index]
         set code_block [string range $code_block [expr $index + 1] end]

         if {[string index $line end] != "\n"} {
            append line "\n"
         }
         lappend block $line
      }

      return $block
   }

   proc if_else {cond then_block {else_block ""}} {
      #
      # Output a Tcl if-then-else block with the passed data.
      #

      set command "if \{$cond\} \{\n"
      foreach line [get_lines $then_block] {
         append command "   $line"
      }
      if {[llength $else_block]} {
         append command "\} else \{\n"
         foreach line [get_lines $else_block] {
            append command "   $line"
         }
      }
      append command "\}\n"
      return $command
   }

   proc pretty_print_lists {line debug} {
      #
      # If there is an explicit Tcl list in the line, we may want to
      # separate it out into multiple lines.  It will turn a list from
      #       [list a b c]
      # into
      #       [list a \
      #             b \
      #             c]
      # That may not look like much, but for lists that have really *big*
      # text entries, it makes it look a lot nicer
      #
      # If there is no list in the line, do nothing
      #

      set endChar [string index $line end]
      set line [string trimright $line]
      if {$endChar == "\n"} {
         append line "\n"
      }
      set listPos [string first "\[list " $line]
      if {$listPos == -1} {
         return $line
      }
      set original $line

      #
      # Initialize the line with the contents of the line up to and including
      # the "[list " text.  Also determine the amount of indentation in the
      # line so that we know what to do for subsequent lines
      #

      incr listPos 5
      set nextLine [string range $line 0 $listPos]
      set indent [string repeat " " [string length $nextLine]]
      set line [string trimleft [string range $line $listPos end]]

      #
      # Make sure that there is no space between the close brace in the list
      # and the last text in the list.  This will help with processing (below)
      #

      set line [string trimright $line]
      if {[string index $line end] != "\]"} {
         return $original
      }
      set line [string range $line 0 [expr [string length $line] - 2]]
      set line [string trimright $line]
      append line "\]\n"

      #
      # Parse each element in the list
      #

      set printString ""
      while {[string length $line]} {
         #
         # Get the next item in the list
         #

         set space [string first " " $line]
         if {$space == -1} {
            set space [string length $line]
         }
         set arg [string range $line 0 $space]
         append nextLine $arg

         #
         # Remove that item from the line
         #

         set line [string range $line [expr $space + 1] end]
         set line [string trimleft $line]
         if {[string length $line]} {
            if {[string length $nextLine] > 80} {
               append printString "$nextLine\\\n"
               set nextLine $indent
            }
         }
      }
      append printString $nextLine
      return $printString
   }

   proc pretty_print {commands format_options {debug 0}} {

      global vars

      #
      # Pretty print the lines, one by one.  The following will be done:
      #   o If the line is greater than 80 columns, we will break it up
      #     along the options (-option) and indent
      #   o Fix any indentation
      #

      if {[info exists vars(catch_errors)] && $vars(catch_errors)} {
         set indent 3
      } else {
         set indent 0
      }
      set lines ""
      set len [string length $commands]
      while {$len > 0} {
         #
         # Handle the simple case.  If the leading character is a carriage
         # return, append a blank line to the pretty-printed lines and
         # continue on
         #

         set cr [string first "\n" $commands]
         if {!$cr} {
            set commands [string range $commands 1 end]
            incr len -1
            append lines "\n"
            continue
         }

         #
         # If we didn't find a carriage return in the string, the entire thing
         # is a single line.  Otherwise, remove the next line from the set of
         # lines.  If it still ends up being a blank line, append the blank
         # line to the pretty-printed string and continue on
         #

         if {$cr == -1} {
            set line $commands
            set commands ""
            set len 0
         } else {
            set line [string range $commands 0 $cr]
            set commands [string range $commands [incr cr] end]
            set len [expr $len - $cr]
         }
         set line [string trimright $line]
         if {![string length $line]} {
            append lines "\n"
            continue
         }

         #
         # We have a real line with real text.  If there is no quote in the
         # string, compress multiple blank spaces to a single blank space
         #

         set line [string trimleft $line]
         if {[string first "\"" $line] == -1} {
            set line [regsub -all {\s+} $line " "]
         }

         #
         # Apply the proper amount of indentation
         #

         set isPut [string equal -nocase -length 5 $line "puts "]
         set firstChar [string index $line 0]
         if {$firstChar == "\}"} {
            incr indent -3
         }
         set blanks [string repeat " " $indent]
         set line "${blanks}${line}"
         if {[string index $line end] == "\{"} {
            incr indent 3
         }

         #
         # If the first character is a dash, we have already broken the line
         # up for pretty printing.
         #

         if {$firstChar == "-"} {
            append lines "   $line\n"
            continue
         }

         #
         # Don't bother formatting comments or short lines.  Also, if the
         # routine has been told not to format the command line options, just
         # output the line
         #

         set lineLen [string length $line]
         if {$isPut || ($firstChar == "\#") ||
             ($lineLen < 80) || !$format_options} {
            append lines "$line\n"
            continue
         }

         #
         # The line length is over 80, and it's a real Innovus command, and it's
         # not a print (puts) statement.  Start indenting on the -option
         # options.  The first "-option" should be on the same line as the
         # command.  All subsequent options should be on their own line,
         # slightly indented from the basic command
         #

         set firstDash [string first " -" $line]
         if {$firstDash == -1} {
            append lines "$line\n"
            continue
         }

         set dash [string first " -" $line [incr firstDash]]
         set leading ""
         while {$dash != -1} {
            set fragment [string range $line 0 [expr $dash - 1]]
            append lines \
               [pretty_print_lists "${leading}${fragment} \\\n" $debug]
            set leading "$blanks   "
            set line [string range $line [expr $dash + 1] end]
            set line [string trimleft $line]
            set dash [string first " -" $line]
         }
         append lines [pretty_print_lists "${leading}${line}\n" $debug]
      }
      return $lines
   }

   proc strip_lines {commands markers} {
      #
      # This routine strips out lines from $commands when they start with
      # any of the list elements in $markers
      #

      set lines ""
      while {[string length $commands] > 0} {
         #
         # Get the next line from the set of commands
         #

         set cr [string first "\n" $commands]
         if {$cr == -1} {
            set line $commands
            set commands ""
         } else {
            set line [string range $commands 0 $cr]
            set commands [string range $commands [incr cr] end]
         }

         #
         # If the line starts with a marker, ignore the line
         #

         set trimmed [string trimleft $line]
         set matched false
         foreach marker $markers {
            set len [string length $marker]
            if {[string equal -nocase -length $len $marker $trimmed]} {
               set matched true
               break
            }
         }
         if {$matched} {
            continue
         }
         append lines $line
      }

      return $lines
   }

   proc gen_makefile {steps type} {
      global vars
      global desc
      global env
      global errors

      puts "HELLO"

      if {!$vars(makefile)} {
         return
      }

      set desc(syn_map) "Technology Mapping"
      set desc(syn_incr) "Incremental Synthesis"
      set desc(syn_place) "Placement/Physical Synthesis"
      set desc(init) "Design Import / Initialization"
      if {$vars(rc)} {
         set desc(place) "Legalization"
      } else {
         set desc(place) "Cell Placement"
      }
      set desc(prects) "PreCTS Optimization"
      set desc(cts) "Clock Tree Synthesis"
      set desc(postcts) "PostCTS Optimization"
      set desc(postcts_hold) "PostCTS Hold Fixing"
      set desc(route) "Global/Detail Route"
      set desc(postroute) "PostRoute Optimization"
      set desc(postroute_hold) "PostRoute Hold Fixing"
      set desc(postroute_si_hold) "SI Hold Fixing"
      set desc(postroute_si) "SI Optimization"
      set desc(signoff) "Signoff Timing / Verify"

      if {$vars(debug)} {
         puts "<DEBUG> Generating $type makefile in [exec pwd] for steps $steps ..."
#         if {[info exists vars(partition_dir)]} {
#            puts "vars(partition_dir) -> $vars(partition_dir)"
#            puts "[file tail [file dirname [exec pwd]]] == $vars(partition_dir)"
#            puts "[file dirname [exec pwd]] == [file normalize $vars(partition_dir)]"
#         }
      }

      puts "-------------------------------------------------"
      puts "<FF> Generating $type Makefile for [llength $steps] steps"
      puts "<FF> Directory: [pwd]"
      puts "<FF>     Steps: $steps"
#      puts "-------------------------------------------------"
      # BCL: Note - the Makefile needs to be fixed to the rundir here, as it will be dumped in the final exported
      # vars.tcl
      if {$vars(make) == "all"} {
         if {([file tail [file dirname [exec pwd]]] == $vars(partition_dir)) || \
             ([file tail [file dirname [exec pwd]]] == $vars(partition_dir_pass2))} {
            set vars(makefile_name) "Makefile"
         } else {
            set vars(makefile_name) "\$vars(rundir)/Makefile"
         }
      } else {
         if {[file tail [file dirname [exec pwd]]] == $vars(partition_dir)} {
            set vars(makefile_name) "Makefile.$vars(argv)"
         } else {
            set vars(makefile_name) "\$vars(rundir)/Makefile.$vars(argv)"
         }
      }

      regsub -all " " $vars(makefile_name) "_" vars(makefile_name)

      set op [open [subst $vars(makefile_name)] w]
#      if {$vars(debug)} {
#         puts "<DEBUG> Opening file: $vars(makefile_name) in [exec pwd] -> $op"
#      }
#      set stop signoff
      set stop [lindex $vars(steps) [expr [llength $vars(steps)]-1]]
      if {$vars(rc) && [info exists vars(rc_steps)]} {
         set start [lindex $vars(rc_steps) 0]
      } else {
         set start [lindex $vars(steps) 0]
      }

      if {$type == "hier"} {
         set type top_down
         if {$vars(hier_flow_type) == "2pass"} {
            set type 2pass
            if {$vars(enable_flexilm)} {
              set type flexilm
            }
         }
      }
      if {$type == "user"} { set type flat }

      switch $type {

         "flat" {
            set execute_string [join $vars(execute_string)]
            puts $op "VERSION=17.10-p003_1"
            puts $op "VPATH=$env(VPATH)"
            puts $op "TCLSH=[lindex $execute_string 0]"
            puts $op "GEN_FLOW=[::FF::relPathTo [file normalize [subst [lindex $execute_string 1]]] [file normalize [subst $vars(rundir)]]]"
            puts $op "SETUP_PATH=[relPathTo [file normalize [subst $vars(setup_path)]] [file normalize [subst $vars(rundir)]]]"
            puts $op "TOOL=$vars(make_tool)"
            puts $op "ARGS=$vars(make_tool_args)"
            puts $op "FSTEPS=$steps"
            if {$vars(rc)} {
               puts $op "SYN_TOOL=$vars(make_syn_tool)"
               puts $op "SYN_ARGS=$vars(make_syn_tool_args)"
              if {[info exists vars(syn_log_dir)]} {
                 puts $op "SYN_LOG=[relPathTo [file normalize [subst $vars(syn_log_dir)]] [file normalize $vars(rundir)]]"
              }
            }
            if {[regexp $vars(partition_dir) [file tail [file dirname [pwd]]]]} {
               puts $op "SCRIPTS=$vars(script_dir)"
               puts $op "LOG=$vars(log_dir)"
            } else {
               # BCL: Added the following in order to fix the difference in location between the rundir and scripts location
               puts $op "SCRIPTS=[relPathTo [file normalize $vars(script_dir)] [file normalize $vars(rundir)]]"
               # BCL: Added subst to resolve vars(rundir)
               # BCL: Then modified to make relative to the rundir
               puts $op "LOG=[relPathTo [file normalize [subst $vars(log_dir)]] [file normalize $vars(rundir)]]"
            }
            puts $op "BROWSER=$vars(make_browser)"
            if {[info exists vars(make_update)]} {
               puts $op "UPDATE=$vars(make_update)"
            } elseif {[file tail [file dirname [pwd]]] != "$vars(partition_dir)"} {
               puts $op "UPDATE=yes"
            }
            puts $op ""

            puts $op "STEPS = [format "version setup %s do_cleanup" $steps]"
            puts $op "FF_START = $start"
            puts $op "FF_STOP = $stop"
            puts $op ""
            puts $op [format "all: version setup %s do_cleanup" $steps]
            puts $op ""
            puts $op "version:"
            puts $op "\t@echo \"\# Foundation Flows Version \$(VERSION)\""
            puts $op ""
            puts $op "help:"
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"           \$(VERSION)  Foundation Flows\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"   Makefile Targets\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"               setup : Setup Run Directory\""
            if {$vars(rc) && [info exists vars(rc_steps)]} {
               foreach step $vars(rc_steps) {
                 puts $op "\t@echo \"             $step : $desc($step)\""
               }
            }
            foreach step $steps {
#              puts $op "\t@echo \"             $step : $desc($step)\""
              if {![info exists desc($step)]} {
                set desc($step) "No information for this step"
              } 
              set temp [format "%+21s : %-45s" $step $desc($step)]
              puts $op "\t@echo $temp"
            }
            puts $op "\t@echo \"---------------------------------------------------\""
            puts $op "\t@echo \"                 all : All design steps\""
            puts $op "\t@echo \"              simple : Single script (all steps in a single session) - no stop/start\""
            puts $op "\t@echo \"              single : Single script (all steps in a single session)\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"   Makefile Options\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"   VPATH : Make directory    (default make)\""
            if {$vars(novus)}  { 
               puts $op "\t@echo \"    TOOL : INNOVUS executable (default innovus)\""
               puts $op "\t@echo \"    ARGS : INNOVUS arguments  (default -nowin -64)\""
            } else {
               puts $op "\t@echo \"    TOOL : INNOVUS executable     (default innovus)\""
               puts $op "\t@echo \"    ARGS : INNOVUS arguments      (default -nowin -64)\""
            }
            if {$vars(rc)} {
               puts $op "\t@echo \"SYN_TOOL : GENUS executable      (default genus)\""
               puts $op "\t@echo \"SYN_ARGS : GENUS arguments       (default -64)\""
               puts $op "\t@echo \"SYN_LOG  : GENUS log dir         (default RC/logs/<stage>.log)\""
            }
            if {[file tail [file dirname [pwd]]] != "$vars(partition_dir)"} {
               puts $op "\t@echo \"  UPDATE : Update scripts    (default yes)\""
            }
            puts $op "\t@echo \" SCRIPTS : Script directory  (default $vars(script_dir))\""
            puts $op "\t@echo \"     LOG : Logfile directory (default [subst $vars(log_dir))]\""
            puts $op "\t@echo \"===================================================\""
            puts $op ""
#            if {[file tail [file dirname [pwd]]] != "$vars(partition_dir)"} {
#               if {[info exists vars(plug_files)]} {
#                  puts $op "flow: $vars(config_files) $vars(plug_files)"
#               } else {
#                  puts $op "flow: $vars(config_files)"
#               }
#               puts $op "\t@if \[ \$(UPDATE) == yes ] ; then \\"
#               puts $op "\t\t[lindex $execute_string 0] [lindex $execute_string 1] -m flat all ; \\"
#               puts $op "\t\t/bin/touch \$(VPATH)/\$@ ; \\"
#               puts $op "\telse \\"
#               puts $op "\t\techo 'SKIPPING FLOW UPDATE ...' ; \\"
#               puts $op "\tfi"
#           } else {
#               puts $op "flow:"
#            }

            puts $op "\nsimple: setup"
            if {$vars(step_arg) == "all"} {
               puts $op "\tFF_STOP=\$(FF_STOP); VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_simple.tcl -log \$(LOG)/simple.log \$(ARGS)"
            } else {
               puts $op "\tFF_STOP=\$(FF_STOP); VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_simple.$vars(step_arg).tcl -log \$(LOG)/simple.$vars(step_arg).log \$(ARGS)"
            }
            puts $op ""
            puts $op "\nsingle: setup"
            puts $op "\tFF_STOP=\$(FF_STOP); VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_all.tcl -log \$(LOG)/single.log \$(ARGS)"
            puts $op ""
            puts $op "setup:"
            puts $op "\t@/bin/mkdir -p \$(VPATH) \$(LOG)"
            puts $op "\t@/bin/touch \$(VPATH)/\$@"
            if {[info exists vars(enable_ldb)] && $vars(enable_ldb)} {
               puts $op "\t\$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_compile.tcl -log \$(LOG)/compile.log -win \$(ARGS)"
            }
            puts $op "" 


            set prior_step "setup"

            set arg_list "-n "
#            if {$vars(novus)} {
#               append arg_list "-N " 
#            }
            if {$vars(verbose)} {
               append arg_list "-V " 
            }
            if {$vars(edi)} {
               append arg_list "-e " 
            }
            if {$vars(rc)} {
               append arg_list "-r " 
            }
            # RC Steps, if any, always go first
            if {[info exists vars(rc_steps)] && $vars(rc_steps) ne ""} {
              foreach step $vars(rc_steps) {
                puts $op "$step: $prior_step"
                puts $op "\t@mkdir -p \$(SYN_LOG);"
                if {![regexp $vars(partition_dir) [file tail [file dirname [pwd]]]]} {
                   puts $op "\t@if \[ \"\$(UPDATE)\" = \"yes\" ] ; then \\"
                   if {[file normalize .] ne [file normalize $vars(rundir)]} {
                     puts $op "\t\tcd [relPathTo [file normalize .] [file normalize $vars(rundir)]]; [lindex $execute_string 0] [::FF::relPathTo [file normalize [subst [lindex $execute_string 1]]] [file normalize [subst $vars(rundir)]]] -m flat -d [relPathTo [file normalize $vars(script_dir)] [file normalize $vars(rundir)]] -v $vars(version) -s [relPathTo [file normalize [subst $vars(setup_path)]] [file normalize [subst $vars(rundir)]]] -y none -u [relPathTo [file normalize $vars(rundir)] [file normalize .]] $arg_list $step ; \\"
		   } else {
                     puts $op "\t\t[lindex $execute_string 0] [::FF::relPathTo [file normalize [subst [lindex $execute_string 1]]] [file normalize [subst $vars(rundir)]]] -m flat -d [relPathTo [file normalize $vars(script_dir)] [file normalize $vars(rundir)]] -v $vars(version) -s [relPathTo [file normalize [subst $vars(setup_path)]] [file normalize [subst $vars(rundir)]]] -y none $arg_list $step ; \\"
		   }
                   puts $op "\tfi"
                 }
                puts $op "\tVPATH=\$(VPATH); export VPATH; \$(SYN_TOOL) -f \$(SCRIPTS)/GENUS/$step.tcl -logfile \$(SYN_LOG)/$step.log -cmdfile \$(SYN_LOG)/$step.cmd \$(SYN_ARGS)"
                set prior_step $step
              }
            }

            foreach step $steps {
              # These steps should not also be rc_steps:
              if {![info exists vars(rc_steps)] || [lsearch $vars(rc_steps) $step] == "-1"} {
                 puts $op "$step: $prior_step"
                 puts $op "\t@mkdir -p \$(LOG);"
#                puts $op "\t@\$(MAKE) -f Makefile flow"
                if {![regexp $vars(partition_dir) [file tail [file dirname [pwd]]]]} {
                   puts $op "\t@if \[ \"\$(UPDATE)\" = \"yes\" ] ; then \\"
                     # cd to ff_exe_dir here only if vars(rundir) ne vars(ff_exe_dir)
                     if {[file normalize .] ne [file normalize $vars(rundir)]} {
                       puts $op "\t\tcd [relPathTo [file normalize .] [file normalize $vars(rundir)]]; [lindex $execute_string 0] [::FF::relPathTo [file normalize [subst [lindex $execute_string 1]]] [file normalize [subst $vars(rundir)]]] -m $vars(mode) -d [relPathTo [file normalize $vars(script_dir)] [file normalize $vars(rundir)]] -v $vars(version) -s [relPathTo [file normalize [subst $vars(setup_path)]] [file normalize [subst $vars(rundir)]]] -y none -u [relPathTo [file normalize $vars(rundir)] [file normalize .]] $arg_list $step ; \\"
		     } else {
                       puts $op "\t\t[lindex $execute_string 0] [::FF::relPathTo [file normalize [subst [lindex $execute_string 1]]] [file normalize [subst $vars(rundir)]]] -m $vars(mode) -d [relPathTo [file normalize $vars(script_dir)] [file normalize $vars(rundir)]] -v $vars(version) -s [relPathTo [file normalize [subst $vars(setup_path)]] [file normalize [subst $vars(rundir)]]] -y none $arg_list $step ; \\"
		     }
                     # Need to add code to cd back to rundir here
                   puts $op "\tfi"
                }
                if {[regexp "^syn" $step]} { 
                   puts $op "\tVPATH=\$(VPATH); export VPATH; \$(SYN_TOOL) -f \$(SCRIPTS)/GENUS/run_$step.tcl -logfile \$(LOG)/$step.log -cmdfile \$(LOG)/$step.cmd \$(SYN_ARGS)"
                } else {
                   puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_$step.tcl -log \$(LOG)/$step.log -overwrite \$(ARGS)"
                } 
#                puts $op "\t/bin/touch \$(VPATH)/$step\n"
                set prior_step $step
              }
            }

#            puts $op "html:"
#            puts $op "\tFFVARS=$vars(script_dir)/vars.tcl; export FFVARS; /usr/bin/tclsh \$(SCRIPTS)/INNOVUS/gen_html.tcl .; cd $vars(html_dir); \$(BROWSER) file:`pwd`/index.html"
#            puts $op ""
            puts $op "debug_%:"
            puts $op "\tVPATH=\$(VPATH); export STEP=\$* ; export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_debug.tcl -log \$(LOG)/\$@.log -win \$(ARGS:-nowin=)"
            puts $op ""
            puts $op "lec_%:"
            puts $op "\texport STEP=\$* ; lec -64 -xl -Dofile \$(SCRIPTS)/INNOVUS/run_lec.tcl -NOGui -LOGfile \$(LOG)/\$@.log"
            puts $op ""
            puts $op "help_%:"
            puts $op "\t[lindex $execute_string 0] \$(GEN_FLOW) -H \$*"
            puts $op ""
#            puts $op ".PHONY: clean html"
            puts $op ".PHONY: clean"
            puts $op ""
            puts $op "clean:"
            puts $op "\t/bin/mv *.rpt $vars(rpt_dir) ;\\"
            puts $op "\t/bin/rm -fr extLogDir* __qrc.log *cts_trace *.rpt.old *delete* placementReports* *.rguide *_mmmc \\\n\t*_constr.pt .constr* .FE* .routing* .timing_file* .tdrlog*"
            puts $op "\trm make/*"
            puts $op ""
            puts $op "do_cleanup: signoff"
            puts $op "\t\$(MAKE) clean"
            puts $op "\t/bin/touch \$(VPATH)/\$@"
            puts $op ""
            puts $op "reset : version"
            puts $op "\t/bin/rm -fr \$(VPATH)/* extLogDir* __qrc.log *cts_trace *.rpt.old *delete* placementReports* *.rguide *_mmmc"
            puts $op "\t@for file in \$(STEPS) ; \\"
            puts $op "\tdo \\"
            puts $op "\t\tif \[ -r \$(VPATH)/\$\$file \] ; then \\"
            puts $op "\t\t\t/bin/rm \$(VPATH)/\$\$file ; \\"
            puts $op "\t\tfi \\"
            puts $op "\tdone"
            puts $op ""
            puts $op "block_%: setup"
            puts $op "\t@if \[ \"x\$*\" = \"xsingle\" \] ; then \\"
            puts $op "\t\tff_stop=\$(FF_STOP); \\"
            puts $op "\t\ttarget=\"\$@ (from: \$(FF_START) to: \$(FF_STOP))\"; \\"
            puts $op "\telse \\"
            puts $op "\t\tff_stop=\$* ; \\"
            puts $op "\t\ttarget=\$@; \\"
            puts $op "\tfi; \\"
            puts $op "\tif \[ -r \$(VPATH)/.RUNNING \] ; then \\"
            puts $op "\t\techo \"INFO: A build seems to be running already... check \$(VPATH)/.RUNNING file and remove that file if the process is dead\" ; \\"
            puts $op "\t\t/bin/head -1  \$(VPATH)/.RUNNING ; \\"
            puts $op "\t\texit -1 ; \\"
            puts $op "\telse \\"
            puts $op "\t\t/bin/rm -f \$(VPATH)/block_\$\$\{ff_stop\}.DONE \$(VPATH)/block_\$\$\{ff_stop\}.FAILED \$(VPATH)/block_\$\$\{ff_stop\}.PASS ; \\"
            puts $op "\t\t(echo \"# Started building \$\$\{target\} at \"`/bin/date`\" on \"`/bin/hostname`\" PID: \$\$\$\$\" ; \$(MAKE) \$(TARGET) ) &>\$(VPATH)/.RUNNING ; \\"
            puts $op "\t\tif \[ -r \$(VPATH)/\$\$\{ff_stop\} \] ; then \\"
            puts $op "\t\t\tif \[ -r \$(VPATH)/.RUNNING \] ; then \\"
            puts $op "\t\t\t\t/bin/mv \$(VPATH)/.RUNNING \$(VPATH)/block_\$\$\{ff_stop\}.PASS ; \\"
            puts $op "\t\t\t\t/bin/touch \$(VPATH)/block_\$\$\{ff_stop\} ; \\"
            puts $op "\t\t\t\t/bin/touch \$(VPATH)/block_\$\$\{ff_stop\}.DONE ; \\"
            puts $op "\t\t\telse \\"
            puts $op "\t\t\t\techo \"# Something did not work properly\" > \$(VPATH)/block_\$\$\{ff_stop\}.FAILED ; \\"
            puts $op "\t\t\t\t/bin/touch \$(VPATH)/block_\$\$\{ff_stop\}.DONE ; \\"
            puts $op "\t\t\t\texit -1; \\"
            puts $op "\t\t\tfi ; \\"
            puts $op "\t\telse \\"
            puts $op "\t\t\tif \[ -r \$(VPATH)/.RUNNING \] ; then \\"
            puts $op "\t\t\t\t/bin/mv \$(VPATH)/.RUNNING \$(VPATH)/block_\$\$\{ff_stop\}.FAILED ; \\"
            puts $op "\t\t\telse \\"
            puts $op "\t\t\t\techo \"# Something did not work properly\" > \$(VPATH)/block_\$\$\{ff_stop\}.FAILED ; \\"
            puts $op "\t\t\tfi ; \\"
            puts $op "\t\t\t/bin/touch \$(VPATH)/block_\$\$\{ff_stop\}.DONE ; \\"
            puts $op "\t\t\texit -1 ; \\"
            puts $op "\t\tfi ; \\"
            puts $op "\tfi"

            if {$vars(generate_flow_steps) && [info exists vars(flow_steps)]} {
               if {[info exists vars(flow_steps,flat)]} {
                  set fp1 [open $vars(script_dir)/flow_config.tcl w]
                  set fp2 [open $vars(script_dir)/flow_steps.tcl w]
                  puts $fp1 "set_db flow_database_directory $vars(dbs_dir)"
                  puts $fp1 "set_db flow_report_directory $vars(rpt_dir)"
                  puts $fp1 "set_db flow_log_directory $vars(log_dir)"
                  puts $fp2 [regsub "create_flow_step -name init " $vars(flow_steps,flat) "create_flow_step -name init_design "]
                  puts $fp1 "\nset_db flow_mail_to [exec whoami]"
                  puts $fp1 "set_db flow_mail_on_error true\n"
                  if {$vars(top)} {
                     set vars(flow_name) top
                  } else {
                     set vars(flow_name) block
                  }
                  if {[file exists $vars(cwd)/.plugins]} {
                     set ip [open $vars(cwd)/.plugins r]
                     while {[gets $ip line]>=0} { 
                        puts $fp1 $line 
                     }
                     close $ip
#                     file delete $vars(cwd)/.plugins 
                  }
                  close $fp1
                  puts $fp2 "create_flow_step -name init_floorplan { }"
                  close $fp2
                  if {[info exists vars(partition_list)]} {
                     if {($vars(design) == [lindex $vars(partition_list) 0]) || $vars(top)} {
                        set hp [open $vars(script_dir)/.hiersteps.tcl w]
                        if {$vars(top)} {
                           set temp [regsub -all "create_flow_step -name init" $vars(flow_steps,flat) "create_flow_step -name top_init"]
                           set temp2 [regsub -all "create_flow_step -name prects" $temp "create_flow_step -name top_prects"]
                           set temp3 [regsub -all "create_flow_step -name place" $temp2 "create_flow_step -name top_place"]
                           set temp4 [regsub -all "create_flow_step -name cts" $temp3 "create_flow_step -name top_cts"]
                           set vars(flow_steps,flat) [regsub -all "create_flow_step -name signoff" $temp4 "create_flow_step -name top_signoff"]
                        }
                        puts $hp $vars(flow_steps,flat)
                        close $hp
                     }
                  }
                  unset vars(flow_steps)
               }
            }
            if {$vars(generate_flow_steps)} {
               if {[lsearch $steps "assemble"] != -1} {
                  set steps [lreplace $steps end end]
               } 
               set fp [open run_flow.tcl w]
               puts $fp "source $vars(script_dir)/flow_steps.tcl"
               puts $fp "if \{\[file exists $vars(script_dir)/plug_steps.tcl\]\} \{"
               puts $fp "  source $vars(script_dir)/plug_steps.tcl"
               puts $fp "\}"
               if {[file tail [pwd]] == $vars(top_cell)} {
                   if {[file tail [file dirname [pwd]]] == "$vars(partition_dir)"} {
                      set vars(flow_name) "top"
                   } else {
                      set vars(flow_name) "top_pass2"
                   }
                  set top_steps " $steps"
                  foreach s "init place prects cts signoff" {
                     set temp [regsub " $s" $top_steps " top_$s"]
                     set top_steps $temp 
                  }
                   puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $top_steps\]\n"
               } else {
                  set dir [file tail [pwd]]
                  set pdir [file tail [file tail $dir]]
                  if {[info exists vars(partition_list)]} {
                     if {([file tail [pwd]] == [lindex $vars(partition_list) 0])} {
                        if {[file tail [file dirname [pwd]]] == "$vars(partition_dir)"} {
                           set vars(flow_name) "block"
                         } else {
                           set vars(flow_name) "block_pass2"
                         }
                         puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $steps\]\n"
                     }
                  } else {
                     if {!$vars(rc)} {
                        set vars(flow_name) "innovus"
                        puts $fp "source $vars(script_dir)/flow_config.tcl"
                        puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $steps\]\n"
                     } else {
                        set rc_steps [list]
                        set edi_steps [list]
                        foreach s $steps {
                           if {[regexp syn_ $s]} {
                              lappend rc_steps $s
                           } else {
                              lappend edi_steps $s
                           }
                        }
                        set vars(flow_name) "genus"
#                        puts $fp "source $vars(script_dir)/flow_steps.tcl"
                        puts $fp "source $vars(script_dir)/flow_config.tcl"
                        puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_syn_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $rc_steps\]\n"
                        set vars(flow_name) "innovus"
                        puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $edi_steps\]\n"
                     }
                  }
               }
               close $fp
            }
         }
         "bottom_up" {
            puts $op "VERSION=17.10-p003_1"
            puts $op "VPATH=$env(VPATH)"
            puts $op "TOOL=$vars(make_tool)"
            puts $op "SCRIPTS=$vars(script_dir)"
            puts $op "LOG=$vars(log_dir)"
            puts $op "BROWSER=$vars(make_browser)"
            if {[info exists vars(make_update)]} {
               puts $op "UPDATE=$vars(make_update)"
            } elseif {[file tail [file dirname [pwd]]] != "$vars(partition_dir)"} {
               puts $op "UPDATE=yes"
            }
            puts $op ""
            puts $op "ARGS=$vars(make_tool_args)"
            puts $op "STEPS = [format "version setup %s do_cleanup" $steps]"
            puts $op "FF_STOP = signoff"
            puts $op "FF_START = init"
            puts $op ""
            puts $op [format "all: version setup %s do_cleanup" $steps]
            puts $op ""
            puts $op "version:"
            puts $op "\t@echo \"\# Foundation Flows Version \$(VERSION)\""
            puts $op ""
            puts $op "help:"
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"           \$(VERSION)  Foundation Flows\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"   Makefile Targets\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"               setup : Setup Run Directory\""
            puts $op "\t@echo \"                init : Create Initial Database\""
            puts $op "\t@echo \"               place : Cell Placement\""
            puts $op "\t@echo \"              prects : PreCTS Optimization\""
            puts $op "\t@echo \"                 cts : Clock Tree Synthesis\""
            puts $op "\t@echo \"             postcts : PostCTS Optimization\""
            puts $op "\t@echo \"        postcts_hold : PostCTS Oold Fixing\""
            puts $op "\t@echo \"               route : Global/Detail Route\""
            puts $op "\t@echo \"           postroute : PostRoute Optimization\""
            puts $op "\t@echo \"      postroute_hold : PostRoute Hold Fixing\""
            puts $op "\t@echo \"   postroute_si_hold : SI Hold Fixing\""
            puts $op "\t@echo \"        postroute_si : SI Optimization\""
            puts $op "\t@echo \"             signoff : Signoff Timing / Verify\""
            puts $op "\t@echo \"            assemble : Design Assembly / Verify\""
            puts $op "\t@echo \"---------------------------------------------------\""
            puts $op "\t@echo \"                 all : All design steps\""
            puts $op "\t@echo \"              simple : Single script (all steps in a single session) - no stop/start\""
            puts $op "\t@echo \"              single : Single script (all steps in a single session)\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"   Makefile Options\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"   VPATH : Make directory    (default make)\""
            if {$vars(novus)} {
               puts $op "\t@echo \"    TOOL : INNOVUS executable (default innovus)\""
               puts $op "\t@echo \"    ARGS : INNOVUS arguments  (default -nowin -64)\""
            } else {
               puts $op "\t@echo \"    TOOL : INNOVUS executable     (default innovus)\""
               puts $op "\t@echo \"    ARGS : INNOVUS arguments      (default -nowin -64)\""
            }
            if {[file tail [file dirname [pwd]]] != "$vars(partition_dir)"} {
               puts $op "\t@echo \"  UPDATE : Update scripts    (default yes)\""
            }
#            puts $op "\t@echo \" BROWSER : HTML browser      (default netscape)\""
            puts $op "\t@echo \" SCRIPTS : Script directory  (default $vars(script_dir))\""
            puts $op "\t@echo \"     LOG : Logfile directory (default $vars(log_dir))\""
            puts $op "\t@echo \"===================================================\""
            puts $op ""
#            if {[file tail [file dirname [pwd]]] != "$vars(partition_dir)"} {
#               if {[info exists vars(plug_files)]} {
#                  puts $op "flow: $vars(config_files) $vars(plug_files)"
#               } else {
#                  puts $op "flow: $vars(config_files)"
#               }
#               puts $op "\t@if \[ \$(UPDATE) == yes ] ; then \\"
#               puts $op "\t\t[lindex $execute_string 0] [lindex $execute_string 1] -m flat all ; \\"
#               puts $op "\t\t/bin/touch \$(VPATH)/\$@ ; \\"
#               puts $op "\telse \\"
#               puts $op "\t\techo 'SKIPPING FLOW UPDATE ...' ; \\"
#               puts $op "\tfi"
#            } else {
#               puts $op "flow:"
#            }

            puts $op "\nsimple: setup"
            if {$vars(step_arg) == "all"} {
               puts $op "\tFF_STOP=\$(FF_STOP); VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_simple.tcl -log \$(LOG)/simple.log \$(ARGS)"
            } else {
               puts $op "\tFF_STOP=\$(FF_STOP); VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_simple.$vars(step_arg).tcl -log \$(LOG)/simple.$vars(step_arg).log \$(ARGS)"
            }
            puts $op ""
            puts $op "\nsingle: setup"
            puts $op "\tFF_STOP=\$(FF_STOP); VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_all.tcl -log \$(LOG)/single.log \$(ARGS)"
            puts $op ""
            puts $op "setup:"
            puts $op "\t@/bin/mkdir -p \$(VPATH) \$(LOG)"
            puts $op "\t@/bin/touch \$(VPATH)/\$@"
            if {[info exists vars(enable_ldb)] && $vars(enable_ldb)} {
               puts $op "\t\$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_compile.tcl -log \$(LOG)/compile.log -win \$(ARGS)"
            }
            puts $op "" 

            set prior_step "setup"
            foreach step $steps {
               puts $op "$step: $prior_step"
#               puts $op "\t@\$(MAKE) -f Makefile flow"
               if {[file dirname [pwd]] != "$vars(partition_dir)"} {
                  puts $op "\t@if \[ \$(UPDATE) == yes ] ; then \\"
                  puts $op "\t\t[lindex $execute_string 0] [lindex $execute_string 1] -n -m bottom_up $step ; \\"
                  puts $op "\tfi"
               }
               puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_$step.tcl -log \$(LOG)/$step.log -overwrite \$(ARGS)"
               puts $op "\t/bin/touch \$(VPATH)/$step\n"
               set prior_step $step
            }

#            puts $op "html:"
#            puts $op "\tFFSTEPS=\$(STEPS); export FFSTEPS; FFLOGDIR=\$(LOG); export FFLOGDIR; /usr/bin/tclsh \$(SCRIPTS)/INNOVUS/gen_html.tcl .; cd HTML; \$(BROWSER) file:`pwd`/index.html"
#            puts $op ""
            puts $op "debug_%:"
            puts $op "\tVPATH=\$(VPATH); export STEP=\$* ; export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_debug.tcl -log \$(LOG)/\$@.log -win \$(ARGS:-nowin=)"
            puts $op ""
            puts $op "lec_%:"
            puts $op "\texport STEP=\$* ; lec -64 -xl -Dofile \$(SCRIPTS)/INNOVUS/run_lec.tcl -NOGui -LOGfile \$(LOG)/\$@.log"
            puts $op ""
#            puts $op ".PHONY: clean html"
            puts $op ".PHONY: clean"
            puts $op ""
            puts $op "clean:"
            puts $op "\t/bin/mv *.rpt $vars(rpt_dir) ;\\"
            puts $op "\t/bin/rm -fr extLogDir* __qrc.log *cts_trace *.rpt.old *delete* placementReports* *.rguide *_mmmc \\\n\t*_constr.pt .constr* .FE* .routing* .timing_file* .tdrlog*"
            puts $op "\trm make/*"
            puts $op ""
            puts $op "do_cleanup: signoff"
            puts $op "\t\$(MAKE) clean"
            puts $op "\t/bin/touch \$(VPATH)/\$@"
            puts $op ""
            puts $op "reset : version"
            puts $op "\t/bin/rm -fr \$(VPATH)/* extLogDir* __qrc.log *cts_trace *.rpt.old *delete* placementReports* *.rguide *_mmmc"
            puts $op "\t@for file in \$(STEPS) ; \\"
            puts $op "\tdo \\"
            puts $op "\t\tif \[ -r \$(VPATH)/\$\$file \] ; then \\"
            puts $op "\t\t\t/bin/rm \$(VPATH)/\$\$file ; \\"
            puts $op "\t\tfi \\"
            puts $op "\tdone"
            puts $op ""
            puts $op "block_%: setup"
            puts $op "\t@if \[ \"x\$*\" = \"xsingle\" \] ; then \\"
            puts $op "\t\tff_stop=\$(FF_STOP); \\"
            puts $op "\t\ttarget=\"\$@ (from: \$(FF_START) to: \$(FF_STOP))\"; \\"
            puts $op "\telse \\"
            puts $op "\t\tff_stop=\$* ; \\"
            puts $op "\t\ttarget=\$@; \\"
            puts $op "\tfi; \\"
            puts $op "\tif \[ -r \$(VPATH)/.RUNNING \] ; then \\"
            puts $op "\t\techo \"INFO: A build seems to be running already... check \$(VPATH)/.RUNNING file and remove that file if the process is dead\" ; \\"
            puts $op "\t\t/bin/head -1  \$(VPATH)/.RUNNING ; \\"
            puts $op "\t\texit -1 ; \\"
            puts $op "\telse \\"
            puts $op "\t\t/bin/rm -f \$(VPATH)/block_\$\$\{ff_stop\}.DONE \$(VPATH)/block_\$\$\{ff_stop\}.FAILED \$(VPATH)/block_\$\$\{ff_stop\}.PASS ; \\"
            puts $op "\t\t(echo \"# Started building \$\$\{target\} at \"`/bin/date`\" on \"`/bin/hostname`\" PID: \$\$\$\$\" ; \$(MAKE) \$(TARGET) ) &>\$(VPATH)/.RUNNING ; \\"
            puts $op "\t\tif \[ -r \$(VPATH)/\$\$\{ff_stop\} \] ; then \\"
            puts $op "\t\t\tif \[ -r \$(VPATH)/.RUNNING \] ; then \\"
            puts $op "\t\t\t\t/bin/mv \$(VPATH)/.RUNNING \$(VPATH)/block_\$\$\{ff_stop\}.PASS ; \\"
            puts $op "\t\t\t\t/bin/touch \$(VPATH)/block_\$\$\{ff_stop\} ; \\"
            puts $op "\t\t\t\t/bin/touch \$(VPATH)/block_\$\$\{ff_stop\}.DONE ; \\"
            puts $op "\t\t\telse \\"
            puts $op "\t\t\t\techo \"# Something did not work properly\" > \$(VPATH)/block_\$\$\{ff_stop\}.FAILED ; \\"
            puts $op "\t\t\t\t/bin/touch \$(VPATH)/block_\$\$\{ff_stop\}.DONE ; \\"
            puts $op "\t\t\t\texit -1; \\"
            puts $op "\t\t\tfi ; \\"
            puts $op "\t\telse \\"
            puts $op "\t\t\tif \[ -r \$(VPATH)/.RUNNING \] ; then \\"
            puts $op "\t\t\t\t/bin/mv \$(VPATH)/.RUNNING \$(VPATH)/block_\$\$\{ff_stop\}.FAILED ; \\"
            puts $op "\t\t\telse \\"
            puts $op "\t\t\t\techo \"# Something did not work properly\" > \$(VPATH)/block_\$\$\{ff_stop\}.FAILED ; \\"
            puts $op "\t\t\tfi ; \\"
            puts $op "\t\t\t/bin/touch \$(VPATH)/block_\$\$\{ff_stop\}.DONE ; \\"
            puts $op "\t\t\texit -1 ; \\"
            puts $op "\t\tfi ; \\"
            puts $op "\tfi"

            if {$vars(generate_flow_steps) && [info exists vars(flow_steps)]} {
               if {[info exists vars(flow_steps,flat)]} {
                  set fp1 [open $vars(script_dir)/flow_config.tcl w]
                  set fp2 [open $vars(script_dir)/flow_steps.tcl w]
                  puts $fp1 "set_db flow_database_directory $vars(dbs_dir)"
                  puts $fp1 "set_db flow_report_directory $vars(rpt_dir)"
                  puts $fp1 "set_db flow_log_directory $vars(log_dir)"
                  puts $fp2 $vars(flow_steps,flat)
                  puts $fp1 "\nset_db flow_mail_to [exec whoami]"
                  puts $fp1 "set_db flow_mail_on_error true\n"
                  if {$vars(top)} {
                     set vars(flow_name) top
                  } else {
                     set vars(flow_name) block
                  }
#                  puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list [FF::adjust_steps]\]\n"
#                  puts $hp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $steps\]\n"
#                  puts $fp "run_flow -flow $vars(flow_name)"
                  if {[file exists $vars(cwd)/.plugins]} {
                     set ip [open $vars(cwd)/.plugins r]
                     while {[gets $ip line]>=0} { 
                        puts $fp1 $line 
                     }
                     close $ip
                     file delete $vars(cwd)/.plugins 
                  }
                  close $fp1
                  close $fp2
                  if {[info exists vars(partition_list)]} {
                     if {($vars(design) == [lindex $vars(partition_list) 0]) || $vars(top)} {
                        set hp [open $vars(script_dir)/.hiersteps.tcl w]
                        if {$vars(top)} {
                           set temp [regsub -all "create_flow_step -name init" $vars(flow_steps,flat) "create_flow_step -name top_init"]
                           set temp2 [regsub -all "create_flow_step -name cts" $temp "create_flow_step -name top_cts"]
                           set vars(flow_steps,flat) [regsub -all "create_flow_step -name signoff" $temp2 "create_flow_step -name top_signoff"]
                        }
                        puts $hp $vars(flow_steps,flat)
                        if {$vars(top)} {
                           set top_steps " $steps"
                           foreach s " init prects cts signoff" {
                              set temp [regsub " $s" $top_steps " top_$s"]
                              set top_steps $temp 
                           }
##                           set temp [regsub "init" [FF::adjust_steps] "top_init"]
#                           set temp [regsub "init" $steps "top_init"]
#                           set temp2 [regsub " prects " $temp " top_prects "]
#                           set temp3 [regsub " cts " $temp2 " top_cts "]
#                           set top_steps [regsub "signoff" $temp3 "top_signoff"]
                           puts $hp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $top_steps\]\n"
                        } else {
#                           puts $hp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list [FF::adjust_steps]\]\n"
                           puts $hp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $steps\]\n"
                        }
                        close $hp
                     }
                  }
                  unset vars(flow_steps)
               }
            }
         }
         "top_down" {
            puts $op "VERSION=17.10-p003_1"
            puts $op "VPATH=./make"
            puts $op "TOOL=$vars(make_tool)"
            puts $op "SCRIPTS=$vars(script_dir)"
            puts $op "LOG=$vars(log_dir)"
            puts $op "ARGS=$vars(make_tool_args)"
            puts $op "PARALLEL=-j2"
            puts $op "SUBMIT=\"\""
            puts $op "TARGET=signoff"
            puts $op "FF_STOP=signoff"
            puts $op "STEPS = [format "version setup %s do_cleanup" $steps]"
            puts $op ""
#            puts $op "TOP=`/bin/grep \"^set vars(design)\" $vars(setup_tcl) | /bin/awk ' { printf(\"%s\\n\",\$\$3) } '`"
            puts $op "TOP=$vars(design)"
            puts $op ""
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  puts $op "all: setup model_gen prototype partition_place assign_pin partition blocks.\$(TARGET) top.\$(TARGET) assemble"
               } else {
                  puts $op "all: setup model_gen partition_place assign_pin partition blocks.\$(TARGET) top.\$(TARGET) assemble"
               }
            } else {
               puts $op "all: setup partition_place assign_pin partition blocks.\$(TARGET) top.\$(TARGET) assemble"
            }
            puts $op ""
            puts $op "help:"
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"           \$(VERSION)  Foundation Flows\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \" Makefile Targets\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"              all : Run complete flow (default)\""
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               puts $op "\t@echo \"        model_gen : Generate flexmodels\""
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  puts $op "\t@echo \"        prototype : Flexmodel prototype\""
               }
            }
            puts $op "\t@echo \"  partition_place : Initial placement & feedthrough\""
            puts $op "\t@echo \"       assign_pin : Pin assignment\""
            puts $op "\t@echo \"        partition : Partition design\""
            puts $op "\t@echo \"  blocks.<target> : Implement blocks\""
            puts $op "\t@echo \"         assemble : Assemble design\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \" Makefile Options\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"   VPATH  : Make directory     (default make)\""
            puts $op "\t@echo \"  SUBMIT  : LSF launch command (default '')\""
            puts $op "\t@echo \" PARALLEL : Number of machines (default -j2)\""
            if {$vars(novus)} {
               puts $op "\t@echo \"    TOOL  : INNOVUS executable (default innovus)\""
               puts $op "\t@echo \"    ARGS  : INNOVUS arguments  (default -nowin -64)\""
            } else {
               puts $op "\t@echo \"    TOOL  : INNOVUS executable     (default innovus)\""
               puts $op "\t@echo \"    ARGS  : INNOVUS arguments      (default -nowin -64)\""
            }
            puts $op "\t@echo \" SCRIPTS  : Script directory   (default $vars(script_dir))\""
            puts $op "\t@echo \"     LOG  : Logfile directory  (default $vars(log_dir))\""
            puts $op "\t@echo \"===================================================\""
            puts $op ""
#            puts $op "flow: $vars(config_files)"
#            puts $op "\texecute_string"
#            puts $op "\t@/bin/touch \$(VPATH)/\$@"
            puts $op "assemble: top.\$(TARGET)"
            puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_assemble.tcl -log \$(LOG)/assemble.log -overwrite"
            puts $op "\t/bin/touch \$(VPATH)/assemble"
            puts $op ""
            puts $op "top.\$(TARGET) : blocks.\$(TARGET)"
            puts $op "\tcd $vars(partition_dir)/\$(TOP); \$(MAKE) -f Makefile FF_STOP=\$(FF_STOP) \$(TARGET) "
            puts $op "\t/bin/touch \$(VPATH)/\$@"
            puts $op ""
            puts $op "blocks.\$(TARGET) : partition"
            puts $op "\tcd $vars(partition_dir); VPATH=\$(VPATH); export VPATH; \$(MAKE) \$(PARALLEL) blocks FF_STOP=\$(FF_STOP) TARGET=\$(TARGET)"
            puts $op "\t/bin/touch \$(VPATH)/\$@"
            puts $op ""
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               puts $op "model_gen : setup"
               puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_model_gen.tcl -log \$(LOG)/model_gen.log -overwrite"
               puts $op "\t/bin/touch \$(VPATH)/model_gen"
               puts $op ""
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  puts $op "prototype : model_gen"
                  puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_prototype.tcl -log \$(LOG)/prototype.log -overwrite"
                  puts $op "\t/bin/touch \$(VPATH)/prototype"
                  puts $op ""
                  puts $op "partition_place : prototype"
               } else {
                  puts $op "partition_place : model_gen"
               }
            } else {
               puts $op "partition_place :  setup"
            }
            puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_partition_place.tcl -log \$(LOG)/partition_place.log -overwrite"
            puts $op "\t/bin/touch \$(VPATH)/partition_place"
            puts $op ""
            puts $op "assign_pin :  partition_place"
            puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_assign_pin.tcl -log \$(LOG)/assign_pin.log -overwrite"
            puts $op "\t/bin/touch \$(VPATH)/assign_pin"
            puts $op ""
            puts $op "partition : assign_pin"
            puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_partition.tcl -log \$(LOG)/partition.log -overwrite"
            puts $op "\t/bin/touch \$(VPATH)/partition"
            puts $op ""
            puts $op "single:"
            puts $op "\t@\$(MAKE) TARGET=single FF_STOP=\$(FF_STOP)"
            puts $op ""
            puts $op "debug_%:"
            puts $op "\texport STEP=\$* ; VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_debug.tcl -log \$(LOG)/\$@.log -win \$(ARGS:-nowin=)"
            puts $op ""
            puts $op "reset:"
            puts $op "\t@/bin/rm -f \$(VPATH)/* $vars(partition_dir)/*/\$(VPATH)/* $vars(partition_dir)/*/\$(VPATH)/.RUNNING"
            puts $op ""
            puts $op "setup:"
            puts $op "#\t/bin/rm -fr $vars(partition_dir) \$(VPATH) LOG"
            puts $op "\t/bin/mkdir -p  \$(VPATH) LOG"
            puts $op "\t/bin/touch \$(VPATH)/setup"

            if {$vars(generate_flow_steps) && [info exists vars(flow_steps)]} {
               set fp [open run_flow.tcl w]
#               puts $fp "source $vars(script_dir)/flow_steps.tcl"
               set fp1 [open $vars(script_dir)/flow_config.tcl w]
               set fp2 [open $vars(script_dir)/flow_steps.tcl w]
#               puts $fp1 "set_db flow_step:assemble .skip_db true"
#               puts $fp1 "set_db flow_step:partition .skip_db true"
               puts $fp1 "set_db flow_database_directory $vars(dbs_dir)"
               puts $fp1 "set_db flow_report_directory $vars(rpt_dir)"
               puts $fp1 "set_db flow_log_directory $vars(log_dir)"
               puts $fp1 "\nset_db flow_mail_to [exec whoami]"
               puts $fp1 "set_db flow_mail_on_error true\n"
               foreach p [concat $vars(partition_list) $vars(design)] {
#                  set vars(flow_name) $p
                  if {[file exists $vars(partition_dir)/$p/$vars(script_dir)/.hiersteps.tcl]} {
                     puts $fp2 "#-------------------------- $p --------------------------" 
                     set ip [open $vars(partition_dir)/$p/$vars(script_dir)/.hiersteps.tcl r]
                     if {$p != $vars(design)} {
                        while {[gets $ip line]>=0} { 
                           puts $fp2 $line 
                        }
                     } else {
                        while {[gets $ip line]>=0} {
                           if {[regexp "create_flow_step -name top_" $line]} {
                              puts $fp2 $line 
                              while {[gets $ip line]>=0} {
                                 if {[regexp "^\}" $line]} {
                                    puts $fp2 $line 
                                    break
                                 } else {
                                    puts $fp2 $line 
                                 }
                              }
                           }
                        }
                     }
                  }
                  if {[file exists $vars(partition_dir)/$p/run_flow.tcl]} {
                     set ip [open $vars(partition_dir)/$p/run_flow.tcl r]
                     while {[gets $ip line]>=0} { 
                        puts $fp $line 
                     }
                  }
                  if {[info exists vars(partition_dir_pass2)] && [file exists $vars(partition_dir_pass2)/$p/run_flow.tcl]} {
                     set ip [open $vars(partition_dir_pass2)/$p/run_flow.tcl r]
                     while {[gets $ip line]>=0} { 
                        puts $fp $line 
                     }
                  }
               }
               puts $fp2 "#-------------------------- HIER STEPS --------------------------" 
               puts $fp2 $vars(flow_steps,hier)
               set asteps [FF::adjust_steps]
#               set vars(flow_name) $vars(design)
#               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $asteps\]\n"
               set psteps [list]
               set bsteps [list]
               foreach s $asteps {
                  if {([lsearch $vars(fsteps) $s] != -1) && ($s != "assemble")} {
                     lappend bsteps $s
                  } else {
                     if {$s != "assemble"} {
                        lappend psteps $s
                     }
                  }
               }
               set vars(flow_name) final_assembly
               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list assemble\]\n"
               set vars(flow_name) partitioning
               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $psteps\]\n"
               unset vars(flow_steps)
#               set vars(flow_name) $vars(design)
#               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $bsteps\]\n"
               if {[file exists $vars(cwd)/.plugins]} {
                 set ip [open $vars(cwd)/.plugins r]
                 while {[gets $ip line]>=0} { 
                    puts $fp1 $line 
                 }
                 close $ip
                 file delete $vars(cwd)/.plugins 
               }
               if {![info exists vars(run_flow)]} {
                  puts $fp "source $vars(script_dir)/flow_config.tcl"
                  set vars(run_flow) DONE
               }
               close $fp
               close $fp1
               close $fp2
            }
         }
         "2pass" {
            set op1 [open Makefile.pass1 w] 
            puts $op1 "VERSION=17.10-p003_1"
            puts $op1 "VPATH=./make"
            puts $op1 "TOOL=$vars(make_tool)"
            puts $op1 "SCRIPTS=$vars(script_dir)"
            puts $op1 "LOG=$vars(log_dir)"
            puts $op1 "ARGS=$vars(make_tool_args)"
            puts $op1 "PARALLEL=-j2"
            puts $op1 "SUBMIT=\"\""
            puts $op1 "TARGET=cts"
            puts $op1 "FF_STOP=cts"
            puts $op1 "STEPS = [format "version setup %s do_cleanup" $steps]"
            puts $op1 ""
#            puts $op1 "TOP=`/bin/grep \"^set vars(design)\" $vars(setup_tcl) | /bin/awk ' { printf(\"%s\\n\",\$\$3) } '`"
            puts $op1 "TOP=$vars(design)"
            puts $op1 ""
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  puts $op1 "all: setup prototype model_gen partition_place assign_pin partition blocks.\$(TARGET) top.\$(TARGET)"
               } else {
                  puts $op1 "all: setup model_gen partition_place assign_pin partition blocks.\$(TARGET) top.\$(TARGET)"
               }
            } else {
               puts $op1 "all: setup partition_place assign_pin partition blocks.\$(TARGET) top.\$(TARGET)"
            }
            puts $op1 "\t@echo \" Makefile Targets\""
            puts $op1 "\t@echo \"===================================================\""
            puts $op1 "\t@echo \"              all : Run complete flow (default)\""
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  puts $op "\t@echo \"        prototype : Flexmodel prototype\""
               }
               puts $op "\t@echo \"        model_gen : Generate flexmodels\""
            }
            puts $op1 "\t@echo \"  partition_place : Initial placement & feedthrough\""
            puts $op1 "\t@echo \"       assign_pin : Pin assignment\""
            puts $op1 "\t@echo \"        partition : Partition design\""
            puts $op1 "\t@echo \"  blocks.<target> : Implement blocks\""
            if {$vars(enable_flexilm)} {
               puts $op1 "\t@echo \"          flexilm : PreCTS DLM flow\""
            } else {
               puts $op1 "\t@echo \"      rebudget : Rebudget constraints\""
            }
            puts $op1 "\t@echo \"===================================================\""
            puts $op1 "\t@echo \" Makefile Options\""
            puts $op1 "\t@echo \"===================================================\""
            puts $op1 "\t@echo \"   VPATH  : Make directory     (default make)\""
            puts $op1 "\t@echo \"  SUBMIT  : LSF launch command (default '')\""
            puts $op1 "\t@echo \" PARALLEL : Number of machines (default -j2)\""
            if {$vars(novus)} {
               puts $op1 "\t@echo \"    TOOL  : INNOVUS executable (default innovus)\""
               puts $op1 "\t@echo \"    ARGS  : INNOVUS arguments  (default -novus_ui -64)\""
            } else {
               puts $op1 "\t@echo \"    TOOL  : INNOVUS executable     (default innovus)\""
               puts $op1 "\t@echo \"    ARGS  : INNOVUS arguments      (default -nowin -64)\""
            }
            puts $op1 "\t@echo \" SCRIPTS  : Script directory   (default $vars(script_dir))\""
            puts $op1 "\t@echo \"     LOG  : Logfile directory  (default $vars(log_dir))\""
            puts $op1 "\t@echo \"===================================================\""
            puts $op1 ""
#            puts $op1 "flow: $vars(config_files)"
#            puts $op1 "\texecute_string"
#            puts $op1 "\t@/bin/touch \$(VPATH)/\$@"
            puts $op1 "top.\$(TARGET) : blocks.\$(TARGET)"
            puts $op1 "\tcd $vars(partition_dir)/\$(TOP); \$(MAKE) -f Makefile FF_STOP=\$(FF_STOP) \$(TARGET) "
            puts $op1 "\t/bin/touch \$(VPATH)/\$@"
            puts $op1 ""
            puts $op1 "blocks.\$(TARGET) : partition"
            puts $op1 "\tcd $vars(partition_dir); VPATH=\$(VPATH); export VPATH; \$(MAKE) \$(PARALLEL) blocks FF_STOP=\$(FF_STOP) TARGET=\$(TARGET)"
            puts $op1 "\t/bin/touch \$(VPATH)/\$@"
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  puts $op1 "prototype : setup"
                  puts $op1 "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_prototype.tcl -log \$(LOG)/prototype.log -overwrite"
                  puts $op1 "\t/bin/touch \$(VPATH)/prototype"
                  puts $op1 ""
                  puts $op1 "model_gen : prototype"
               } else {
                  puts $op1 "model_gen : setup"
               }
               puts $op1 "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_model_gen.tcl -log \$(LOG)/model_gen.log -overwrite"
               puts $op1 "\t/bin/touch \$(VPATH)/model_gen"
               puts $op1 ""
               puts $op1 "partition_place : model_gen"
            } else {
               puts $op1 "partition_place :  setup"
            }
            puts $op1 "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_partition_place.tcl -log \$(LOG)/partition_place.log -overwrite"
            puts $op1 "\t/bin/touch \$(VPATH)/partition_place"
            puts $op1 ""
            puts $op1 "assign_pin :  partition_place"
            puts $op1 "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_assign_pin.tcl -log \$(LOG)/assign_pin.log -overwrite"
            puts $op1 "\t/bin/touch \$(VPATH)/assign_pin"
            puts $op1 ""
            puts $op1 "partition :  assign_pin"
            puts $op1 "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_partition.tcl -log \$(LOG)/partition.log -overwrite"
            puts $op1 "\t/bin/touch \$(VPATH)/partition"
            puts $op1 ""
            puts $op1 "single:"
            puts $op1 "\t@\$(MAKE) TARGET=single FF_STOP=\$(FF_STOP)"
            puts $op1 ""
            puts $op1 "debug_%:"
            puts $op1 "\texport STEP=\$* ; VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_debug.tcl -log \$(LOG)/\$@.log -win \$(ARGS:-nowin=)"
            puts $op1 ""
            puts $op1 "reset:"
            puts $op1 "\t@/bin/rm -f \$(VPATH)/* $vars(partition_dir)/*/\$(VPATH)/* $vars(partition_dir)/*/\$(VPATH)/.RUNNING"
            puts $op1 ""
            puts $op1 "setup:"
            puts $op1 "#\t/bin/rm -fr $vars(partition_dir) \$(VPATH) LOG"
            puts $op1 "\t/bin/mkdir -p  \$(VPATH) LOG"
            puts $op1 "\t/bin/touch \$(VPATH)/setup"
            close $op1
            set op2 [open Makefile.pass2 w]
            puts $op2 "VERSION=17.10-p003_1"
            puts $op2 "VPATH=./make"
            puts $op2 "TOOL=$vars(make_tool)"
            puts $op2 "SCRIPTS=$vars(script_dir)"
            puts $op2 "LOG=$vars(log_dir)"
            puts $op2 "ARGS=$vars(make_tool_args)"
            puts $op2 "PARALLEL=-j2"
            puts $op2 "SUBMIT=\"\""
            puts $op2 "TARGET=signoff"
            puts $op2 "FF_STOP=signoff"
            puts $op2 "STEPS = [format "version setup %s do_cleanup" $steps]"
            puts $op2 ""
#            puts $op2 "TOP=`/bin/grep \"^set vars(design)\" $vars(setup_tcl) | /bin/awk ' { printf(\"%s\\n\",\$\$3) } '`"
            puts $op2 "TOP=$vars(design)"
            puts $op2 ""
            if {$vars(enable_flexilm)} {
               puts $op2 "all: setup rebudget blocks.\$(TARGET) top.\$(TARGET) assemble"
            } else {
               puts $op2 "all: setup rebudget blocks.\$(TARGET) top.\$(TARGET) assemble"
            }
            puts $op2 ""
            puts $op2 "help:"
            puts $op2 "\t@echo \"===================================================\""
            puts $op2 "\t@echo \"           \$(VERSION)  Foundation Flows\""
            puts $op2 "\t@echo \"===================================================\""
            puts $op2 "\t@echo \" Makefile Targets\""
            puts $op2 "\t@echo \"===================================================\""
            puts $op2 "\t@echo \"              all : Run complete flow (default)\""
            if {$vars(enable_flexilm)} {
               puts $op2 "\t@echo \"         rebudget : Rebudget design\""
            }
            puts $op2 "\t@echo \"  blocks.<target> : Implement blocks\""
            puts $op2 "\t@echo \"         assemble : Assemble design\""
            puts $op2 "\t@echo \"===================================================\""
            puts $op2 "\t@echo \" Makefile Options\""
            puts $op2 "\t@echo \"===================================================\""
            puts $op2 "\t@echo \"   VPATH  : Make directory     (default make)\""
            puts $op2 "\t@echo \"  SUBMIT  : LSF launch command (default '')\""
            puts $op2 "\t@echo \" PARALLEL : Number of machines (default -j2)\""
            if {$vars(novus)} {
               puts $op2 "\t@echo \"    TOOL  : INNOVUS executable (default innovus)\""
               puts $op2 "\t@echo \"    ARGS  : INNOVUS arguments  (default -novus_ui -64)\""
            } else {
               puts $op2 "\t@echo \"    TOOL  : INNOVUS executable     (default innovus)\""
               puts $op2 "\t@echo \"    ARGS  : INNOVUS arguments      (default -nowin -64)\""
            }
            puts $op2 "\t@echo \" SCRIPTS  : Script directory   (default $vars(script_dir))\""
            puts $op2 "\t@echo \"     LOG  : Logfile directory  (default $vars(log_dir))\""
            puts $op2 "\t@echo \"===================================================\""
            puts $op2 ""
#            puts $op2 "flow: $vars(config_files)"
#            puts $op2 "\texecute_string"
#            puts $op2 "\t@/bin/touch \$(VPATH)/\$@"
            puts $op2 "assemble: top.\$(TARGET)"
            puts $op2 "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_assemble.tcl -log \$(LOG)/assemble.log -overwrite"
            puts $op2 "\t/bin/touch \$(VPATH)/assemble"
            puts $op2 ""
            puts $op2 "top.\$(TARGET) : blocks.\$(TARGET)"
            puts $op2 "\tcd $vars(partition_dir_pass2)/\$(TOP); \$(MAKE) -f Makefile FF_STOP=\$(FF_STOP) \$(TARGET) "
            puts $op2 "\t/bin/touch \$(VPATH)/\$@"
            puts $op2 ""
            puts $op2 "blocks.\$(TARGET) : rebudget"
            puts $op2 "\tcd $vars(partition_dir_pass2); VPATH=\$(VPATH); export VPATH; \$(MAKE) \$(PARALLEL) blocks FF_STOP=\$(FF_STOP) TARGET=\$(TARGET)"
            puts $op2 "\t/bin/touch \$(VPATH)/\$@"
            puts $op2 ""
            puts $op1 "rebudget : top.cts"
            puts $op1 "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_rebudget.tcl -log \$(LOG)/rebudget.log -overwrite"
            puts $op1 "\t/bin/touch \$(VPATH)/rebudget"
            puts $op1 ""
            puts $op2 "single:"
            puts $op2 "\t@\$(MAKE) TARGET=single FF_STOP=\$(FF_STOP)"
            puts $op2 ""
            puts $op2 "debug_%:"
            puts $op2 "\texport STEP=\$* ; VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_debug.tcl -log \$(LOG)/\$@.log -win \$(ARGS:-nowin=)"
            puts $op2 ""
            puts $op2 "reset:"
            puts $op2 "\t@/bin/rm -f \$(VPATH)/* $vars(partition_dir_pass2)/*/\$(VPATH)/* $vars(partition_dir_pass2)/*/\$(VPATH)/.RUNNING"
            puts $op2 ""
            puts $op2 "setup:"
            puts $op2 "#\t/bin/rm -fr $vars(partition_dir_pass2) \$(VPATH) LOG"
            puts $op2 "\t/bin/mkdir -p  \$(VPATH) LOG"
            close $op2

            puts $op "include Makefile.pass1"
            puts $op "include Makefile.pass2"

            if {$vars(generate_flow_steps) && [info exists vars(flow_steps)]} {
               set fp1 [open $vars(script_dir)/flow_config.tcl w]
               set fp2 [open $vars(script_dir)/flow_steps.tcl w]
               puts $fp1 "set_db flow_database_directory $vars(dbs_dir)"
               puts $fp1 "set_db flow_report_directory $vars(rpt_dir)"
               puts $fp1 "set_db flow_log_directory $vars(log_dir)"
               puts $fp1 "\nset_db flow_mail_to [exec whoami]"
               puts $fp1 "set_db flow_mail_on_error true\n"
#               puts $fp $vars(flow_steps)
               foreach p [concat $vars(partition_list) $vars(design)] {
#                  set vars(flow_name) $p
                  if {[file exists $vars(partition_dir)/$p/$vars(script_dir)/.hiersteps.tcl]} {
#                     puts $fp2 "#-------------------------- $p --------------------------" 
                     set ip [open $vars(partition_dir)/$p/$vars(script_dir)/.hiersteps.tcl r]
                     if {$p != $vars(design)} {
                        while {[gets $ip line]>=0} { 
                           puts $fp2 $line 
                        }
                     } else {
                        while {[gets $ip line]>=0} {
                           if {[regexp "create_flow_step -name top_" $line]} {
                              puts $fp2 $line 
                              while {[gets $ip line]>=0} {
                                 if {[regexp "^\}" $line]} {
                                    puts $fp2 $line 
                                    break
                                 } else {
                                    puts $fp2 $line 
                                 }
                              }
                           }
                        }
                     }
                  }
                  if {[file exists $vars(partition_dir)/$p/run_flow.tcl]} {
                     set ip [open $vars(partition_dir)/$p/run_flow.tcl r]
                     while {[gets $ip line]>=0} { 
                        puts $fp $line 
                     }
                  }
                  if {[info exists vars(partition_dir_pass2)] && [file exists $vars(partition_dir_pass2)/$p/run_flow.tcl]} {
                     set ip [open $vars(partition_dir_pass2)/$p/run_flow.tcl r]
                     while {[gets $ip line]>=0} { 
                        puts $fp $line 
                     }
                  }
               }
               puts $fp2 "#-------------------------- HIER STEPS --------------------------" 
               puts $fp2 $vars(flow_steps,hier)
               set vars(flow_name) $vars(design)
               set asteps [FF::adjust_steps]
#               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $asteps\]\n"
               set psteps [list]
               set bsteps [list]
               foreach s $asteps {
                  if {([lsearch $vars(fsteps) $s] != -1) && ($s != "assemble")} {
                     lappend bsteps $s
                  } else {
                     if {$s != "assemble"} {
                        lappend psteps $s
                     }
                  }
               }
               set vars(flow_name) final_assembly
               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list assemble\]\n"
               set vars(flow_name) partitioning
               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $psteps\]\n"
#               puts $fp "run_flow -flow $vars(flow_name)"
               unset vars(flow_steps)
#               set vars(flow_name) $vars(design)
#               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $bsteps\]\n"
               if {[file exists $vars(cwd)/.plugins]} {
                  set ip [open $vars(cwd)/.plugins r]
                  while {[gets $ip line]>=0} { 
                     puts $fp1 $line 
                  }
                  close $ip
                  file delete $vars(cwd)/.plugins 
               }
               close $fp
               close $fp1
               close $fp2
            }
         }
         "flexilm" {
            puts $op "VERSION=17.10-p003_1"
            puts $op "VPATH=./make"
            puts $op "TOOL=$vars(make_tool)"
            puts $op "SCRIPTS=FF"
            puts $op "LOG=LOG"
            puts $op "ARGS=$vars(make_tool_args)"
            puts $op "PARALLEL=-j2"
            puts $op "SUBMIT=\"\""
            puts $op "TARGET=assemble"
            puts $op "FF_STOP=assemble"
            puts $op "STEPS = version setup do_cleanup"
            puts $op ""
#            puts $op "TOP=`/bin/grep \"^set vars(design)\" $vars(setup_tcl) | /bin/awk ' { printf(\"%s\\n\",\$\$3) } '`"
            puts $op "TOP=$vars(design)"
            puts $op ""
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  puts $op "all: setup prototype model_gen partition_place assign_pin partition blocks.prects top.prects assemble_flexilm blocks.signoff top.signoff assemble"
               } else {
                  puts $op "all: setup model_gen partition_place assign_pin partition blocks.prects top.prects assemble_flexilm blocks.signoff top.signoff assemble"
               }
            } else {
               puts $op "all: setup partition_place assign_pin partition blocks.prects top.prects assemble_flexilm blocks.signoff top.signoff assemble"
            }

            puts $op ""
            puts $op "help:"
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"           \$(VERSION)  Foundation Flows\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \" Makefile Targets\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"              all : Run complete flow (default)\""
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  puts $op "\t@echo \"        prototype : Flexmodel prototype\""
               }
               puts $op "\t@echo \"        model_gen : Generate flexmodels\""
            }
            puts $op "\t@echo \"  partition_place : Initial placement & feedthrough\""
            puts $op "\t@echo \"       assign_pin : Pin assignment\""
            puts $op "\t@echo \"        partition : Partition design\""
            puts $op "\t@echo \"     block.prects : Implement blocks to preCTS and generate flexIlm\""
            puts $op "\t@echo \"       top.prects : flexIlm prects optimization and flexIlm ECO\""
            puts $op "\t@echo \" assemble_flexilm : Check assembled preCTS timing\""
            puts $op "\t@echo \"    block.signoff : implement blocks\""
            puts $op "\t@echo \"      top.signoff : implement top\""
            puts $op "\t@echo \"         assemble : final chip assembly\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \" Makefile Options\""
            puts $op "\t@echo \"===================================================\""
            puts $op "\t@echo \"   VPATH  : Make directory     (default make)\""
            puts $op "\t@echo \"  SUBMIT  : LSF launch command (default '')\""
            puts $op "\t@echo \" PARALLEL : Number of machines (default -j2)\""
            if {$vars(novus)} {
               puts $op "\t@echo \"    TOOL  : INNOVUS executable (default innovus)\""
               puts $op "\t@echo \"    ARGS  : INNOVUS arguments  (default -novus_ui -64)\""
            } else {
               puts $op "\t@echo \"    TOOL  : INNOVUS executable     (default innovus)\""
               puts $op "\t@echo \"    ARGS  : INNOVUS arguments      (default -nowin -64)\""
            }
            puts $op "\t@echo \" SCRIPTS  : Script directory   (default FF)\""
            puts $op "\t@echo \"     LOG  : Logfile directory  (default LOG)\""
            puts $op "\t@echo \"===================================================\""
            puts $op "assemble: top.signoff"
            puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_assemble.tcl -log \$(LOG)/assemble.log -overwrite"
            puts $op "\t/bin/touch \$(VPATH)/assemble"
            puts $op ""
            puts $op "top.signoff : blocks.signoff"
            puts $op "\tcd PARTITION_PRECTS/\$(TOP); \$(MAKE) -f Makefile FF_STOP=signoff signoff"
            puts $op "	/bin/touch \$(VPATH)/\$@"
            puts $op ""
            puts $op "blocks.signoff : assemble_flexilm"
            puts $op "\tcd PARTITION_PRECTS; VPATH=\$(VPATH); export VPATH; \$(MAKE) \$(PARALLEL) blocks FF_STOP=signoff TARGET=signoff"
            puts $op "	/bin/touch \$(VPATH)/\$@"
            puts $op ""
            puts $op "assemble_flexilm : top.prects"
            puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_assemble_flexilm.tcl -log \$(LOG)/assemble_flexilm.log -overwrite"
            puts $op "\t/bin/touch \$(VPATH)/assemble_flexilm"
            puts $op ""
            puts $op "top.prects : blocks.prects"
            if {$vars(place_opt_design)} {
               puts $op "\tcd PARTITION/\$(TOP); \$(MAKE) -f Makefile FF_STOP=place place "
            } else {
               puts $op "\tcd PARTITION/\$(TOP); \$(MAKE) -f Makefile FF_STOP=prects prects "
            }
            puts $op "\t/bin/touch \$(VPATH)/\$@"
            puts $op "\t/bin/cp -rf PARTITION_FLEXILM/* PARTITION_PRECTS"
            puts $op "\t/bin/rm -rf PARTITION_FLEXILM"
            puts $op ""
            puts $op "blocks.prects : partition"
            if {$vars(place_opt_design)} {
               puts $op "\tcd PARTITION; VPATH=\$(VPATH); export VPATH; \$(MAKE) \$(PARALLEL) blocks FF_STOP=place TARGET=place"
            } else {
               puts $op "\tcd PARTITION; VPATH=\$(VPATH); export VPATH; \$(MAKE) \$(PARALLEL) blocks FF_STOP=prects TARGET=prects"
            }
            puts $op "\t/bin/touch \$(VPATH)/\$@"
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  puts $op "prototype : setup"
                  puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_prototype.tcl -log \$(LOG)/prototype.log -overwrite"
                  puts $op "\t/bin/touch \$(VPATH)/prototype"
                  puts $op ""
                  puts $op "model_gen : prototype"
               } else {
                  puts $op "model_gen : setup"
               }
               puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_model_gen.tcl -log \$(LOG)/model_gen.log -overwrite"
               puts $op "\t/bin/touch \$(VPATH)/model_gen"
               puts $op ""
               puts $op "partition_place : model_gen"
            } else {
               puts $op "partition_place :  setup"
            }
            puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_partition_place.tcl -log \$(LOG)/partition_place.log -overwrite"
            puts $op "\t/bin/touch \$(VPATH)/partition_place"
            puts $op ""
            puts $op "assign_pin :  partition_place"
            puts $op "	VPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_assign_pin.tcl -log \$(LOG)/assign_pin.log -overwrite"
            puts $op "	/bin/touch \$(VPATH)/assign_pin"
            puts $op ""
            puts $op "partition :  assign_pin"
            puts $op "\tVPATH=\$(VPATH); export VPATH; \$(TOOL) \$(ARGS) -init \$(SCRIPTS)/INNOVUS/run_partition.tcl -log \$(LOG)/partition.log -overwrite"
            puts $op "	/bin/touch \$(VPATH)/partition"
            puts $op ""
            puts $op "single:"
            puts $op "\t@\$(MAKE) TARGET=single FF_STOP=signoff"
            puts $op ""
            puts $op "debug_%:"
            puts $op "\texport STEP=\$* ; VPATH=\$(VPATH); export VPATH; \$(TOOL) -init \$(SCRIPTS)/INNOVUS/run_debug.tcl -log \$(LOG)/\$@.log -win \$(ARGS:-nowin=)"
            puts $op ""
            puts $op "reset:"
            puts $op "\t@/bin/rm -f \$(VPATH)/* PARTITION/*/\$(VPATH)/* PARTITION/*/\$(VPATH)/.RUNNING"
            puts $op "\t@/bin/rm -f \$(VPATH)/* PARTITION_PRECTS/*/\$(VPATH)/* PARTITION_PRECTS/*/\$(VPATH)/.RUNNING"
            puts $op ""
            puts $op "setup:"
            puts $op "#\t/bin/rm -fr PARTITION \$(VPATH) LOG"
            puts $op "\t/bin/mkdir -p  \$(VPATH) LOG"
            puts $op "\t/bin/touch \$(VPATH)/setup"

            if {$vars(generate_flow_steps) && [info exists vars(flow_steps)]} {
               set fp [open run_flow.tcl w]
               if {![info exists vars(run_flow)]} {
#                  puts $fp "source $vars(script_dir)/flow_steps.tcl"
                  puts $fp "source $vars(script_dir)/flow_config.tcl"
                  set vars(run_flow) DONE
               }
               set fp1 [open $vars(script_dir)/flow_config.tcl w]
               set fp2 [open $vars(script_dir)/flow_steps.tcl w]
               puts $fp1 "set_db flow_database_directory $vars(dbs_dir)"
               puts $fp1 "set_db flow_report_directory $vars(rpt_dir)"
               puts $fp1 "set_db flow_log_directory $vars(log_dir)"
               puts $fp1 "\nset_db flow_mail_to [exec whoami]"
               puts $fp1 "set_db flow_mail_on_error true\n"
#               puts $fp $vars(flow_steps)
               foreach p [concat $vars(partition_list) $vars(design)] {
#                  set vars(flow_name) $p
                  if {[file exists $vars(partition_dir)/$p/$vars(script_dir)/.hiersteps.tcl]} {
#                     puts $fp2 "#-------------------------- $p --------------------------" 
                     set ip [open $vars(partition_dir)/$p/$vars(script_dir)/.hiersteps.tcl r]
                     if {$p != $vars(design)} {
                        while {[gets $ip line]>=0} { 
                           puts $fp2 $line 
                        }
                     } else {
                        while {[gets $ip line]>=0} {
                           if {[regexp "create_flow_step -name top_" $line]} {
                              puts $fp2 $line 
                              while {[gets $ip line]>=0} {
                                 if {[regexp "^\}" $line]} {
                                    puts $fp2 $line 
                                    break
                                 } else {
                                    puts $fp2 $line 
                                 }
                              }
                           }
                        }
                     }
                  }
                  if {[file exists $vars(partition_dir)/$p/run_flow.tcl]} {
                     set ip [open $vars(partition_dir)/$p/run_flow.tcl r]
                     while {[gets $ip line]>=0} { 
                        puts $fp $line 
                     }
                  }
                  if {[info exists vars(partition_dir_pass2)] && [file exists $vars(partition_dir_pass2)/$p/run_flow.tcl]} {
                     set ip [open $vars(partition_dir_pass2)/$p/run_flow.tcl r]
                     while {[gets $ip line]>=0} { 
                        puts $fp $line 
                     }
                  }
               }
               puts $fp2 "#-------------------------- HIER STEPS --------------------------" 
               puts $fp2 $vars(flow_steps,hier)
               set vars(flow_name) $vars(design)
               set asteps [FF::adjust_steps]
#               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $asteps\]\n"
               set psteps [list]
               set bsteps [list]
               foreach s $asteps {
                  if {([lsearch $vars(fsteps) $s] != -1) && ($s != "assemble")} {
                     lappend bsteps $s
                  } else {
                     if {![regexp "^assemble" $s]} {
                        lappend psteps $s
                     }
                  }
               }
               set vars(flow_name) intermediate_assembly
               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list assemble_flexilm\]\n"
               set vars(flow_name) final_assembly
               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list assemble\]\n"
               set vars(flow_name) partitioning
               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $psteps\]\n"
#               puts $fp "run_flow -flow $vars(flow_name)"
               unset vars(flow_steps)
#               set vars(flow_name) $vars(design)
#               puts $fp "create_flow \\\n   -name $vars(flow_name)\\\n   -tool $vars(make_tool)\\\n   -tool_options {-log $vars(flow_name).log}\\\n   \[list $bsteps\]\n"
               if {[file exists $vars(cwd)/.plugins]} {
                  set ip [open $vars(cwd)/.plugins r]
                  while {[gets $ip line]>=0} { 
                     puts $fp1 $line 
                  }
                  close $ip
                  file delete $vars(cwd)/.plugins 
               }
               close $fp
               close $fp1
               close $fp2
            }
         }
      }

      close $op

   }

   proc set_steps {mode format} {
      #
      # Sets the vars() array based on the mode/format passed in
      #

      global vars
      global errors

      if {$mode == "hier" } {
         set mode "top_down"
         if {$vars(hier_flow_type) == "2pass"} {
            set mode "2pass"
         }
      }

      switch $mode {
         "user" {
            if {![info exists vars(steps)]} {
               puts "<FF> ERROR: For user mode, vars(steps) must be provided"
               exit
            }
         }
         "flat" {
            set vars(steps) [list "init" "place" "prects" "cts" "postcts" \
                                  "postcts_hold" "route" "postroute" \
                                  "postroute_hold" "postroute_si_hold" \
                                  "postroute_si" "signoff"]
            if {$vars(preroute_opt_design)} {
               set vars(steps) [lreplace $vars(steps) [lsearch $vars(steps) "place"] [lsearch $vars(steps) "cts"] preroute]
            }
#            if {$vars(route_opt_design)} {
#               set vars(steps) [lreplace $vars(steps) [lsearch $vars(steps) "route"] [lsearch $vars(steps) "postroute"] route_opt_design]
#            }
            if $vars(rc) {
               if {$vars(enable_rcp)} { 
                  set vars(steps) [concat "syn_map" "syn_incr" "syn_place" $vars(steps)]
               } else {
                  set vars(steps) [concat "syn_map" "syn_incr" $vars(steps)]
               }
            }
         }

         "top_down" {
               set vars(steps) [list "partition_place" "assign_pin" "partition" "init" "place" "prects" \
                                "cts" "postcts" "postcts_hold" "route" \
                                "postroute" "postroute_hold" \
                                "postroute_si_hold" "postroute_si" \
                                "signoff" "assemble"]
               set vars(hsteps) [list "assemble" "partition_place" "assign_pin" "partition"]
               if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
                  # Insert the model_gen step before partition_place
                  foreach varname {steps hsteps} {
                     set old $vars($varname)
                     set vars($varname) [linsert $old [lsearch $old "partition_place"] "model_gen"]
                  }
                  if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                     # Insert the prototype step before partition_place
                     foreach varname {steps hsteps} {
                        set old $vars($varname)
                        set vars($varname) [linsert $old [lsearch $old "partition_place"] "prototype"]
                     }
                  }
               }

               set vars(fsteps) [list "init" "place" "prects" "cts" "postcts" \
                                "postcts_hold" "route" "postroute" \
                                "postroute_hold" "postroute_si_hold" \
                                "postroute_si" "signoff"]
         }
         "1pass" {
               set vars(steps) [list "partition_place" "assign_pin" "partition" "init" "place" "prects" \
                                "cts" "postcts" "postcts_hold" "route" \
                                "postroute" "postroute_hold" \
                                "postroute_si_hold" "postroute_si" \
                                "signoff" "assemble"]
               set vars(hsteps) [list "assemble" "partition_place" "assign_pin" "partition"]
               set vars(fsteps) [list "init" "place" "prects" "cts" "postcts" \
                                "postcts_hold" "route" "postroute" \
                                "postroute_hold" "postroute_si_hold" \
                                "postroute_si" "signoff"]
         }
         "2pass" {
            if {$vars(enable_flexilm)} {
               set vars(steps) [list "partition_place" "assign_pin" "partition" "init" "place" "prects" "assemble_flexilm" \
                                     "cts" "postcts" "postcts_hold" "route" \
                                     "postroute" "postroute_hold" \
                                     "postroute_si_hold" "postroute_si" \
                                     "signoff" "assemble"]
               set vars(hsteps) [list "assemble" "assemble_flexilm" "partition_place" "assign_pin" "partition"]
            } else {
               set vars(steps) [list "partition_place" "assign_pin" "partition" "init" "place" "prects" \
                                     "cts" "rebudget" "postcts" "postcts_hold" "route" \
                                     "postroute" "postroute_hold" \
                                     "postroute_si_hold" "postroute_si" \
                                     "signoff" "assemble"]
               set vars(hsteps) [list "assemble" "rebudget" "partition_place" "assign_pin" "partition"]
            }
            if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
               # Insert the model_gen step before partition_place
               foreach varname {steps hsteps} {
                  set old $vars($varname)
                  set vars($varname) [linsert $old [lsearch $old "partition_place"] "model_gen"]
               }
               if {[info exists vars(flexmodel_prototype)] && $vars(flexmodel_prototype)} {
                  # Insert the prototype step before partition_place
                  foreach varname {steps hsteps} {
                     set old $vars($varname)
                     set vars($varname) [linsert $old [lsearch $old "partition_place"] "prototype"]
                  }
               }
            }
            set vars(fsteps) [list "init" "place" "prects" "cts" "postcts" \
                                   "postcts_hold" "route" "postroute" \
                                   "postroute_hold" "postroute_si_hold" \
                                   "postroute_si" "signoff"]
         }
         "bottom_up" {
            set vars(steps) [list "init" "place" "prects" "cts" "postcts" \
                                  "postcts_hold" "route" "postroute" \
                                  "postroute_hold" "postroute_si_hold" \
                                  "postroute_si" "signoff" "assemble"]
            set vars(hsteps) [list "assemble"]
            set vars(fsteps) [list "init" "place" "prects" "cts" "postcts" \
                                   "postcts_hold" "route" "postroute" \
                                   "postroute_hold" "postroute_si_hold" \
                                   "postroute_si" "signoff"]
         }

         "default" {
            puts "Internal error: Unknown mode \"$vars(mode)\".  Aborting."
            exit -111
         }
      }

      if {!$vars(enable_celtic_steps) } {
         foreach step [list "postroute_si" "postroute_si_hold"] {
            set index [lsearch $vars(steps) $step]
            if {$index != -1} {
               set vars(steps) [lreplace $vars(steps) $index $index]
            }
         }
      }
   }

  proc flatten_curlies_in_list list {string map {\{ "" \} ""} $list}

  #
  # gen_incr_filename(scriptNameBase)
  # Buda Leung, 11/2011
  # args:
  #  $scriptNameBase: <path>/basename of dir
  # @return: new base name
  #
  # Description: Generates a new output file name using the input
  # argument as a basename. This proc looks for all files in the
  # same directory as the argument with a matching basename.
  # It then looks for a trailing integer suffix, and compares
  # all matching files to find the largest integer. 
  # It returns a new file name of the form <path>/<basename><largest int + 1>
  #
  # Example Usage: input argument setup.tcl
  # files in dir: setup.tcl setup.tcl1
  # @return: setup.tcl2
  #

  proc gen_incr_filename {scriptNameBase} {
    set file_list [glob -nocomplain [set scriptNameBase]*]
    if {[llength $file_list] > 0} {
      set highNum 1
      foreach file $file_list {
        set re "[set scriptNameBase](\[\[:digit:\]\]+)\$"
        if {[regexp $re $file full num]} {
          if {$num >= $highNum} {
            set highNum [incr num]
          }
        }
      }
      set scriptName $scriptNameBase$highNum
    } else {
      set scriptName "[set scriptNameBase]"
    }
    return $scriptName
  }

  #
  # gen_new_rundir {args}
  # Buda Leung, 11/2011
  # args:
  #  -dir <string>: dir name to change
  #  -style [increment|date|custom]: naming style to use [increment|date|custom]
  #  -date_style <string> (required when style=date): tcl commands to create a date string
  #  -custom <string> (optional): a custom string to prepend or postpend to the dir
  #  -name_change_order [prefix|suffix] (required when customString is defined): [prefix|suffix]
  # @return: new dir name
  #
  # Description: Generates a new directory name based on the basename
  # and options provided. The options allowed are:
  #
  # style:
  #  * increment: add an integer to the rundir based on dirs found in [dirname $dir]
  #  * date: add a date string to the rundir name, using vars(date_style) to control the formatting
  #  * custom: add a custom string to the rundir name
  # nameChangeOrder:   
  #  * prefix: add the custom string to the beginning of the rundir
  #  * suffix: add the custom string to the end of the rundir
  #
  # NOTE: increment, date, and custom are mutually exclusive options
  #
  # Example Usage: 
  # gen_new_rundir work/run increment
  # (dirs with matching basename : work/run1 work/run2)
  # @return: work/run3
  #
  # gen_new_rundir work/run date
  # @return: work/run_2011-11-23_12_09_58 
  #
  # gen_new_rundir work/run custom rcp_high_eff prefix
  # @return: work/rcp_high_eff_run

  proc gen_new_rundir {argv} {

      global vars
      global dargs
      global fargs
      #
      # Proc defaults
      # Note that defaults live in the default_setup.tcl, but when gen_new_rundir is called, that setup.tcl has not yet been loaded
      # These defaults must stay synchronized to  the default_setup.tcl vars() equivalents
      #
      set def_date_style                                 "\[clock format \[clock seconds\] -format \"%Y-%m-%d_%H_%M_%S\" \]"
      # Use the following if you want a custom prefix/suffix added to the rundir
      set def_custom_rundir_name_append                  ""
      # vars(rundir_namechange_method) [prefix|suffix]
      set def_rundir_namechange_method                   "suffix"

      #
      # Arg processing
      #

      while {[llength $argv] > 0} {
         set option [lindex $argv 0]
         set argv [lreplace $argv 0 0]
         switch -regexp -- $option {
            ^-(d|-dir)$ {
               set dash_d_script_dir [lindex $argv 0]
               set argv [lreplace $argv 0 0]
            }
            ^-(y|-style)$ {
              set dash_y_style_type [lindex $argv 0]
              set argv [lreplace $argv 0 0]
            }
            ^-(u|-rundir)$ {
               set dash_u_rundir_base [lindex $argv 0]
               set argv [lreplace $argv 0 0]
            }
         }
      } ; # end while (processing args)

      set dbgMsg "<FF-INT> gen_new_rundir(): "

      #
      # Load vars. This will overwrite any FF defaults, but not the -u/-y options
      # Only looking for the following:
      # vars(rundir_base) (-u takes precedence) 
      # vars(rundir) - overrides vars(rundir_base) and -u/-y
      # vars(auto_increment_rundir_style) (-y takes precedence)
      # vars(date_style) (no gen_innovus_flow.tcl option)
      # vars(custom_rundir_name_append) (no gen_innovus_flow.tcl option)
      # vars(rundir_namechange_method) (no gen_innovus_flow.tcl option)
      #
      FF_NOVUS::execute_flow "source_only" true ""
   
      # NOTE: after the above executes, dargs and fargs have all been analyzed, and vars exist for all those entries
      # in other words, we no longer care about dargs(rundir), only vars(rundir)...
   
      # In case the user defined these in their setup.tcl
      if {![info exists vars(date_style)]} {
         set date_style $def_date_style
      }
      if {![info exists vars(custom_rundir_name_append)]} {
         set vars(custom_rundir_name_append) $def_custom_rundir_name_append
      }
      if {![info exists vars(rundir_namechange_method)]} {
         set vars(rundir_namechange_method) $def_rundir_namechange_method
      }
   
      #
      # Set the rundir original name
      # Priority:
      # 1) vars(rundir)
      # 2) dash_u_rundir_base
      # 3) vars(rundir_base)
      # 4) def_rundir
   
      # if vars(rundir) eq dargs(rundir), then basically the user has not specified a vars(rundir), or they set it to .
      # use file normalize to handle "./" vs "."
      if {[file normalize $vars(rundir)] eq [file normalize $dargs(rundir)]} {
        if {![info exists dash_u_rundir_base]} {
           if {![info exists vars(rundir_base)]} {
             set rundir_origname $dargs(rundir)
           } else {
             set rundir_origname $vars(rundir_base)
           } 
         } else {
           if {[info exists vars(rundir_base)] && $vars(rundir_base) ne $dash_u_rundir_base} {
             # Conflict between -u and setup.tcl. -u wins
             puts "<FF> WARNING \"-u $dash_u_rundir_base\" overriding config variable vars(rundir_base) ($vars(rundir_base))"
             puts "             To prevent this behavior, do not use the \"-u\" option (FF will use vars(rundir_base) from your config file)."
           }
           set rundir_origname $dash_u_rundir_base
         } 
      } else {
         # The following handle conflicts between vars(rundir) and -u or vars(rundir_base)
         if {[info exists dash_u_rundir_base]} { 
           if {$vars(rundir) ne $dargs(rundir) && $vars(rundir) ne $dash_u_rundir_base} {
             puts "<FF> WARNING vars(rundir) \"$vars(rundir)\" overriding \"-u $dash_u_rundir_base\" option."
             puts "             To prevent this behavior, do not set vars(rundir) in your config file."
           } elseif {[info exists vars(rundir_base)]} {
             puts "<FF> WARNING vars(rundir) \"$vars(rundir)\" overriding config variable vars(rundir_base) \"$vars(rundir_base)\""
             puts "             To prevent this behavior, do not set vars(rundir) in your config file."
           }
         }
         set rundir_origname $vars(rundir)
      }
      #
      # Set the rundir naming style
      # Priority:
      # 1) vars(auto_increment_rundir_style)
      # 2) dash_y_style_type
      # 3) def_auto_increment_rundir_style
       
      if {![info exists vars(auto_increment_rundir_style)]} {
         if {![info exists dash_y_style_type]} {
           set styleType $dargs(style)
         } else {
           set styleType $dash_y_style_type
         } 
      } else { 
         # vars(auto_increment_rundir_style) was set in the setup.tcl
         if {[info exists dash_y_style_type] && $dash_y_style_type ne $vars(auto_increment_rundir_style)} {
           # Conflict between -y and setup.tcl. -y wins
           puts "<FF> WARNING \"-y $dash_y_style_type\" overriding config variable vars(auto_increment_rundir_style) ($vars(auto_increment_rundir_style))"
           puts "             To prevent this behavior, do not use the \"-y\" option (FF will use vars(auto_increment_rundir_style) from your config file)."
         set styleType $dash_y_style_type
         } else {
           set styleType $vars(auto_increment_rundir_style)
         }
      }
   
      #
      # If increment is specified, -u / vars(rundir) is required ; otherwise error and exit:
      #
      if {$styleType eq "increment" && ([file tail $rundir_origname] eq "" || [file normalize $rundir_origname] eq [file normalize .])} {
         puts "<FF> ERROR: Rundir naming style was set to \"increment\", but rundir evaluated to \".\" due to:"
         if {[info exists vars(rundir)] && [file normalize $vars(rundir)] eq [file normalize .]} { 
           puts "            setting vars(rundir) to \"$vars(rundir)\" in your configuration file."
         } elseif {[info exists dash_u_rundir_base] && [file normalize $dash_u_rundir_base] eq [file normalize .]} { 
           puts "            the \"-u\" $dash_u_rundir_base argument to gen_innovus_flow.tcl"
         } elseif {[info exists vars(rundir_base)] && [file normalize $vars(rundir_base)] eq [file normalize .]} { 
           puts "            setting vars(rundir_base) to \"$vars(rundir_base)\" in your configuration file."
         } else {
           puts "            the default rundir setting which is \"$def_rundir\""
         }
         puts "            To prevent this error, use the -u argument to specify a rundir base, or specify a vars(rundir_base) in your setup.tcl"
         exit 99
      }
   
      # 
      # Generate new rundir if valid style defined
      # 
   
      #  -date_style <string> (required when style=date): tcl commands to create a date string
      #  -custom <string> (optional): a custom string to prepend or postpend to the dir
      #  -name_change_order [prefix|suffix] (required when customString is defined): [prefix|suffix]
   
      # Remove any "//" in the path
      regsub -all {\/\/} $rundir_origname {/} rundir_origname
   
      set rundir_basename [file tail $rundir_origname]
      set rundir_dirname [file dirname $rundir_origname]
   
      if {$styleType ne "none"} {
         switch -exact -- $styleType {
           date {
             if {$vars(rundir_namechange_method) eq "prefix"} {
               set new_basename [subst $date_style]_${rundir_basename}
             } elseif {$vars(rundir_namechange_method) eq "suffix"} {
               set new_basename ${rundir_basename}_[subst $date_style]
             }
           }
           increment {
             set new_basename [file tail [FF::gen_incr_filename $rundir_origname]]
           }
           custom {
             if {$vars(custom_rundir_name_append) ne ""} {
               if {$vars(rundir_namechange_method) eq "prefix"} {
                 set new_basename [subst $vars(custom_rundir_name_append)]_${rundir_basename}
               } elseif {$vars(rundir_namechange_method) eq "suffix"} {
                 set new_basename ${rundir_basename}_[subst $vars(custom_rundir_name_append)]
               }
             } else {
               puts "<FF> NOTE: vars(custom_rundir_name_append) set to \"\". No modification to rundir will occur."
               set new_basename $rundir_basename
             }
           }
           default {
             # This should never happen! (indicates incorrect usage within gen_innovus_flow.tcl!)    
             puts "$dbgMsg WARNING: Unknown option for styleType. Using default (none)"
           }
         }
         set vars(rundir) [file normalize [join "$rundir_dirname $new_basename" "/"]]
         set vars(new_rundir_basename) $new_basename
      } else {
         set vars(rundir) [file normalize $rundir_origname]
      }
      return $vars(rundir) 
   };# end proc gen_new_rundir

  proc relPathTo {target current} {
    #puts "calling relPathTo $target $current"
    set cc [file split [file normalize $current]]
    set tt [file split [file normalize $target]]
    if {![string equal [lindex $cc 1] [lindex $tt 1]]} {
        # not on *n*x then
        #return -code error "FF::relPathTo(): ERROR $target not on same volume as $current"
        return [file normalize $target] 
    }
    set prefix ""
    while {[string equal [lindex $cc 0] [lindex $tt 0]] && [llength $cc] > 0} {
      # discard matching components from the front (but don't
      # do the last component in case the two files are the same)
      set cc [lreplace $cc 0 0]
      set tt [lreplace $tt 0 0]
    }

    #if {[llength $cc] == 1} {
    #  # just the file name, so target is lower down (or in same place)
    #  set prefix "."
    #}   
    # step up the tree (start from 1 to avoid counting file itself
    for {set i 1} {$i <= [llength $cc]} {incr i} {
        append prefix " .."
    }
    # stick it all together (the eval is to flatten the target list)
    if {$cc eq $tt} {
      return "."
    } else {
      return [eval file join $prefix $tt]
    }
  }

  proc flatten_list list {string map {\{ "" \} ""} $list}
  proc remove_outer_braces {args} {
    if {[regsub {^\{} $args "" tmp]} {set args $tmp}
    if {[regsub {\}$} $args "" tmp]} {set args $tmp}
    return $args
  }

  proc relativizeFileOrDir {args} {
    #puts "relativizeFileOrDir $args"
    set NewDirName ""
    set arrName "vars"
    set VarDirName ""
    set skipVariableUsageInReference 0
    set mustExist 0
    set skipList {}
    set exactVar ""
    set exactSubDirMatch ""
    set varToSub ""
    set skipDirList ""

    while {[llength $args] > 0} {
      set option [lindex $args 0]
      set args [lreplace $args 0 0]
      switch -exact -- $option {
         -arr {
            set arrName [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         -vardir {
            set VarDirName [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         -newdir {
           set NewDirName [lindex $args 0]
           set args [lreplace $args 0 0]
         }
         -skipVariableUsageInReference {
            set skipVariableUsageInReference 1
         }
         -mustExist {
            set mustExist 1
         }
         -skipVar {
            lappend skipList [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         -skipDir {
            lappend skipDirList [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         -var {
            set varToSub [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         -exactSubDirMatch {
            set exactSubDirMatch [lindex $args 0]
            set args [lreplace $args 0 0]
         }
      }
    };# end while (processing args)

    # Always skip the VarDirName when analyzing variables in the array
    lappend skipList $VarDirName

    # Need to convert a list of files to relative paths (TBD)
    global $arrName
    # Check if the vardir (key) exists in the array. If not, exit
    if {$VarDirName eq ""} {
      return -code error "relativizeFileOrDir() called w/out -vardir argument. Exiting ..."
    }
    if {$NewDirName eq ""} {
      set NewDirName $VarDirName
    }

    set relativizeConvMesgList {}
    if {[info exists ${arrName}($VarDirName)]} {
      foreach arg [lsort -dictionary [array names $arrName]] {
        if {$varToSub eq "" || $varToSub eq $arg} {
          # foreach key (entry) in the array, look for files/folders
          set re ""
          #puts "lsearch $skipList $arg"
          # First check black list
          if {[lsearch $skipList $arg] == -1} {
            if {![regexp {\[} [set ${arrName}($arg)]]} {
              # only continue if the variable is not the vardir (key) itself, and the value of the variable doesn't have a $ in it
              #puts "relativizeFileOrDir() checking ${arrName}($arg) (current: ->[set ${arrName}($arg)]<-)"
              set tmpValue ""
              #
              # Process all members of the $arrName(arg) (could be a list), and subst each one
              #
              set fileFound 0
              set re "[file normalize [set ${arrName}($VarDirName)]]\/(.*)"
              foreach possibleFile [set ${arrName}($arg)] {
                if {$mustExist} {
                  # The file or dir must exist after normalization
                  #puts "Checking for existence of [file normalize [subst $possibleFile]]"
                  if {![catch {file exists [file normalize [subst $possibleFile]]}]} {
                    if {[file exists [file normalize [subst $possibleFile]]]} {
                      #puts "Exists: [file normalize [subst $possibleFile]]"
                      set file [file normalize [subst $possibleFile]]
                      set size [file size $file]
                      set mtime [file mtime $file]
                      set type [file type $file]
                      #puts "file $file size: $size, mtime: $mtime type: $type"
                    set fileFound 1
                    #puts "Checking for path to file: ->[file normalize [subst $possibleFile]]<- from ->[file normalize [set ${arrName}($VarDirName)]]<-"
                    set relPathValue [relPathTo [file normalize [subst $possibleFile]] [file normalize [subst [set ${arrName}($VarDirName)]]]]
                      #puts "relPathValue: $relPathValue"
                    set skipDueToSkipDir 0
                    if {$skipDirList ne ""} {
                      foreach dir $skipDirList {
                        set re3 "[file normalize [subst $dir]]/(.*)"
                        if {[regexp $re3 [file normalize [subst $possibleFile]] full relativePortion]} {
                          set skipDueToSkipDir 1
                        }
                      }
                    }
                    if {!$skipDueToSkipDir} {
                        if {$exactSubDirMatch ne ""} {
                          set re2 "$exactSubDirMatch/(.*)"
                          # the normalized path of the possible file has to match the normalized path of the subdir...
                        if {[regexp $re2 [file normalize [subst $possibleFile]] full relativePortion]} {
                            if {$relPathValue ne [file normalize $possibleFile]} {
                            if {$skipVariableUsageInReference} {
                              lappend tmpValue $relPathValue
                            } else {
                              lappend tmpValue "\$${arrName}($VarDirName)/$relPathValue"
                            }
                          } else {
                            lappend tmpValue $possibleFile
                          }
                        } else {
                            lappend tmpValue $possibleFile
                          }
                        } else {
                          #puts "skipVariableUsageInReference: $skipVariableUsageInReference"
                          if {$relPathValue ne [file normalize $possibleFile]} {
                            if {$skipVariableUsageInReference} {
                              lappend tmpValue $relPathValue
                            } else {
                              lappend tmpValue "\$${arrName}($VarDirName)/$relPathValue"
                            }
                          } else {
                            lappend tmpValue $possibleFile
                          }
                          #puts "final value: ->$tmpValue<-"
                        }
                    } else {
                      lappend tmpValue $possibleFile
                    }
                    } else {
                      # could not be tested as a file, so just lappend the entire string
                      lappend tmpValue $possibleFile
                    }
                  } else {
                    # could not be tested as a file, so just lappend the entire string
                    lappend tmpValue $possibleFile
                  }
                } else {
                  # The file or dir need not exist, but the vardir must be a subdir (i.e., there must be a subdir that does exist)
                  #puts "Checking possible file: ->[subst $possibleFile]<- against regular expression ->$re<-"
                  if {[regexp $re [subst $possibleFile] full relativizedPortion]} {
                    if {$relativizedPortion eq ""} { set relativizedPortion "."}
                    set fileFound 1
                    if {$skipVariableUsageInReference} {
                      lappend tmpValue $relativizedPortion
                    } else {
                      lappend tmpValue "\$${arrName}($VarDirName)/$relativizedPortion"
                    }
                    if {[flatten_list $possibleFile] ne [flatten_list $tmpValue]} {
                      #puts "<FF> INFO Converted file $possibleFile to use a relative path to determine it's location: $tmpValue"
                    }
                  } else {
                    lappend tmpValue $possibleFile
                  }
                }
              }
              # If the above for loop didn't find any files, simply reset the arrName(arg) statement
              if {$fileFound} {
                # Clean up original arrName(arg) and subb'ed value to prepare for comparison
                set testArg [flatten_list [set ${arrName}($arg)]]
                regsub -all {[ \r\t\n\\]+} $testArg " " testArg
                regsub {^\s+(.*)} $testArg {\1} testArg
                regsub {(.*)\s+$} $testArg {\1} testArg

                set tmpValue [flatten_list $tmpValue]
                regsub -all {[ \r\t\n]+} $tmpValue " " tmpValue
                regsub {^\s+(.*)} $tmpValue {\1} tmpValue
                regsub {(.*)\s+$} $tmpValue {\1} tmpValue
                if {$tmpValue ne "" && $tmpValue ne $testArg} {
                  #puts "<FF> INFO Original value for arrName($arg): ->$testArg<-"
                  if {$relativizeConvMesgList eq ""} {
                     lappend relativizeConvMesgList "# Variable conversion for paths relative to \$${arrName}($VarDirName) ([set ${arrName}($VarDirName)])"
                  }
                  lappend relativizeConvMesgList "<FF> INFO Converted file variable [subst $arrName]($arg) from [set ${arrName}($arg)] to $tmpValue"
                  set ${arrName}($arg) $tmpValue
                  #puts "<FF> INFO Final value for arrName($arg):    ->$tmpValue<-"
                }
              }
            }
          }
        }
      }
    }
    if {[llength $relativizeConvMesgList] > 1} {
      lappend relativizeConvMesgList "# Total converted for variable [set ${arrName}($VarDirName)]:[expr {[llength $relativizeConvMesgList]-1}]"
    }
    return $relativizeConvMesgList
  }
   proc denormalize_rundir {} {

      global vars

      #set op [open $vars(rundir)/.ff.tcl w]
      ## BCL: added Foundation Flow execution dir
      #puts $op "# Foundation Flow Codegen Record."
      #puts $op "# Executed on [exec date] by user: [exec whoami]"
      #puts $op "# Copyright 2011, Cadence Design Systems, Inc."
      #puts $op "# All Rights Reserved"
      #puts $op ""
      #puts $op "# Inputs to code generation:"
      #puts $op "# ----------------------------------------------"
      #puts $op "set vars(ff_exe_dir) \"[exec pwd]\""
      ##puts $op "set vars(ff_dir) [file dirname $vars(script_path)]"
      ## BCL: removed ff_dir, changed to script_path (ff_dir was really redundant)
      #puts $op "set vars(script_path) \"[file normalize $vars(script_path)]\""
      ## BCL: added variable referencing of config_files
      #set cwd ""
      #catch {set cwd [exec pwd]}
      #foreach configFile [subst $vars(config_files)] {
      #  #puts "Processing $configFile"
      #  if {[file dirname [file normalize $configFile]] eq $cwd} {
      #    lappend configFileList "\[subst \$vars(ff_exe_dir)\]/[file tail $configFile]"
      #  } elseif {[FF::relPathTo [file normalize $configFile] $cwd] eq [file normalize [subst $configFile]]} {
      #    lappend configFileList [file normalize $configFile]
      #  } else {
      #    # Use the relative path name from ff_exe_dir
      #    lappend configFileList "\[subst \$vars(ff_exe_dir)\]/[FF::relPathTo [file normalize [subst $configFile]] $cwd]"
      #  }
      #}
      #puts $op "set vars(config_files) \"[FF::flatten_list $configFileList]\""
      ## BCL: added variable referencing of plug dirs
      #if {[file dirname [file normalize $vars(plug_dir)]] eq $cwd} {
      #  # plug_dir is located in ff_exe_dir
      #  puts $op "set vars(plug_dir) \"\$vars(ff_exe_dir)/$vars(plug_dir)\""
      #} elseif {[FF::relPathTo [file normalize $vars(plug_dir)] $cwd] eq [file normalize $vars(plug_dir)]} {
      #  # plug_dir cannot be referenced using a relative path
      #  puts $op "set vars(plug_dir) \"[file normalize $vars(plug_dir)]\""
      #} else {
      #  # Use the relative path name from ff_exe_dir
      #  puts $op "set vars(plug_dir) \"\$vars(ff_exe_dir)/[FF::relPathTo [file normalize $vars(plug_dir)] $cwd]\""
      #}
      #if {[info exists vars(rc_plug_dir)]} {
      #   if {[file dirname [file normalize $vars(rc_plug_dir)]] eq $cwd} {
      #     # rc_plug_dir is located in ff_exe_dir
      #     puts $op "set vars(rc_plug_dir) \"\$vars(ff_exe_dir)/$vars(rc_plug_dir)\""
      #   } elseif {[FF::relPathTo [file normalize $vars(rc_plug_dir)] $cwd] eq [file normalize $vars(rc_plug_dir)]} {
      #    # rc_plug_dir cannot be referenced using a relative path
      #    puts $op "set vars(rc_plug_dir) \"[file normalize $vars(rc_plug_dir)]\""
      #  } else {
      #    # Use the relative path name from ff_exe_dir
      #    puts $op "set vars(rc_plug_dir) \"\$vars(ff_exe_dir)/[FF::relPathTo [file normalize $vars(rc_plug_dir)] $cwd]\""
      #   }
      #}
      ## BCL: added vars(rundir)
      #puts $op ""
      #puts $op "# Outputs from code generation:"
      #puts $op "# ----------------------------------------------"
      #puts $op "set vars(rundir) \"\[file normalize \[file dirname \[info script\]\]\]\""
      #puts $op "set vars(codegen_dir) \"[FF::relPathTo [file normalize $vars(script_dir)] [file normalize $vars(rundir)]]\""
      #puts $op "set vars(script_dir) \"[FF::relPathTo [file normalize $vars(script_dir)] [file normalize $vars(rundir)]]\""
      #close $op

      if {$vars(user_mode) == "hier"} {
         #foreach block [concat $vars(design) $vars(partition_list)] {
         #   file copy -force .ff.tcl $vars(partition_dir)/$block
         #}
#         if {($vars(hier_flow_type) == "2pass") && !$vars(enable_flexilm)} {
#            foreach block [concat $vars(design) $vars(partition_list)] {
#               file copy -force $vars(partition_dir)/$block/Makefile.pass2 $vars(partition_dir_pass2)/$block/Makefile
#               file copy -force $vars(partition_dir)/$block/Makefile.pass2 $vars(script_dir)/$block.Makefile
#               file delete $vars(partition_dir)/$block/Makefile.pass2
#            }
#         }
      }
   }

   proc check_tcl_version {} {
      set tcl_version [info tclversion]
      set tversion [split $tcl_version "."]
      set major [lindex $tversion 0]
      set minor [lindex $tversion 1]
      set valid_version 1
      if {$major != "8"} {
         set valid_version 0
      } else {
         if {[expr $minor] < 4} {
            set valid_version 0
         }
      }
      if {!$valid_version} {
         puts "-------------------------------------------------"
         puts "<FF> ERROR: TCL VERSION MUST BE 8.4 OR GREATER."
         puts "            YOUR TCL VERSION IS $tcl_version."
      #   puts "            PLEASE RUN THE FLOW GENERATOR USING"
      #   puts "            INNOVUS (WITH -e OPTION)"
         puts "-------------------------------------------------"
         exit -1
      } else {
#         puts "-------------------------------------------------"
#         puts "<FF>  TCL VERSION -> $tcl_version"
#         puts "-------------------------------------------------"
      }
   }

   proc create_flow {argv} {
   
      global vars
      global infos
      global warnings
      global errors
      global check
      global dargs 
      global fargs 
      global argv0
      global env

      set orig_argv $argv
   
      interp alias {} Puts {} puts

      ##############################################################################
      # Parse the arguments passed in to the script.  These set up the environment #
      # for the rest of the system                                                 #
      ##############################################################################
      
      set vars(arg_list) [list \
         codegen \
         edi \
         flat \
         makefile \
         mode \
         rc \
         novus \
         synth_flow \
         rundir \
         script_dir \
         style \
         user_mode \
         verbose \
         version \
      ]
      
      set vars(check_setup) 1
   
      if {![info exists vars(script_path)]} {
         set vars(script_path) ""
      }
      set normalized [file normalize $argv0]
      if {[file isdirectory $normalized]} {
         set default_script_path $normalized
      } elseif {[file isdirectory [file dirname $normalized]]} {
         set default_script_path [file dirname $normalized]
      }
   
      if {[info exists env(FF_SETUP_PATH)] && [file exists $env(FF_SETUP_PATH)]} {
         set setup_path $env(FF_SETUP_PATH)
      } else {
         set setup_path "."
      }
   
      if {![info exists argv] || ![llength $argv]} {
         set argv "-h"
      }
   
      set vars(format_lines) true
   
      while {[string match "-*" [lindex $argv 0]]} {
         if {![llength $argv]} {
            break
         }
         set option [lindex $argv 0]
         set argv [lreplace $argv 0 0]
   
         switch -regexp -- $option {
            ^-(h|-help)$ {
               puts $FFMM::usage
               exit 0
            }
   
            ^-(m|-mode)$ {
               #
               # Specify the runtime mode.
               #
   
               if {[llength $argv]} {
                  set newMode [lindex $argv 0]
                  set argv [lreplace $argv 0 0]
               } else {
                  puts $FFMM::noMode
                  puts $FFMM::usage
                  exit -1
               }
   
               #
               # The mode needs to be one of the recognized modes
               #
   
               if {[lsearch [concat "user" "hier" $FFMM::validModes] $newMode] == -1} {
                  puts [format $FFMM::unknownMode $newMode]
                  puts $FFMM::usage
                  exit -111
               }
               set mode $newMode
               puts "<FF> FLOW MODE == $mode"
            }
            ^-(n|-nomake)$ {
               #
               # Skip Makefile generation
               #
   
               set makefile false
               puts "<FF> GENERATE MAKEFILE == $makefile"
            }
            ^-(r|-rtl)$ {
               #
               # Enable Genus Codegen
               #
   
               set rc true
               puts "<FF> RTl SCRIPTS == $rc"
            }
            ^-(N|-Novus)$ {
               #
               # Enable Novus Syntax
               #
   
               set novus true
               puts "<FF> NOVUS SCRIPTS == $novus"
            }
#            ^-(l|-flow)$ {
#               if {[llength $argv]} {
#                  set synth_flow [lindex $argv 0]
#                  set argv [lreplace $argv 0 0]
#               } else {
#                  puts $FFMM::nosynth_flow
#               }
#            }
#            ^-(a|applets)$ {
#               #
#               # Define the applets directory path
#               #
#   
#               if {[llength $argv]} {
#                  set appletsDir [lindex $argv 0]
#                  set argv [lreplace $argv 0 0]
#               } else {
#                  puts $FFMM::noAppletPath
#                  exit -1
#               }
#   
#               puts "<FF> APPLETS DIRECTORY == $appletsDir"
#               set vars(applets_dir) $appletsDir
#            }
            ^-(v|-version)$ {
               #
               # Set the target Innovus version
               #
   
   
               if {[llength $argv]} {
                  set version [lindex $argv 0]
                  set argv [lreplace $argv 0 0]
               } else {
                  puts $FFMM::noVersion
                  exit -1
               }
               if {([lsearch $FF::valid_versions $version] < 0)} {
                  puts $FFMM::noVersion
                  exit -1
               }
#              puts "<FF> VERSION == $version"
            }
            ^-(f|-flat)$ {
               #
               # Get the path to the scripts.
               #
   
               if {[llength $argv]} {
                  set newFlat [lindex $argv 0]
                  set argv [lreplace $argv 0 0]
               } else {
                  puts $FFMM::noFlat
                  exit -1
               }
               if {($newFlat != "full") && ($newFlat != "partial") && ($newFlat != "none")} {
                  puts $FFMM::noFlat
                  exit -1
               }
               puts "<FF> FLAT == $newFlat"
               set flat $newFlat
            }
            ^-(e|-edi)$ {
               #
               # Enable Innovus mode
               #
   
               if {[llength $argv]} {
                  set edi true
#                 set argv [lreplace $argv 0 0]
               }
               puts "<FF> INNOVUS == $vars(edi)"
            }
            ^-(d|-dir)$ {
               #
               # Define output directory path
               #
   
               if {[llength $argv]} {
                  set scriptDir [lindex $argv 0]
                  set argv [lreplace $argv 0 0]
               } else {
                  puts $FFMM::noPath
                  exit -1
               }
   
               puts "<FF> OUTPUT DIRECTORY == $scriptDir"
   
            }
            ^-(y|-style)$ {
               #
               # Define rundir directory naming style
               # -d must be provided, since this will redefine vars(script_dir)
               #
   
               if {[llength $argv]} {
                  set styleType [lindex $argv 0]
                  switch -regexp -- $styleType { 
                    (increment|date|none) {
                      set argv [lreplace $argv 0 0]
                    }
                    default {
                      puts [format $FFMM::unknownOption "-y $styleType"]
                      puts $FFMM::usage
                      exit -1
                    }
                  }
               } else {
                  puts $FFMM::noStyle
                  exit -1
               }
               puts "<FF> DIRECTORY NAMING STYLE == $styleType"
            }
            ^-(u|-rundir)$ {
               #
               # Define execution (run) dir
               # This option superceeds -d ($vars(script_dir) is overridden to $vars(rundir)/FF)
               #
   
               if {[llength $argv]} {
                  set runDir [lindex $argv 0]
                  set argv [lreplace $argv 0 0]
               } else {
                  puts $FFMM::noRundir
                  exit -1
               }
   
               puts "<FF> RUNDIR BASE == $runDir"
            }
            ^-(s|-setup)$ {
               #
               # Get the path to the directory containing the setup.tcl control
               # file
               #
   
               if {[llength $argv]} {
                  set newPath [lindex $argv 0]
                  set argv [lreplace $argv 0 0]
               } else {
                  puts $FFMM::noSetupPath
                  puts $FFMM::usage
                  exit -1
               }
   
               #
               # Does the path exist?  If not, error out.  Make sure that the path
               # exists and contains the source files
               #
   
               if {![file exists $newPath]} {
                  puts [format $FFMM::noSuchPath $newPath]
                  puts $FFMM::usage
                  exit -1
               }
               set setup_path $newPath
               puts "<FF> SETUP PATH == $setup_path"
            }
            ^-(V|-Verbose)$ {
               #
               # Enable Verbose mode
               #
   
               if {[llength $argv]} {
                  set vars(verbose) true
               }
               puts "<FF> VERBOSE == $vars(verbose)"
            }
            ^-(H|-Help)$ {
               #
               # Print step help
               #
   
               if {[llength $argv]} {
                  set vars(help) true
               }
#               puts "<FF> HELP == $vars(help)"
            }
            default {
               puts [format $FFMM::unknownOption $option]
               puts $FFMM::usage
               exit -1
            }
         }
      }
   
      if {![file exists $setup_path/setup.tcl]} {
         puts [format $FFMM::missingSetupFile $setup_path]
         exit -1
      } else {
         set vars(setup_path) $setup_path
      }
  
      #
      # Source the other Tcl files to execute the flow.  Then do so
      #
   
      source "$vars(script_path)/ETC/utils.tcl"
   
      #
      # Get new rundir (using -u/-y and possibly user variables)
      #
      # NOTE: dargs: default args
      #       fargs: flow args specified on command line
   
      if {![info exists first]} {
         # BCL: Moved this code before gen_new_rundir since dargs(mode) must be set before executing execute_flow
         if {![info exists mode]} {
            set mode flat
            set dargs(user_mode) flat 
            set dargs(mode) flat 
         } else {
            if {$mode == "flat" || $mode == "user"} {
               set fargs(user_mode) flat  
             } else {
               set fargs(user_mode) hier 
             }
#           set fargs(user_mode) flat  
         } 
         if {![info exists makefile]} {
            set dargs(makefile) true
         } else {
            set fargs(makefile) $makefile
         }
         if {![info exists rc]} {
            set dargs(rc) false
            set rc false
         } else { 
            set fargs(rc) $rc 
         }
         if {![info exists novus]} {
            set dargs(novus) false
            set novus false
         } else { 
            set fargs(novus) $novus 
         }
         if {![info exists synth_flow]} {
            set dargs(synth_flow) default_synthesis_flow_3step
         } else {
            set fargs(synth_flow) $synth_flow
         }
         if {![info exists version]} {
            set dargs(version) 17.1.0
         } else { 
            set fargs(version) $version
         }
         if {![info exists edi]} {
            set dargs(edi) false
         } else { 
            set fargs(edi) $edi
         }
         if {![info exists flat]} {
            set dargs(flat) off
         } else { 
            set fargs(flat) $flat
         }
         if {![info exists verbose]} {
            set dargs(verbose) false
         } else { 
            set fargs(verbose) $verbose
         }
         if {![info exists scriptDir]} {
            set dargs(script_dir) FF
         } else { 
            set fargs(script_dir) $scriptDir
         }
         set dargs(rundir) [file normalize .] 
         if {[info exists runDir]} {
            # BCL: if runDir is set, it's a flow arg
            set fargs(rundir) $runDir
         }
         if {![info exists styleType]} {
            set dargs(style) none
         } else { 
            set fargs(style) $styleType
         }
         
         # BCL: We are running codegen, so set fargs(codegen) to true
         set fargs(codegen) true
         set fargs(mode) $mode
         set vars(cwd) [pwd]
      
         set first 0
   
         # BCL: (potentially) generate a new rundir
         set fargs(rundir) [file normalize [FF::gen_new_rundir $orig_argv]]
   
#         # If the user passed a -y and -u, move the -y (codegen dir output) to underneith the -u (rundir)
#         # and message user
#         if {[info exists fargs(rundir)] && $vars(rundir) ne "" && [file normalize $fargs(rundir)] ne [file normalize .]} {
#           if {[info exists scriptDir]} {
#              puts "<FF> NOTE: codegen output dir (-y $scriptDir) used with rundir specification of: $fargs(rundir)."
#              puts "<FF>       FF will move the codegen dir under the rundir:  $vars(rundir)/[file tail $vars(script_dir)]"
#              set fargs(script_dir) [file normalize $vars(rundir)/[file tail $vars(script_dir)]]
#              set vars(script_dir) $fargs(script_dir)
#           } elseif {[info exists vars(script_dir)] && $vars(script_dir) eq "FF"} {
#              # vars(script_dir) is the default, so just move it
#              set fargs(script_dir) [file normalize $vars(rundir)/FF]
#              set vars(script_dir) $fargs(script_dir)
#           }
#         } else {
#           # rundir is ./, so set 
#           if {![info exists scriptDir]} {
#             set dargs(script_dir) "FF"
#             set vars(script_dir) $dargs(script_dir)
#           } else {
#             set vars(script_dir) $scriptDir
#           }
#         }
         # BCL: Added subst to resolve vars(rundir)
# GDG - this is done multiple times
         #catch {file mkdir [subst $vars(script_dir)]}
      }

      #
      # Determine the steps that can be executed based upon the mode passed in
      #
      FF::set_steps $mode $vars(format_lines)
      set user_steps [list]
      if {![llength $argv]} {
         #
         # If there is no argument, print out the list of valid steps for the mode
         #
         # set step all
         #   puts "Valid steps are: source check all $vars(steps)"
         #   exit
   
         puts $FFMM::usage
         puts "   Step argument missing ... valid steps are:\n"
          foreach s "$vars(steps) all" {
            puts "     $s"
         }
         exit

      } else {

         #
         # Create a list of the user-specified steps.  They can be in the form of
         #     <step1> <step2> ... <stepn>
         #     <step1> <step3>-<step5> <step7> ...
         #     <step1>-<stepn>
         # There are, of course, additional variants.  The thing is, if there is a
         # dash between two steps, we want to expand the dash into the set of all
         # steps between the two listed.
         #
  
         set vars(step_arg) $argv
         foreach step $argv {
            set dash [string first "-" $step]
            if {$dash == -1} {
               lappend user_steps $step
            } else {
               set first_step [string range $step 0 [expr $dash - 1]]
               set last_step [string range $step [expr $dash + 1] end]
               if {$last_step == ""} {
                  set last_step [lindex $vars(steps) end]
               }
   
               set first_index [lsearch $vars(steps) $first_step]
               set last_index [lsearch $vars(steps) $last_step]
               if {$first_index == -1} {
                  puts "Error: Unknown step $first_step for mode $mode"
                  exit -111
               }
               if {$last_index == -1} {
                  puts "Error: Unknown step $last_step for mode $mode"
                  exit -111
               }
   
               set steps [lrange $vars(steps) $first_index $last_index]
               set user_steps [concat $user_steps $steps]
            }
         }
      }
  
      if {[info exists vars(help)] && $vars(help)} {
         foreach step $user_steps {
            FF::help $step
         }
         exit
      }
   
      set vars(make) $user_steps
      set vars(argv) $argv
   
      #set user_steps [FF::setup_flow $argv ]
   
      #
      # Execute the flow for every step that the user specified.
      #
      if {[info exists vars(rundir)]} {
         set cwd [exec pwd]  
         file mkdir $vars(rundir)
         foreach file [list setup.tcl innovus_config.tcl lp_config.tcl rc_config.tcl] { 
            if {[file isfile $file]} {
               file copy -force $file $vars(rundir)
            }
         }
         cd $vars(rundir)
      }
     
      set mode $vars(mode)
      foreach step $user_steps {
         if {$mode == "hier"} { set mode top_down }
         switch $mode {
            "user" {
               if {$vars(novus)} {
                  FF_NOVUS::execute_flow $step $vars(format_lines)
               } else {
                  FF_EDI::execute_flow $step $vars(format_lines)
               }
            }
            "flat" {
               if {$vars(novus)} {
                  FF_NOVUS::execute_flow $step $vars(format_lines)
               } else {
                  FF_EDI::execute_flow $step $vars(format_lines)
               }
            }
            "top_down" {
               if {$vars(novus)} {
                  FF_NOVUS::execute_flow $step $vars(format_lines)
               } else {
                  FF_EDI::execute_flow $step $vars(format_lines)
               }
            }
            "bottom_up" {
               if {$vars(novus)} {
                  FF_NOVUS::execute_flow $step $vars(format_lines)
               } else {
                  FF_EDI::execute_flow $step $vars(format_lines)
               }
            }
            "default" {
               puts [format $FFMM::unknownMode mode]
               puts $FFMM::usage
               exit -111
            }
         }
      }
      if {[info exists vars(flow_steps)]} {
         unset vars(flow_steps)
      }
      if {[file isfile $vars(script_dir)/INNOVUS/.head]} {
         if {$vars(step_arg) == "all"} {
            set op [open $vars(script_dir)/INNOVUS/run_simple.tcl w]
         } else {
            set op [open $vars(script_dir)/INNOVUS/run_simple.$vars(step_arg).tcl w]
         }
         puts $op "#####################################################################"
         puts $op "#                       SINGLE SCRIPT FLOW"
         puts $op "#####################################################################"
         puts $op "\nsource $vars(script_dir)/vars.tcl"
         puts $op "source $vars(script_dir)/procs.tcl\n"
         set ip [open $vars(script_dir)/INNOVUS/.head]
         while {[gets $ip line]>=0} {
            puts $op $line 
         }
         close $ip
         set ip [open $vars(script_dir)/INNOVUS/.load_[lindex $vars(bsteps) 0]]
         while {[gets $ip line]>=0} {
            puts $op $line 
         }
         close $ip
         foreach step $vars(bsteps) {
            if {($step == "lec") || ($step == "debug")} {
               continue
            }
            set ip [open $vars(script_dir)/INNOVUS/.$step]
            while {[gets $ip line]>=0} {
               puts $op $line 
            }
            close $ip
            file delete $vars(script_dir)/INNOVUS/.$step  
            file delete $vars(script_dir)/INNOVUS/.load_$step
         } 
         puts $op "exit"
         close $op
#        file mkdir $vars(script_dir)/INNOVUS/SIMPLE
#        foreach step $vars(bsteps) {
#           if {($step == "lec")  || ($step == "debug")} {
#              continue
#           }
#           set op [open $vars(script_dir)/INNOVUS/SIMPLE/run_$step.tcl w]
#           puts $op "#####################################################################"
#           puts $op "#                      SIMPLE STEP SCRIPT"
#           puts $op "#####################################################################"
#           puts $op "\nsource $vars(script_dir)/vars.tcl"
#           puts $op "source $vars(script_dir)/procs.tcl\n"
#           set ip [open  $vars(script_dir)/INNOVUS/.head]
#           while {[gets $ip line]>=0} {
#              puts $op $line 
#           }
#           close $ip
##           file delete $vars(script_dir)/INNOVUS/.head  
#           set ip [open $vars(script_dir)/INNOVUS/.load_$step]
#           while {[gets $ip line]>=0} {
#              puts $op $line 
#           }
#           close $ip
#           set ip [open  $vars(script_dir)/INNOVUS/.$step]
#           while {[gets $ip line]>=0} {
#              puts $op $line 
#           }
#           close $ip
#           puts $op "exit"
#           close $op
#           file delete $vars(script_dir)/INNOVUS/.$step  
#           file delete $vars(script_dir)/INNOVUS/.load_$step
#        }
          file delete $vars(script_dir)/INNOVUS/.head  
      }

      # -----------

#      if {[info exists vars(script_dir)]} {
#         file delete $vars(script_dir)/INNOVUS/gen_html.tcl
#         file copy [subst $vars(script_path)/INNOVUS/gen_html.tcl] [subst $vars(script_dir)/INNOVUS/gen_html.tcl]
#      }
      puts "-------------------------------------------------"
      if {[info exists vars(plug_files)] && ($vars(plug_files) != "")} {
         puts "\n                Plug-ins Imported"
         puts "               ------------------"                                                    
         foreach file $vars(plug_files) {
            puts "               > $file"
         }
      }
         if {[info exists vars(plugins_defined)] && ($vars(plugins_defined) != "")} {
            set plugins_defined [llength $vars(plugins_defined)]
            if {$vars(verbose)} {
               puts "\n                Plug-ins Defined"
               puts "               ------------------"                                                    
               foreach file [join $vars(plugins_defined)] {
                  puts "               > $file"
               }
            }
         } else {
            set plugins_defined 0
         }
         if {[info exists vars(plugins_found)] && ($vars(plugins_found) != "")} {
            set plugins_found [llength $vars(plugins_found)]
            if {$vars(verbose)} {
               puts "\n                 Plug-ins Found"
               puts "               ------------------"                                                    
               foreach file [join $vars(plugins_found)] {
                  puts "               > $file"
               }
            }
         } else {
            set plugins_found 0
         }
         if {[info exists vars(missing_plugins)] && ($vars(missing_plugins) != "")} {
            set missing_plugins [llength $vars(missing_plugins)]
            puts "\n                 Missing Plug-ins"
            puts "               ------------------"                                                    
            foreach file [join $vars(missing_plugins)] {
               puts "               > $file"
            }
         } else {
            set missing_plugins 0
         }
      #      puts "-------------------------------------------------"
      if {[info exists vars(tagged)] && ($vars(tagged) != "")} {
         puts "\n                Tagged Commands"
         puts "               ------------------"                                                    
         foreach file $vars(tagged) {
            puts "               > $file"
         }

         set vars(missing_tags) [list]
         foreach var [array names vars] {
           if {[llength [split $var ","]] == 3} {
             set suffix [lindex [split $var ","] 2]
             if {($suffix == "pre_tcl") || ($suffix == "post_tcl") || ($suffix == "replace_tcl")} {
               if {[lsearch $vars(tagged) $var] == -1} {
                 lappend vars(missing_tags) $var
               }
             }
           }
         }
         if {[llength $vars(missing_tags)] > 0} { 
           puts "\n                Unrecognized Tags"
           puts "               ------------------"                                                    
           foreach tag $vars(missing_tags) {
              puts "               > $tag"
           }
         }
      }
      if {[info exists vars(info_count)] && ($vars(info_count) > 0)} {
         puts "\n                   Info Summary"
         puts "                  ---------------"                                                    
         for {set i 0} {$i<$vars(info_count)} {incr i} {
            puts "    ([expr $i + 1]) $infos($i)"
         }
      }
      if {[info exists vars(warning_count)] && ($vars(warning_count) > 0)} {
         puts "\n                  Warning Summary"
         puts "                  ---------------"                                                    
         for {set i 0} {$i<$vars(warning_count)} {incr i} {
            puts "    ([expr $i + 1]) $warnings($i)"
         }
      }
      if {[info exists vars(error_count)] && ($vars(error_count) > 0)} {
         puts "\n                   Error Summary"
         puts "                   ---------------"                                                    
         for {set i 0} {$i<$vars(error_count)} {incr i} {
            puts "    ([expr $i + 1]) $errors($i)"
         }
         if {$vars(abort)} {
            puts "\n"
            puts "-------------------------------------------------"
            puts "<FF> CODE GENERATION FAILED"
            puts "-------------------------------------------------"
            exit 1
         }
      }
      if {$vars(make) != "all"} {
         if {[info exists vars(custom_steps)]} {
            FF::gen_makefile $vars(custom_steps) $vars(mode)
         } else {
            FF::gen_makefile $vars(make) $vars(mode)
         }
      }


#      if {($vars(user_mode) == "hier") && $vars(enable_flexilm)} {
#         foreach part $vars(partition_list) {
#            file copy $vars(partition_dir_pass2)/$part/Makefile $vars(partition_dir_pass2)/$part.Makefile
#         } 
#      }
      
      puts "\n"
      puts "-------------------------------------------------"
      puts "<FF> CODE GENERATION COMPLETE"
      puts "<FF> ... VERSION  -> $vars(version)"
      if {[info exists vars(rundir)]} {
         puts "<FF> ... RUN DIRECTORY  -> $vars(rundir)"
      }
      puts "<FF> ... SCRIPTS  -> $vars(script_dir)"
      puts "<FF> ... PLUGINS  -> $plugins_defined defined, $plugins_found found"
      if {[info exists vars(check_vars)] && $vars(check_vars)} {
         puts "<FF> ... REPORTS  -> $vars(script_dir)/check.rpt"
         puts "<FF> ...          -> $vars(script_dir)/check_vars.rpt"
      } else {
         puts "<FF> ... REPORT   -> $vars(script_dir)/check.rpt"
      }
      if {[info exists vars(makefile_name)] && [file isfile [subst $vars(makefile_name)]]} {
         puts "<FF> ... MAKEFILE -> [relPathTo [subst $vars(makefile_name)] [subst $vars(rundir)]]"
      }
      
      puts "-------------------------------------------------"

      FF::dump_vars

      if {[info exists vars(rundir)]} {
         cd $cwd
      }
   }

   proc dump_vars {} {

      global vars
      global env

      # 
      # Create a procs.tcl file with ff utilities that are need by the flow
      # 

      if {![info exists vars(proc_file)]} {

         puts "<FF> Creating $vars(script_dir)/procs.tcl"
         set save $vars(required_procs)
         set of [open $vars(script_dir)/procs.tcl w]
         set ff_procs "\nnamespace eval ff_procs:: {\n"
         append ff_procs [get_required_procs $vars(script_path)/ETC/INNOVUS/utils.tcl]
         append ff_procs [get_required_procs $vars(script_path)/ETC/utils.tcl]
         set vars(required_procs) "source_plug"
         append ff_procs [get_required_procs $vars(script_path)/ETC/INNOVUS/utils.tcl]
#         append ff_procs "   namespace export load_applet\n"
         append ff_procs "}\n"
         puts $of $ff_procs
         if {[info exists vars(use_flexmodels)] && $vars(use_flexmodels)} {
            puts $of {
               # Flexmodel defaults
               catch {
                  setPlaceDesignMode_ff -clonePlace noPostPlace  ;#REMOVE after fixing CCR 974103
                  set mib::FE_major_version  [string range [getVersion] 0 1]
                  set mib::FE_minor_version  [string range [getVersion] 3 4]      
              
                  #################### Default private var settings for proto flow #########################
                  set trialRoutePrivate::honorPtnPinSpec 1  ;#so TR adds blockages straddling ptn boundary before routing
                  set trialRoutePrivate::enableFlexCell 1 ;#enable flexfiller_route_blockage for better congestion/placement correlation to full netlist.
                  set trialRoutePrivate::useColorMap  1  ;#enable much faster handlePartitionComplex algorithm
                  set trialRoutePrivate::overflowLimit 4 ;#Giving up phase 1 trialRoute prematurely when the overflow is more than 10%
               
               
                  ################### Hide setting variables in the prototyping script #######################
                  setVar timing_library_support_mismatched_arcs 0
                  
                  
                  ##########################################################################################
                  # Procedure to check for using correct prototyping kit
                  #########################################################################################
                  proc mib::check_protokit_version {{current_kit_version ""}} {
                     if {[lsearch $mib::protokit_version $current_kit_version] == -1} {
                        Puts "*WARN* Correct prototyping kit should be used to avoid un-expected problems"
                        Puts "       This Innovus build requires prototyping kit version [lrange $mib::protokit_version 0 4]"
                     }
                  }
              
                  mib::check_protokit_version "EDI13.20-0"  
               }
            }
         }
         set vars(required_procs) $save

         if {[info exists vars(cpf_file)]} {
            puts $of "#----------------------------------------------"
            puts $of "# Backwards compatibility ..."
            puts $of "#----------------------------------------------"
            puts $of "catch {alias ff_modify_power_domains ff_procs::modify_power_domains}"
            puts $of "catch {alias ff_add_power_switches ff_procs::add_power_switches}"
            puts $of "catch {alias ff_route_secondary_pg_nets ff_procs::route_secondary_pg_nets}"
            puts $of "catch {alias ff_get_power_domains ff_procs::get_power_domains}"
            puts $of "catch {alias ff_buffer_always_on_nets ff_procs::buffer_always_on_nets}"
            puts $of "catch {alias ff_insert_welltaps_endcaps ff_procs::insert_welltaps_endcaps}"
            if {$vars(novus)} { 
               puts $of "catch {alias FF_NOVUS::modify_power_domains ff_procs::modify_power_domains}"
               puts $of "catch {alias FF_NOVUS::add_power_switches ff_procs::add_power_switches}"
               puts $of "catch {alias FF_NOVUS::route_secondary_pg_nets ff_procs::route_secondary_pg_nets}"
               puts $of "catch {alias FF_NOVUS::get_power_domains ff_procs::get_power_domains}"
               puts $of "catch {alias FF_NOVUS::buffer_always_on_nets ff_procs::buffer_always_on_nets}"
               puts $of "catch {alias FF_NOVUS::insert_welltaps_endcaps ff_procs::insert_welltaps_endcaps}"
           } else {
               puts $of "catch {alias FF_EDI::modify_power_domains ff_procs::modify_power_domains}"
               puts $of "catch {alias FF_EDI::add_power_switches ff_procs::add_power_switches}"
               puts $of "catch {alias FF_EDI::route_secondary_pg_nets ff_procs::route_secondary_pg_nets}"
               puts $of "catch {alias FF_EDI::get_power_domains ff_procs::get_power_domains}"
               puts $of "catch {alias FF_EDI::buffer_always_on_nets ff_procs::buffer_always_on_nets}"
               puts $of "catch {alias FF_EDI::insert_welltaps_endcaps ff_procs::insert_welltaps_endcaps}"
           }
         }

         close $of
         set vars(proc_file) 1
      }
#      if {[file tail [file dirname [pwd]]] == "$vars(partition_dir)"} {
#         set op [open $vars(script_dir)/vars.tcl a]
#         if {$vars(user_mode) == "hier"} {
#            if {[file tail [file dirname [exec pwd]]] == $vars(partition_dir)} {
#               puts $op "source $vars(norm_script_path)/ETC/applet.tcl"
#               #puts $op "source ../../$vars(script_path)/ETC/compatibility.tcl"
#               puts $op "set_attribute applet_search_path $vars(norm_script_path)/ETC/applets /"
#            } else {
#               puts $op "source $vars(script_path)/ETC/applet.tcl"
#               #puts $op "source ../../$vars(script_path)/ETC/compatibility.tcl"
#               puts $op "set_attribute applet_search_path $vars(script_path)/ETC/applets /"
#            }
#         }
#         puts $op "applet load measure"
#         puts $op "applet load time_info"
#         close $op
#         return
#      }
      if {[file normalize $vars(rundir)] ne [file normalize .]} {
        set relativizeVar 1
      } else {
        set relativizeVar 0
      }
#      if {$relativizeVar} {
#        puts "<FF> Finalizing Foundation Flow Variables for final rundir: [relPathTo [file normalize $vars(rundir)] [file normalize .]]"
#      }

      # BCL: substitute plugdirs and codegen dir with variable referencing (i.e., replace actual dir with [subst $vars(<dir>)]) before writing vars.tcl
      if {![info exists vars(ff_exe_dir)]} {
         set vars(ff_exe_dir) [exec pwd]
      }

      # BCL: The following are set using variables in the generated .ff.tcl, and are therefore pulled out of the generated vars.tcl
      set skipVarList {ff_exe_dir rundir plug_dir rc_plug_dir lec_plug_dir script_dir flow_steps flow_steps,flat flow_steps,hier}

      # BCL: Changed to tcl file mkdir
      file mkdir $vars(script_dir)
#GG
      if {[info exists vars(stylus_convert)] && $vars(stylus_convert)} {
        set anchor(place) "before run_place_opt"
        set anchor(prects) "before run_place_opt"
        set anchor(cts) "before add_clock_spec"
        set anchor(postcts) "before add_clock_spec"
        set anchor(postcts_hold) "before add_clock_spec"
        set anchor(route) "before run_route"
        set anchor(postroute) "before run_opt_postroute"
        set anchor(postroute_hold) "before run_opt_postroute"

        set op [open $vars(script_dir)/flow_steps.tcl w]
        foreach step [FF::adjust_steps] {
          if {![info exists anchor($step)]} { 
            if {[info exists vars($step,commands)]} {
              unset vars($step,commands)
              continue 
            }
          }
          if {[info exists vars($step,commands)]} {
            puts $op "create_flow_step -name pre_$step -owner cadence \{"
            puts $op $vars($step,commands)
            puts $op "\}"
            unset vars($step,commands)
            puts $of "edit_flow -append flow_step:pre_$step -[lindex $anchor($step) 0] flow_step:[lindex $anchor($step) 1]"
          }
        }

#        set op [open scripts/flow_config.tcl a]
#        puts $op "source $vars(script_dir)/flow_steps.tcl"
        close $op

         FF::create_codegen_file
         set op [open codegen_create.txt a]
         puts $op "codegen::template ./scripts/flow_config.template \{"
         puts $op "  placeholder \{<< PLACEHOLDER: PARASITIC LOAD OPTIONS >>\} \{ -all_rc_corner -rcdb rcdb/$vars(design).rcdb.d \}"
         puts $op "  append \{"
         puts $op "create_flow_step -name write_parasitics -owner cadence  \{"
         puts $op "    file mkdir rcdb"
         puts $op "    write_rc rcdb/$vars(design).rcdb.d"
         puts $op "\}"
         puts $op "edit_flow -after flow_step:run_opt_postroute -append flow_step:write_parasitics"
         foreach file "$vars(script_dir)/flow_steps.tcl $vars(script_dir)/plug_steps.tcl" {
           if {[file exists $file]} {
             set ip [open $file r]
             while {[gets $ip line]>=0} {
                puts $op "$line"
             }
             close $ip
           }
         }

         puts $op "  \}"
         puts $op "\}"
         close $op
      }
      foreach var [array names vars] {
        if {[regexp ",commands$" $var]} {
          unset vars($var)
        }
      }
#      foreach step $vars(steps) {
#        if {[info exists vars($step,commands)]} {
#          unset vars($step,commands)
#        }
#      }
      set op [open $vars(script_dir)/vars.tcl w]

      puts $op "# ############################################################################ #"
      puts $op "# Foundation Flow Codegen Vars Record"
      puts $op "# Executed on [clock format [clock seconds] -format "%I:%M:%S %p(%b%d)"] by user: [exec whoami]"
      puts $op "# Copyright 2008-2012, Cadence Design Systems, Inc."
      puts $op "# All Rights Reserved"
      puts $op "# ############################################################################ #"
      puts $op ""
      puts $op "# This file contains all default (seeded) variables and user-defined variables that were resolved during code generation."

      puts $op "if {!\[info exists vars\]} {"
      puts $op "   global vars"
      puts $op "}"
      puts $op "global env"
#      if {[info exists vars(user_arrays)]} {
#         foreach array $vars(user_arrays) {
#            puts $op "global $array"
#         }
#      }

      # Print variables which may be referenced by other variables
      # Note: General methodology is to not use more than one variable reference (i.e., don't allow multiple variable dereferencing)
      puts $op "set env(VPATH) $env(VPATH)"
      puts $op "set vars(ff_exe_dir) \"$vars(ff_exe_dir)\""
      puts $op "set vars(rundir) \"$vars(rundir)\""
      puts $op "set vars(script_dir) \"$vars(script_dir)\""
      puts $op ""

# GDG ...
#      if {$relativizeVar} {
#        set relativizeMesgLog ""
#        # First relativize ff_exe_dir. Ignore plug variables for now (maybe this can be relaxed?)
#        # All files in this first relativization task must exist. Skip anything that is located in vars(rundir).
#        set relativizeMesgLog "$relativizeMesgLog [FF::remove_outer_braces \
#           [FF::relativizeFileOrDir -vardir ff_exe_dir -mustExist -skipVar script_dir -skipVar ff_exe_dir \
#              -skipVar rc_plug_dir -skipVar lec_plug_dir -skipVar plug_dir -skipVar rundir -skipDir [file normalize $vars(rundir)]]]"
#        # Relativize all files in rundir. Skip variable referencing, meaning do not include $vars(rundir) in the final variable value
#        set relativizeMesgLog "$relativizeMesgLog [FF::remove_outer_braces [FF::relativizeFileOrDir -vardir rundir -skipVariableUsageInReference -skipVar script_dir]]"
#        # Swap out the invidiual plug dir variables
#        foreach dir "rc_plug_dir lec_plug_dir plug_dir" {
#          if {[info exists vars($dir)]}  {
#             # Relativize the plugin (syn_load_rtl goes from ./plug/GENUS/syn_load_rtl.tcl to $vars(rc_plug_dir)/syn_load_rtl.tcl)
#             set relativizeMesgLog "$relativizeMesgLog [FF::remove_outer_braces \
#                [FF::relativizeFileOrDir -vardir $dir -mustExist \
#                -exactSubDirMatch [file normalize $vars($dir)]]]"
#             # normalize the plug dirs
#             set vars($dir) [file normalize [subst $vars($dir)]]
#          }
#        }
#      }
      # Print plugin variables
      if {[info exists vars(plug_dir)]}     {puts $op "set vars(plug_dir) \"$vars(plug_dir)\""}
      if {[info exists vars(rc_plug_dir)]}  {puts $op "set vars(rc_plug_dir) \"$vars(rc_plug_dir)\""}
      if {[info exists vars(lec_plug_dir)]} {puts $op "set vars(lec_plug_dir) \"$vars(lec_plug_dir)\""}
      puts $op "\n"

      # Actually print out all the other variables
      if {[info exists vars(init_commands)]} {unset vars(init_commands)}
      foreach var [lsort [array names vars]] {
         # BCL: Only write out variable values in curlies if not using [subst ...]
         if {[lsearch $skipVarList $var] == -1} {
           if {[regexp {\$} $vars($var)]} {
             puts $op "set vars($var) \"$vars($var)\""
           } else {
             puts $op "set vars($var) \{$vars($var)\}"
           }
         }
      }

      # Print aliases
      puts $op "set vars(restore_design) {true}"

      # Load applets
#      puts $op "source $vars(script_path)/ETC/applet.tcl"
#      puts $op "source ../../$vars(script_path)/ETC/compatibility.tcl"
#      puts $op "set_attribute applet_search_path $vars(script_path)/ETC/applets /"
#      puts $op "applet load generate_report"
#      puts $op "applet load measure"
#      puts $op "applet load time_info"

      close $op

#      if {$relativizeVar} {
#        # Write out messaging related to relativizeFileOrDir output
#        set op [open $vars(script_dir)/relativize_vars.rpt w]
#        puts $op "# ############################################################################ #"
#        puts $op "# Foundation Flow Variable Relativization Report"
#        puts $op "# Executed on [clock format [clock seconds] -format "%I:%M:%S %p(%b%d)"] by user: [exec whoami]"
#        puts $op "# Copyright 2008-2012, Cadence Design Systems, Inc."
#        puts $op "# All Rights Reserved"
#        puts $op "# ############################################################################ #"
#        foreach line $relativizeMesgLog {
#          puts $op $line
#        }
#        close $op
#      }

   }

   proc cleanup_dotfiles {} {

      global vars

      if {$vars(user_mode) != "hier"} {
         return
      }

      if {[info exists vars(rundir)]} { 
         cd $vars(rundir)
      }

      foreach file [glob $vars(script_dir)/INNOVUS/.*] {
         if {[file isfile $file] && (![regexp ".nfs" $file])} {
            file delete $file
            if {$vars(debug)} {
               puts "<FF> Deleting $file ..."
            }   
         }
      }
      if {[info exists vars(partition_dir)] && [info exists vars(partition_list)]} { 
         if {[file isdirectory $vars(partition_dir)]} {
            foreach part [concat $vars(design) $vars(partition_list)] {
               foreach file [glob $vars(partition_dir)/$part/$vars(script_dir)/INNOVUS/.*] {
                  if {[file isfile $file] && (![regexp ".nfs" $file])} {
                     file delete $file
                     if {$vars(debug)} {
                        puts "<FF> Deleting $file ..."
                     }   
                  }
               }
               if {($vars(hier_flow_type) == "2pass")} {
                  if {[file isdirectory $vars(partition_dir_pass2)]} {
                     catch {set dotfiles [glob $vars(partition_dir_pass2)/$part/$vars(script_dir)/INNOVUS/.*]}
                     if {[info exists dotfiles]} {
                     foreach file [glob $vars(partition_dir_pass2)/$part/$vars(script_dir)/INNOVUS/.*] {
                        if {[file isfile $file] && (![regexp ".nfs" $file])} {
                           file  delete $file
                           if {$vars(debug)} {
                              puts "<FF> Deleting $file ..."
                           }   
                        }
                     }
                     }
                  }
               }
            }
         }
      }
   }

   proc gen_flow {args} {

      global vars

      if {![info exists vars(execute_string)]} {
         set vars(execute_string) "FF::gen_flow $args"
      }

      # Allow re-entrance

         set var_list [list sourced bsteps warnings errors infos warning_count error_count info_count \
                        plugins_defined plugins_found missing_plugins tagged missing_tags]

      if {[info exists vars(arg_list)]} { 
         set reset_list [concat $vars(arg_list) $var_list]
      } else {
         set reset_list $var_list
      }

      foreach var $reset_list {
         if {[info exists vars($var)]} {
            unset vars($var)
         }
         if {[info exists dargs($var)]} {
            unset vars($var)
         }
         if {[info exists dargs($var)]} {
            unset vars($var)
         }
      }

      if {[info exists vars(flat)]} {
         set save $vars(flat)
      }

      puts "================================================="
      puts "<FF>      Foundation Flow Code Generator"
      puts "<FF>        Version : 17.10-p003_1"
      puts "================================================="

      # Check TCL version

      FF::check_tcl_version

      # Create flow scripts

      FF::create_flow $args

      # Adjust variables so the run dir can be relocated

      FF::denormalize_rundir

      if {[info exists save]} {
         set vars(flat) $save
      } else {
         unset vars(flat)
      }

      FF::cleanup_dotfiles

      if {([info command FF::get_tool] ne "") && ([FF::get_tool] eq "edi")} {
         puts "<FF> Loading $vars(script_dir)/procs.tcl ..."
         uplevel #0 source $vars(script_dir)/procs.tcl
      }

      if {$vars(generate_flow_steps)} {
         file delete -force $vars(script_dir)/INNOVUS
         if {[info exists vars(partition_dir)] && [info exists vars(partition_list)]} { 
            if {[file isdirectory $vars(partition_dir)]} {
               foreach part [concat $vars(design) $vars(partition_list)] {
                  if [file isdirectory $vars(partition_dir)/$part/$vars(script_dir)/INNOVUS] {
                     file delete -force $vars(partition_dir)/$part/$vars(script_dir)/INNOVUS
                  }
               }
            }
         }
      }

   }

   proc seed_all_vars {} {
     # defaults
     set script_path ""
     set script_dir ""
     set setup_path ""
     set synth_flow ""
     set format_lines ""
     set step ""
  
     # arg processing
     while {[llength $args] > 0} {
       set option [lindex $args 0]
       set args [lreplace $args 0 0]
       switch -exact -- $option {
          -script_path {
             set script_path [lindex $args 0]
             set args [lreplace $args 0 0]
          }
          -script_dir {
             set script_dir [lindex $args 0]
             set args [lreplace $args 0 0]
          }
          -setup_path {
            set setup_path [lindex $args 0]
            set args [lreplace $args 0 0]
          }
          -synth_flow {
            set synth_flow [lindex $args 0]
            set args [lreplace $args 0 0]
          }
          -format_lines {
            set synth_flow [lindex $args 0]
            set args [lreplace $args 0 0]
          }
          -step {
            set step [lindex $args 0]
            set args [lreplace $args 0 0]
          }
       }
     };# end while (processing args)
   }

  namespace export load_applet
  proc load_applet {args} {
    set defAppletNS "::applet"
    set defSeverity "error"
    set defaultLocalInstall $::ns(applet)::localInstall
    set defaultLocalServer $::ns(applet)::localServer
    set reqAppletVersion ""

    switch -- [parse_options [calling_proc] {} $args \
      "-version sos required version of applet (equal or greater)" reqAppletVersion \
      "-severity sos severity (error|warning|info)" severity \
      "-namespace sos namespace to search for applet" appletNS \
      "srs name of applet" appletName] {
          -2 { return }
          0 { return -code error }
    }

    if {$appletNS eq ""} {
        set appletNS $defAppletNS
    }

    if {$severity eq ""} {
      set severity $defSeverity
    }
   
    # Check to see if the applet happened to already be loaded. If so, check
    # whether there is a minimum version requirement met. If yes, skip the rest of the applet
    # If the applet already does not meet the minimum version requirement, unload it (using package forget)
    if {![catch {set providedVersion [package present ${appletNS}::$appletName]} errorMessage]} {
      if {$reqAppletVersion ne ""} {
        if {[package vcompare $providedVersion $reqAppletVersion] == -1} {
          puts "load_applet INFO: applet $appletName was already loaded, but it's version ($providedVersion) did not meet the minimum required version ($reqAppletVersion)"
          puts "load_applet INFO: This version of the $appletName applet will be removed and the load_applet will search for a newer version of $appletName..."
          package forget ${appletNS}::$appletName
        } else {
	  puts "load_applet INFO: Found $appletName already loaded and it's version ($providedVersion) already meets the minimum required version ($reqAppletVersion). Skipping load..."
	  return
        }
      } else {
	puts "load_applet INFO: Found $appletName already loaded with version ($providedVersion). Skipping applet load..."
	return
      }
    }

    # There is no previously loaded applet. Continue with this proc...
    set FoundMinVersionPath 0
    set finalSearchPath "" 
    set failedPaths ""
    # Because Innovus has it's own get_attribute command now, we need to set this depending on what tool we are in
    if {[get_tool] eq "rc"} {
      set searchPathList [get_attribute applet_search_path /]
    } else {
      set searchPathList [$::ns(compat)::get_attribute applet_search_path /]
    }
    set appletSearchPathCount [llength $searchPathList]

    set origappletSearchPathCount $appletSearchPathCount
    set origSearchPath ""
    # First pass: determine which applet installations meet min required version, if any
    # This for loop does not load the applets, it only determines a final search path to use
    # If none of the search paths contain the minimum version, and severity code is error, this proc
    # will return inside this foreach loop with code error
    if {$appletSearchPathCount > 1} {
      puts "load_applet INFO: Checking all applet search paths for versions of $appletName"
    }
    foreach pathComponent $searchPathList {
      incr appletSearchPathCount -1
      if {$origappletSearchPathCount > 1} {
        puts -nonewline "  $pathComponent ..."
      } else {
        puts -nonewline "load_applet INFO: Checking applet_search_path: $pathComponent ..."
      }
      # If the path component is <default> replace with the applet designated search path value using "UpdateSeachPath"
      if {[string match "<default>" $pathComponent]} {
        set pathComponent [$::ns(applet)::UpdateSearchPath $pathComponent]
      }
      lappend origSearchPath $pathComponent
      if {[file isdirectory $pathComponent]} {
	if {[file isfile $pathComponent/.servInfo]} {
	  if {[get_tool] eq "rc"} {
            set sourceCommand tcl_source
	  } else {
	    set sourceCommand source
	  }
	   set errorMsg ""
          array unset appInfo
	  if {[catch {$sourceCommand $pathComponent/.servInfo} errorMsg] || ![info exists appInfo(${appletNS}::${appletName},version)]} {
	    if {$errorMsg ne ""} {
	      puts " $errorMsg"
	    } else {
	      puts " BAD APPLET SERVER (corrupted .servInfo file)"
	    }
          } else {
	    if {$reqAppletVersion eq "" } {
	      lappend minVersionSearchPath $pathComponent  
	      set FoundMinVersionPath 1
	    } elseif {[package vcompare $appInfo(${appletNS}::${appletName},version) $reqAppletVersion] != -1} {
	        lappend minVersionSearchPath $pathComponent  
	        set FoundMinVersionPath 1
 	    } else {
	      lappend failedPaths $pathComponent
	      set failedPathver($pathComponent) $appInfo(${appletNS}::${appletName},version)
	    }
	    puts " Found $appInfo(${appletNS}::${appletName},version)"
          }
	} else {
	  puts " BAD APPLET INSTALL"
        }
      } else {
	puts "  NONEXISTENT APPLET SERVER"
      }
    };# end first foreach loop (distilling final minimum version applet_search_path

    # Second pass: attempt to load applet in each valid search_path until a successful applet load occurs
    # This for loop must lead to a successful outcome (loaded applet) or an error will be issued
    if {$FoundMinVersionPath} {
      foreach searchPath $minVersionSearchPath {
        set_attribute -quiet applet_search_path $searchPath /
        if {[catch {applet load $appletName} errorMsg]} {
          puts "load_applet INFO: Version check passed on applet install $appletName but applet load failed."
          if {$appletSearchPathCount > 0} {
            puts "load_applet: Trying next applet_search_path..."
          } else {
            puts "load_applet: ERROR: Failed to load applet $appletName. Please check your applet_search_path and applet installation(s)."
	    set_attribute -quiet applet_search_path $origSearchPath /
            return -code error
          }
        } else {
	  if {[catch {set providedVersion [package present ${appletNS}::$appletName]} errorMessage]} {
            puts "load_applet: ERROR: applet $appletName loaded correctly, but the applet did not correctly provide a package version. Trying next search path..."
	  } else {
            puts "load_applet: INFO: Applet $appletName $providedVersion successfully loaded from applet installation at $pathComponent, meeting min version requirement ($reqAppletVersion)"
	    set_attribute -quiet applet_search_path $origSearchPath /
	    return
	  }
        }
      }
    } else {
      # Didn't find any searchy paths with minimum applet installed.
      switch -exact -- $severity {
        error {
          puts "load_applet ERROR: Minimum applet version for applet $appletName is $reqAppletVersion, but no applet was found meeting this requirement."
	}
        warning {
          puts "load_applet WARNING: Minimum applet version for applet $appletName is $reqAppletVersion, but no applet was found meeting this requirement."
	}
        info {
          puts "load_applet INFO: Minimum applet version for applet $appletName is $reqAppletVersion, but no applet was found meeting this requirement."
	}
      }
      puts "load_applet INFO: Search results:"
      foreach searchPath $failedPaths {
        puts "  applet_search_path: $searchPath, $appletName version found: $failedPathver($searchPath)"
      }
      puts "load_applet INFO: Note applet search path that was set:"
      puts "  $origSearchPath" 
      switch -exact -- $severity {
        error {
	  set_attribute -quiet applet_search_path $origSearchPath /
          return -code 99
        }
      }
    }
    set_attribute -quiet applet_search_path $origSearchPath /
  }
  proc generate_reports {args} {
      eval [format "%s %s" generate_report $args]
  }  
  proc runtime_info {args} {
      eval [format "%s %s" time_info $args]
  }
  proc capture_metrics {} {
      global vars 

      set commands "" 
      append commands "measure qor -name $vars(step) $vars(html_summary)\n"
      append commands "time_info -table ff_ext -stamp $vars(step)\n"
      append commands "time_info -table ff_ext -report\n"
      append commands "redirect $vars(time_info_rpt) {time_info -table ff_ext -report}\n"
      append commands "time_info -quiet -table ff_ext -save $vars(time_info_db)\n"

      return $commands
  } 

  proc help {step} {

      global vars
 
      source $vars(script_path)/ETC/INNOVUS/mapped_vars.tcl

      if {![info exists help($step,categories)]} {
         puts "<FF> ERROR: Invalid step/category ... valid options are:"
         foreach cat $help(categories) {
            puts "            $cat"            
         }
         return
      } 

      set length [string length $step]
      puts "   [string repeat = 110]"
      puts [format "   %+55s : %-42s" "variable (command)" values]
#      puts "   Variables affecting '$step' => variable (command) : values"
#      puts "   [string repeat = 110]"
#      puts "   [string repeat - [expr 53-($length/2)]] $step [string repeat - [expr 47-($length/2)]]"

      foreach cat $help($step,categories) {
         set length [string length $cat]
         puts "   [string repeat - [expr 53-($length/2)]] $cat [string repeat - [expr 47-($length/2)]]"
         foreach var [lsort [array names help]] {
            if {[regexp $cat, $var]} {
               if {$cat ne [lindex [split $var ","] 0]} { continue }
               set command [lindex [split $var ","] 1]
               if {[llength [split $var ","]] > 3} {
                  set variable [format "%s,%s" [lindex [split $var ","] 2] [lindex [split $var ","] 3]]
               } else {
                  set variable [lindex [split $var ","] 2]
               }
               set values $help($var)
    
               if {$command != "categories"} { 
                  puts [format "   %+55s : %-42s" "$variable ($command)" $values]
               } 
            }
         }
      }
      puts "   [string repeat = 110]"
   }

  # A procedure to determine if the current flow is low power (i.e., CPF or IEEE 1801 based) 
  proc is_lp_flow {} {
      global vars
      return [expr {[info exists vars(cpf_file)] && $vars(cpf_file) != ""} || \
                {[info exists vars(ieee1801_file)] && $vars(ieee1801_file) != ""}]
  }
  proc adjust_steps {} {
   
      global vars
   
      set new_steps [list]
   
      set first 1

      foreach step $vars(steps) {
   
         if {[regexp _hold $step]} {
            if {([lsearch $vars(fix_hold) [regsub _hold $step ""]]<0)} {
               continue
            } else {
               if {($vars(step) == "postcts_hold") && $vars(skip_cts)} {
                  continue
               }
            }
         }
  
         if {($step == "prects") && $vars(place_opt_design)} {
            if {!(($vars(user_mode) == "hier") && ([file tail [pwd]] == $vars(top_cell)) && $vars(enable_flexilm))} {
               continue
            }
         }
         if {($step == "cts") && $vars(skip_cts)} {
            continue
         }
         if {($step == "postcts")} {
            if {$vars(skip_cts)} {
               continue
            }
            if {[regexp "^ccopt" [string tolower $vars(cts_engine)]]} {
               if {$vars(cts_engine) != "ccopt_cts"} {
                  continue
               }
            }
         }
         if {($step == "postcts_hold") && $vars(postcts_setup_hold) && ($vars(cts_engine) != "ccopt_cts")} {
            continue
         }
         if {($step == "postroute_hold") && $vars(postroute_setup_hold)} {
            continue
         }
         lappend new_steps $step
      }

      return $new_steps
   }
  proc create_codegen_file {} {

      global vars

      if {[info exists vars(stylus_convert)] && $vars(stylus_convert) && [info exists vars(plugins_defined)]} {
        FF_NOVUS::convert_plugins
        set op [open codegen_create.txt w]
        puts $op "#!/grid/common/pkgs/tcltk/v8.5b3/bin/tclsh"
        puts $op "source /vols/dsg_tracker/innovus/fe/src/flowkit/tests/codegen_flowkit_template_modifier.lib.tcl"

        set timing_libs $vars($vars($vars($vars(default_setup_view),delay_corner),library_set),timing)
        set qrc_tech $vars($vars($vars($vars(default_setup_view),delay_corner),rc_corner),qx_tech_file)
        if {[info exists vars($vars($vars(default_setup_view),constraint_mode),synth_sdc)]} {
          set sdc_files $vars($vars($vars(default_setup_view),constraint_mode),synth_sdc)
        } else {
          set sdc_files $vars($vars($vars(default_setup_view),constraint_mode),pre_cts_sdc)
        }
        puts $op "codegen::template ./scripts/design_config.template \{"
        puts $op "  placeholder \{<< PLACEHOLDER: PATH TO TIMING LIBS >>\} \{ \. \}" 
        puts $op "  placeholder \{<< PLACEHOLDER: PATH TO LEF FILES >>\} \{ \. \}"
        puts $op "  placeholder \{<< PLACEHOLDER: PATH TO TECH FILES >>\} \{ \. \}"
        puts $op "  placeholder \{<< PLACEHOLDER: LIST OF TIMING LIBRARIES >>\} \{\{$timing_libs\}\}"
        puts $op "  placeholder \{<< PLACEHOLDER: LIST OF LEF FILES >>\} \{\{$vars(lef_files)\}\}"
        puts $op "  placeholder \{<< PLACEHOLDER: PROCESS NODE >>\} \{$vars(process)\}"
        puts $op "  placeholder \{<< PLACEHOLDER: QRC TECH FILE >>\} \{$qrc_tech\}"
        puts $op "  delete_placeholder \{<< PLACEHOLDER: pattern >>\}"
        puts $op "  delete \{operating_condition\}"
        if {[info exists vars(syn_load_rtl_tcl)] && [file isfile $vars(syn_load_rtl_tcl)]} {
#          puts $op "  append_after \{- Read hdl design, Flow Step Name: read_hdl\} \{"
          puts $op "  append_after \{<< PLACEHOLDER: DESIGN HDL LOAD OPTIONS >>\} \{"
          set ip [open $vars(syn_load_rtl_tcl) r]
          while {[gets $ip line]>=0} {
            puts $op "   $line"
          }
          close $ip
          puts $op "  \}"
          puts $op "  delete_placeholder \{<< PLACEHOLDER: DESIGN HDL LOAD OPTIONS >>\}"
        } else {
          puts $op "  delete_placeholder \{<< PLACEHOLDER: DESIGN HDL LOAD OPTIONS >>\}"
        }
         puts $op "  placeholder \{<< PLACEHOLDER: ELABORATION OPTIONS >>\} \{$vars(design)\}"
         puts $op "  placeholder \{<< PLACEHOLDER: SDC FILES >>\} \{$sdc_files\}"
         puts $op "  placeholder \{<< PLACEHOLDER: PHYSICAL DATA LOAD OPTIONS >>\} \{-lef \{ $vars(lef_files) \}\}"
         puts $op "  placeholder \{<< PLACEHOLDER: DESIGN DATA LOAD OPTIONS >>\} \{$vars(netlist)\}"
         if {[info exists vars(def_files)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: DEF LOAD OPTIONS >>\} \{$vars(def_files)\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: DEF LOAD OPTIONS >>\}"
         }
         if {[info exists vars(fp_file)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: FPLAN LOAD OPTIONS >>\} \{$vars(fp_file)\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: FPLAN LOAD OPTIONS >>\}"
         }
         if {[info exists vars(cpf_file)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: POWER INTENT LOAD OPTIONS >>\} \{$vars(cpf_file)\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: POWER INTENT LOAD OPTIONS >>\}"
         }
         puts $op "  delete_placeholder \{<< PLACEHOLDER: CLOCK LEAF ROUTE RULE >>\}"
         puts $op "  delete_placeholder \{<< PLACEHOLDER: CLOCK TRUNK ROUTE RULE >>\}"
         puts $op "  delete_placeholder \{<< PLACEHOLDER: CLOCK TOP ROUTE RULE >>\}"
         puts $op "\}"
         puts $op "codegen::template ./scripts/genus_config.template \{"
         puts $op "\}" 
         puts $op "codegen::template ./scripts/innovus_config.template \{"
         if {[info exists vars(process)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: PROCESS NODE >>\} \{$vars(process)\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: PROCESS NODE >>\}"
         }
         if {[info exists vars(flow_effort)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: FLOW EFFORT LEVEL >>\} \{$vars(flow_effort)\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: FLOW EFFORT LEVEL >>\}"
         }
         if {[info exists vars(tie_cells)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: TIEOFF BASE_CELL NAMES >>\} \{\{$vars(tie_cells)\}\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: TIEOFF BASE_CELL NAMES >>\}"
         }
         if {[info exists vars(cts_target_slew)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: CLOCK TRANSITION TIME TARGET >>\} \{$vars(cts_target_slew)\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: CLOCK TRANSITION TIME TARGET >>\}"
         }
         if {[info exists vars(cts_target_skew)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: CLOCK SKEW TARGET >>\} \{$vars(cts_target_skew)\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: CLOCK SKEW TARGET >>\}"
         }
         if {[info exists vars(cts_buffer_cells)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: CLOCK BUFFER BASE_CELLS NAMES >>\} \{\{$vars(cts_buffer_cells)\}\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: CLOCK BUFFER BASE_CELLS NAMES >>\}"
         }
         if {[info exists vars(cts_inverter_cells)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: CLOCK INVERTER BASE_CELLS NAMES >>\} \{\{$vars(cts_inverter_cells)\}\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: CLOCK INVERTER BASE_CELLS NAMES >>\}"
         }
         if {[info exists vars(cts_clock_gating_cells)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: CLOCK GATING BASE_CELLS NAMES >>\} \{\{$vars(cts_clock_gating_cells)\}\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: CLOCK GATING BASE_CELLS NAMES >>\}"
         }
         puts $op "  delete_placeholder \{<< PLACEHOLDER: ROUTE TYPE NAME FOR CLOCK LEAF NETS >>\}"
         puts $op "  delete_placeholder \{<< PLACEHOLDER: ROUTE TYPE NAME FOR CLOCK TRUNK NETS >>\}"
         puts $op "  delete_placeholder \{<< PLACEHOLDER: ROUTE TYPE NAME FOR CLOCK TOP NETS >>\}"
         if {[info exists vars(filler_cells)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: FILLER BASE_CELL NAMES >>\} \{\{$vars(filler_cells)\}\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: FILLER BASE_CELL NAMES >>\}"
         }
         puts $op "\}"
         puts $op "codegen::template ./scripts/tempus_config.template \{"
         if {[info exists vars(process)]} {
           puts $op "  placeholder \{<< PLACEHOLDER: PROCESS NODE >>\} \{$vars(process)\}"
         } else {
           puts $op "  delete_placeholder \{<< PLACEHOLDER: PROCESS NODE >>\}"
         }
         puts $op "\}"
         close $op
      }
  }
};# end namespace FF
