# %CopyrightNotice

namespace eval ff_procs:: {

###############################################################################
# Procedure to seed certain flow variables to a known default value as well
# as data variables required to seed the generic configuration file
###############################################################################

   proc load_path_groups {file} {

      read_dc_script $file

   } 

   proc source_plug {plugin {abort 1}} {

      global vars
      global plugin_error
      global errorInfo
      global return_code

  
      if {[info exists vars($plugin)]} {
         Puts "<FF> LOADING '$plugin' PLUG-IN FILE(s) "
         foreach plugin $vars($plugin) {
            if {[file exists $plugin]} {
               Puts "<FF> -> $plugin"
               if { [ catch { uplevel source $plugin } plugin_error ] } {
                  Puts "<FF> ============= PLUG-IN ERROR =================="
                  Puts "<FF> $errorInfo"
                  Puts "<FF> $plugin_error"
                  Puts "<FF> =============================================="
                  set return_code 99
                  if {[info exists vars(mail,to)]} {
                     set msg "From: [exec whoami] "
                     append msg \n "To: " [join $vars(mail,to) ,]
                     append msg \n "Cc: " [join "" ,]
                     append msg \n "Subject: " "FF: $vars(design), $vars(step) failed ([pwd])"
                     append msg \n\n $errorInfo
                     exec /usr/lib/sendmail -oi -t << $msg
                  }

                  if {$abort} {
                     exit $return_code
                  }
               }
            } else {
               if {[file exists $vars(plug_dir)/$plugin]} {
                  Puts "<FF> -> $vars(plug_dir)/$plugin"
                  if { [ catch { uplevel source $vars(plug_dir)/$plugin } plugin_error ] } {
                     if {[info exists vars(mail,to)]} {
                        set msg "From: [exec whoami] "
                        append msg \n "To: " [join $vars(mail,to) ,]
                        append msg \n "Cc: " [join "" ,]
                        append msg \n "Subject: " "FF: $vars(design), $vars(step) failed ([pwd])"
                        append msg \n\n $errorInfo
                        exec /usr/lib/sendmail -oi -t << $msg
                     }
                     set return_code 99
                     if {$abort} {
                        exit $return_code
                     }
                  }
               }
            }
         }
      }
   }
   
   proc report_time {} {
      global vars
   
      set run_time [expr [clock seconds] - $vars($vars(step),start_time)]
   
      if {$run_time > 86400} {
         set days [expr $run_time / 86400]
      } else {
         set days 0
      }
      set run_time [clock format $run_time -format %H:%M:%S -gmt true]
      Puts "<FF> =============================================="
      Puts "<FF>          COMPLETED STEP : $vars(step)"
      Puts "<FF>         ELAPSED RUNTIME : $days days, $run_time"
      Puts "<FF> =============================================="
   }
   
   proc modify_power_domains {} {
   
     global vars
     
     ####################################################################################
     ### modify power domain
     ####################################################################################
   
      set vars(power_domains) [ff_procs::get_power_domains]
       
      foreach domain $vars(power_domains) {
         if {[info exists vars($domain,bbox)] || \
             [info exists vars($domain,rs_exts)] || \
             [info exists vars($domain,min_gaps)]} {
            Puts "<FF> Modifying power domain $domain ..."
            set command "modifyPowerDomainAttr $domain "
            if {[info exists vars($domain,bbox)]} {
               append command "-box $vars($domain,bbox) "
            }
            if {[info exists vars($domain,rs_exts)]} {
               append command "-rsExts $vars($domain,rs_exts) "
            }
            if {[info exists vars($domain,min_gaps)]} {
               append command "-minGaps $vars($domain,min_gaps) "
            }
            eval $command
         }
      }
   }
   proc add_power_switches {{domains ""}} {
   
     global vars
     global map
     
     ####################################################################################
     ### add power switch
     ####################################################################################
     
      source $vars(script_root)/ETC/EDI/map_options.tcl
   
      if {$domains == ""} {
         set domains [ff_procs::get_power_domains]
      }
   
      foreach domain $domains {
         if {[info exists vars($domain,switchable)] && $vars($domain,switchable)} {
      
            deletePowerSwitch -$vars($domain,switch_type) -powerDomain $domain
      
            set command "addPowerSwitch -powerDomain $domain -$vars($domain,switch_type) "

            if {[info exists vars($domain,distribute)] && $vars($domain,distribute)} {
               append command "-distribute "
            }
            if {[info exists vars($domain,checker_board)] && $vars($domain,checker_board)} {
               append command "-checkerBoard "
            }
            if {[info exists vars($domain,back_to_back_chain)] && $vars($domain,back_to_back_chain)} {
               append command "-backToBackChain "
            }
            if {[info exists vars($domain,loop_back_at_end)] && $vars($domain,loop_back_at_end)} {
               append command "-loopbackAtEnd "
            }
            if {[info exists vars($domain,check_height)] && !$vars($domain,check_height)} {
               append command "-noDoubleHeightCheck "
            }
            if {[info exists vars($domain,verify_rows)] && !$vars($domain,verify_rows)} {
               append command "-noRowVerify "
            }
            if {[info exists vars($domain,enable_chain)] && !$vars($domain,enable_chain)} {
               append command "-noEnableChain "
            }
            
            foreach option [array names map] {
               if {[info exists vars($domain,$option)]} {
                  append command "-$map($option) $vars($domain,$option) "
              }
            }
      
            eval $command
         }
      }
   }

   proc get_power_domains {} {
     set power_domains [list]
     dbForEachPowerDomain [dbgHead] pd {
        if {[dbGroupHInstList [dbPowerDomainName $pd]] != "0x0"} {
           lappend power_domains [dbPowerDomainName $pd]
        }
     }
     return $power_domains
   }
     
   proc route_secondary_pg_nets {} {
     
     Puts "<FF> ROUTING SECONDARY POWER NETS ..."
     
     global vars
     
     # Enable global pin pairs (if defined)
     if {[info exists vars(secondary_pg,cell_pin_pairs)]} {
        setPGPinUseSignalRoute $vars(secondary_pg,cell_pin_pairs)
     
        # Build commands for individual nets (if defined)
        if {[info exists vars(secondary_pg,nets)]} {
           foreach net $vars(secondary_pg,nets) {
              # Set options to globals if they exist
              if {[info exists vars($net,pattern)]} {
                 set pattern $vars($net,pattern)
              } elseif {[info exists vars(secondary_pg,pattern)]} {
                 set pattern $vars(secondary_pg,pattern)
              }
              if {[info exists vars($net,max_fanout)]} {
                 set max_fanout $vars($net,max_fanout)
              } elseif {[info exists vars(secondary_pg,max_fanout)]} {
                 set max_fanout $vars(secondary_pg,max_fanout)
              }
              if {[info exists vars($net,non_default_rule)]} {
                 set non_default_rule $vars($net,non_default_rule)
              } elseif {[info exists vars(secondary_pg,non_default_rule)]} {
                 set non_default_rule $vars(secondary_pg,non_default_rule)
              }
              if {[info exists vars($net,cell_pin_pairs)]} {
                 setPGPinUseSignalRoute $vars($net,cell_pin_pairs)
              }
              set vars($net,command) "routePGPinUseSignalRoute -nets $net"
              if {[info exists pattern]} { 
                 set vars($net,command) [format "%s -pattern %s" $vars($net,command) $pattern]
              }
              if {[info exists max_fanout]} { 
                 set vars($net,command) [format "%s -maxFanout %s" $vars($net,command) $max_fanout]
              }
              if {[info exists non_default_rule]} { 
                 set vars($net,command) [format "%s -nonDefaultRule %s" $vars($net,command) $non_default_rule]
              }
           }
           foreach net $vars(secondary_pg,nets) {
              eval $vars($net,command)
           }
        } else {
           set command "routePGPinUseSignalRoute"
           # Set options to globals if they exist
           if {[info exists vars(secondary_pg,pattern)]} {
              set command [format "%s -pattern $vars(secondary_pg,pattern)" $command]
           }
           if {[info exists vars(secondary_pg,max_fanout)]} {
              set command [format "%s -maxFanout $vars(secondary_pg,max_fanout)" $command]
           }
           if {[info exists vars(secondary_pg,non_default_rule)]} {
              set command [format "%s -nonDefaultRule $vars(secondary_pg,non_default_rule)" $command]
           }
            eval $command
        }
     } else {
       Puts "<FF> ====================================================================="
       Puts "<FF> ERROR: No cell/pin pairs defined ... please define cell/pin pairs"
       Puts "<FF>        in your setup.tcl using vars(secondary_pg,cell_pin_pairs)"
       Puts "<FF> ====================================================================="
     }
   }

   proc insert_welltaps_endcaps {} {
   
      global vars
   
      ###############################################################################
      # Insert welltaps and pre/post endcaps
      ###############################################################################
      if {[info exists vars(cpf_file)] && ([info exists vars(power_domains)] && ([llength $vars(power_domains)] > 0))} {
         set vars(power_domains) [::ff_procs::get_power_domains]
         foreach domain $vars(power_domains) {
            if {[info exists vars($domain,pre_endcap)] && 
                [info exists vars($domain,post_endcap)]} {
               addEndCap -prefix $domain \
                         -preCap $vars($domain,pre_endcap) \
                         -postCap $vars($domain,post_endcap) \
                         -powerDomain $domain 
            } elseif {[info exists vars(pre_endcap)] && 
                      [info exists vars(post_endcap)]} {
                  addEndCap -prefix $domain \
                            -preCap $vars(pre_endcap) \
                            -postCap $vars(post_endcap) \
                            -powerDomain $domain 
            }
            if {[info exists vars($domain,welltaps)] || [info exists vars(welltaps)]} {
               if {[info exists vars($domain,welltaps)]} {
                  set command "addWellTap -prefix $domain -cell $vars($domain,welltaps) -powerDomain $domain"
                  set vcommand "verifyWellTap -cells $vars($domain,welltaps) -powerDomain $domain -report $vars(rpt_dir)/welltap.rpt"
               } elseif {[info exists vars(welltaps)]} {
                  set command "addWellTap -prefix $domain -cell $vars(welltaps) -powerDomain $domain"
                  set vcommand "verifyWellTap -cells $vars(welltaps) -powerDomain $domain -report $vars(rpt_dir)/welltap.rpt"
               }
               if {[info exists vars($domain,welltaps,max_gap)] || [info exists vars($domain,welltaps,cell_interval)]} {
                  if {[info exists vars($domain,welltaps,max_gap)]} {
                     append command " -maxGap $vars($domain,welltaps,max_gap)"
                  } else {
                      append command " -cellInterval $vars($domain,welltaps,cell_interval)"
                  }
               } elseif {[info exists vars(welltaps,max_gap)] || [info exists vars(welltaps,cell_interval)]} {
                  if {[info exists vars(welltaps,max_gap)]} {
                     append command " -maxGap $vars(welltaps,max_gap)"
                  } else {
                      append command " -cellInterval $vars(welltaps,cell_interval)"
                  }
               }
               if {[info exists vars($domain,welltaps,row_offset)]} {
                  if {$vars($domain,welltaps,row_offset)} {
                     append command " -inRowOffset $vars($domain,welltaps,row_offset)"
                  }
               } elseif {[info exists vars(welltaps,row_offset)]} {
                  if {$vars(welltaps,row_offset)} {
                     append command " -inRowOffset $vars(welltaps,row_offset)"
                  }
               }
               if {[info exists vars($domain,welltaps,checkerboard)]} {
                  if {$vars($domain,welltaps,checkerboard)} {
                     append command " -checkerboard"
                  }
               } elseif {[info exists vars(welltaps,checkerboard)]} {
                  if {$vars(welltaps,checkerboard)} {
                     append command " -checkerboard"
                  }
               }
               eval $command
               if {[info exists vars(welltaps,verify_rule)]} {
                  append vcommand " -rule $vars(welltaps,verify_rule)"
                  eval $vcommand
               } else {
                  puts "<FF> Cannot run verifyWellTap because vars(welltaps,verify_rule) is not defined"
               }
            }
         }
      } else {
         if {[info exists vars(pre_endcap)] && 
             [info exists vars(post_endcap)]} {
            addEndCap -prefix ENDCAP \
                      -preCap $vars(pre_endcap) \
                      -postCap $vars(post_endcap)
         }
         if {[info exists vars(welltaps)]} {
            set command "addWellTap -prefix WELLTAP -cell $vars(welltaps) "
            set vcommand "verifyWellTap -cells $vars(welltaps) -report $vars(rpt_dir)/welltap.rpt"
            if {[info exists vars(welltaps,max_gap)] || [info exists vars(welltaps,cell_interval)]} {
               if {[info exists vars(welltaps,max_gap)]} {
                  append command " -maxGap $vars(welltaps,max_gap)"
               } else {
                  append command " -cellInterval $vars(welltaps,cell_interval)"
               }
            }
            if {[info exists vars(welltaps,row_offset)]} {
                  append command " -inRowOffset $vars(welltaps,row_offset)"
            }
            if {[info exists vars(welltaps,checkerboard)]} {
               if {$vars(welltaps,checkerboard)} {
                  append command " -checkerboard"
               }
            }
            eval $command
            if {[info exists vars(welltaps,verify_rule)]} {
               append vcommand " -rule $vars(welltaps,verify_rule)"
               eval $vcommand
            } else {
               puts "<FF> CANNOT RUN verifyWellTap BECAUSE vars(welltaps,verify_rule) IS NOT DEFINED"
            }
         }
      }
   }

   proc buffer_always_on_nets {} {

      global vars
      global errors
      global bts_nets


      if {![info exists vars(power_domains)]} {
         set vars(power_domains) [::ff_procs::get_power_domains]
      }
      set pd_buffer_list [list]
      foreach domain $vars(power_domains) {
         if {[info exists vars($domain,always_on_buffers)]} {
            set val [concat $domain $vars($domain,always_on_buffers)]
            lappend pd_buffer_list $val
         } else {
            if {[info exists vars(always_on_buffers)]} {
               set val [concat $domain $vars(always_on_buffers)]
               lappend pd_buffer_list $val
            }
         }
      }
      if {$pd_buffer_list == ""} {
         Puts "<FF> ERROR: No always-on buffers defined" 
         return
      } 

     if {[info exists vars(always_on_nets)]} {
        set bts_nets [list]
        foreach net $vars(always_on_nets) {
          set temp [join [dbFindNetsByName $net]]
          lappend bts_nets $temp
        } 

#        set temp [list]
#        if {[info exists vars(always_on_nets,max_fanout)]} {
#           set max_fanout $vars(always_on_nets,max_fanout)
#           foreach net [join $bts_nets] {
#              if {[expr [llength [dbFindInstsOnNet $net]] - 1] > $max_fanout} {
#                 lappend temp $net
#              }
#           }
#           set bts_nets [join $temp]
#        }
#
        set bts_nets [join $bts_nets]

        Puts "<FF> ========================================================="
        Puts "<FF>            Buffering always-on nets"
        Puts "<FF> ========================================================="
        Puts "<FF>               Nets ..."
        foreach net $bts_nets {
           Puts "<FF>                        $net"
        }

        set command "bufferTreeSynthesis -prefix BTS"
        append command " -nets \[list $bts_nets\]"
        append command " -powerDomainBufList \[list $pd_buffer_list\]"

        if {![catch {set arg $vars(always_on_nets,max_tran)}]} {
           append command " -maxTran $arg"
           Puts "<FF>            Max Tran -> $arg"
        }
        if {![catch {set arg $vars(always_on_nets,max_fanout)}]} {
           append command " -maxFanout $arg"
           Puts "<FF>          Max Fanout -> $arg"
        }
        if {![catch {set arg $vars(always_on_nets,max_skew)}]} {
           append command " -maxSkew $arg"
           Puts "<FF>            Max Skew -> $arg"
        }
        if {![catch {set arg $vars(always_on_nets,max_delay)}]} {
           append command " -maxDelay $arg"
           Puts "<FF>           Max Delay -> $arg"
        }

        Puts "<FF> ========================================================="

        eval $command

     } else {

        Puts "<FF> No always on nets specified"
        Puts "<FF> Please set vars(always_on_nets) in your setup.tcl"
     }
  }

   proc get_icg_pins {} {
   
     global vars
     Puts "<FF> INFO: Executing get_icg_pins"
     foreach_in_collection pin [get_lib_pins $vars(icg,base_name)*/*] {
       if {[get_property $pin direction]=="in"&&[get_property $pin is_clock_gating_enable]=="true"} {
         set name [file tail [get_property $pin name]]
         if {[info exists enable]==1&&$name!=$enable} {
           Puts "<FF> ERROR: While searching all icgs, enable pin for [get_property $pin name] does not match existing $enable"
           #exit 99
         } else {
           set enable $name
         }
       } elseif {([get_property $pin direction] == "out")} {
         set name [file tail [get_property $pin name]]
         if {[info exists clkout]==1&&$name!=$clkout} {
           Puts "<FF> ERROR: While searching all icgs, clkout pin for [get_property $pin name] does not match existing $clkout"
           #exit 99
         } else {
           set clkout $name
         }
       } elseif {([get_property $pin direction] == "in") && ([get_property $pin is_clock] == "true")} {
         set name [file tail [get_property $pin name]]
         if {[info exists clkin]==1&&$name!=$clkin} {
           Puts "<FF> ERROR: While searching all icgs, clkin pin for [get_property $pin name] does not match existing $clkin"
           #exit 99
         } else {
           set clkin $name
         }
       }
     }
     if {[info exists clkout]==0} {
       Puts "<FF> ERROR: output pin of icg $vars(icg,base_name) was not found, exiting"
       #exit 99
     }
     if {[info exists clkin]==0} {
       Puts "<FF> ERROR: clk pin of icg $vars(icg,base_name) was not found, exiting"
       #exit 99
     }
     if {[info exists enable]==0} {
       Puts "<FF> ERROR: enable pin of icg $vars(icg,base_name) was not found, exiting"
       #exit 99
     }
     set vars(icg,output_pin) $clkout
     set vars(icg,input_pin)  $enable
     set vars(icg,clock_pin)  $clkin
     Puts "<FF> INFO: Finished executing get_icg_pins"
   
   }

   proc get_buf_pins {} {
   
     global vars
     Puts "<FF> INFO: Executing get_buf_pins"
     foreach_in_collection pin [get_lib_pins $vars(anchor_buffer)/*] {
       if {[get_property $pin direction]=="in"} {
         set in [file tail [get_property $pin name]]
       } elseif {[get_property $pin direction] == "out"} {
         set out [file tail [get_property $pin name]]
       }
     }
     if {[info exists out]==0} {
       Puts "<FF> ERROR: output pin of anchor buffer $vars(anchor_buffer) was not found, exiting"
       #exit 99
     }
     if {[info exists in]==0} {
       Puts "<FF> ERROR: input pin of anchor buffer $vars(anchor_buffer) was not found, exiting"
       #exit 99
     }
     set vars(anchor_buffer,output_pin) $out
     set vars(anchor_buffer,input_pin)  $in
     set vars(buf,output_pin) $out
     set vars(buf,input_pin)  $in
   
     Puts "<FF> INFO: Finished executing get_buf_pins"
   
   }

   proc get_reg_pins {} {
   
      global vars 
      Puts "<FF> INFO: Executing get_reg_pins"
      set got_pin false
      foreach_in_collection reg [all_registers] {
         if {$got_pin} {
            return
         }
         foreach_in_collection pin [get_pins [get_property $reg hierarchical_name]/*] {
            if [get_property $pin is_clock] {
               set vars(reg,clock_pin) [file tail [get_property $pin hierarchical_name]]
               set got_pin true
            }
         }
      }
      Puts "<FF> INFO: Finished executing get_reg_pins"
   }

   proc get_tech_pin_info {} {
   
      global vars
   
      get_icg_pins
      get_buf_pins
      get_reg_pins
   
      set op [open .ff.pins.tcl w]
      foreach type {icg buf reg} {
         foreach pin {clock enable input output} {
            if {[info exists vars($type,${pin}_pin)]} {
               puts $op "set vars($type,${pin}_pin) $vars($type,${pin}_pin)"
               Puts "<FF> INFO: Found $type $pin -> $vars($type,${pin}_pin)" 
            }
         }
      }
      close $op
   }

   proc get_all_usable_bufinvs {} {
   
#     Puts "INFO: Executing get_all_usable_bufinvs"
      set buf_list ""
      set inv_list ""
      set cell_types  [dbGet head.allCells.name *] 
      foreach cell $cell_types {
         set cell_id [ dbGetCellByName  $cell]
         if { [dbIsCellDontUse $cell_id] } { continue }
         if { [dbIsCellDontTouch $cell_id] } { continue }
         if { [dbIsCellSequential $cell_id] } { continue }
         if { [::CPF::isAlwaysOnCell $cell] } { continue }
         if  { [ dbIsCellBuffer $cell_id]  } {
            lappend buf_list $cell
         } elseif { [  dbIsCellInverter $cell_id ] } {
            lappend inv_list  $cell
         }
      }
#     Puts "INFO: Found [llength $buf_list] buffers and [llength $inv_list] inverters"
#     Puts "INFO: Finished executing get_all_usable_bufinvs"
     return [list $buf_list $inv_list]
   
   }
   proc assign_cts_cells {} {

#  Puts "INFO: Executing assign_cts_cells"

      global vars
      if {![info exists vars(cts_cells)]} {
         set rc [::ff_procs::get_all_usable_bufinvs]
         set vars(cts_cells) [concat $rc]
      } else {
         set got_one 0
         foreach cell $vars(cts_cells) {
            if {[dbGetCellByName $cell]!="0x0"} {
               set got_one 1
            }
         }
         if {$got_one==0} {
            Puts "<FF> WARNING: there is no valid cell in vars(cts_cells), will auto set to all usable buffers/inverters"
            set rc [::ff_procs::get_all_usable_bufinvs]
            set vars(cts_cells) [concat $rc]
         }
      }
      set vars(cts_inverter_cells) [list]
      set vars(cts_buffer_cells) [list]
      foreach cell {$vars(cts_cells)} {
         if { [dbIsCellBuffer $cell_id] } {
            lappend vars(cts_buffer_cells) $cell
         } elseif { [dbIsCellInverter $cell_id] } {
            lappend vars(cts_inverter_cells) $cell
         }
      }
#      Puts "INFO: Finished executing assign_cts_cells"
   }

   proc enable_mmmc {} {
   
     Puts "<FF> INFO: Executing enable_mmmc"
     global vars
     # confirm default view defined
     if {[info exists vars(default_setup_view)]==0} {
       Puts "ERROR: default view vars(default_setup_view) not defined, exiting"
       #exit 99
     }
     set view $vars(default_setup_view)
     if {[info exists vars($view,delay_corner)]==0} {
       Puts "<FF> ERROR: default delay_corner vars($view,delay_corner) not defined, exiting"
       #exit 99
     }
     set dc $vars($view,delay_corner)  
     if {[info exists vars($dc,library_set)]==0} {
       Puts "<FF> ERROR: default library_set vars($dc,library_set) not defined, exiting"
       #exit 99
     } 
     set libset $vars($dc,library_set)
     if {[info exists vars($dc,rc_corner)]==0} {
       Puts "<FF> ERROR: default rc_corner vars($dc,rc_corner) not defined, exiting"
       #exit 99
     }
     set rc $vars($dc,rc_corner)
     if {[info exists vars($view,constraint_mode)]==0} {
       Puts "<FF> ERROR: default constraint_mode vars($view,constraint_mode) not defined, exiting"
       #exit 99
     }
     set mode $vars($view,constraint_mode)  
     if {[info exists vars($mode,pre_cts_sdc)]==0} {
       Puts "<FF> ERROR: pre_cts_sdc for constraint_mode $mode in vars($mode,pre_cts_sdc), exiting"
       #exit 99
     }
   
     if {[info exists vars($libset,timing)]==0} {
       Puts "<FF> ERROR: library_set $libset libraries not defined in vars($libset,timing), exiting"
       #exit 99
     }
     create_library_set -name $libset -timing $vars($libset,timing)
   
     if {[info exists vars($rc,cap_table)]==0} {
       Puts "<FF> ERROR: cap_table for rc_corner $rc not defined, exiting"
       #exit 99
     }
     if {[info exists vars($rc,pre_route_res_factor)]==0} {
       Puts "<FF> WARNING: pre_route_res_factor for rc_corner $rc not defined, setting to 1.0"
       set vars($rc,pre_route_res_factor) 1.0
     }
     if {[info exists vars($rc,pre_route_cap_factor)]==0} {
       Puts "<FF> WARNING: pre_route_cap_factor for rc_corner $rc not defined, setting to 1.0"
       set vars($rc,pre_route_cap_factor) 1.0
     }
     if {[info exists vars($rc,T)]==0} {
       Puts "<FF> WARNING: temperature for rc_corner $rc not defined, setting to 25"
       set vars($rc,pre_route_cap_factor) 25
     }
     create_rc_corner -name $rc \
                      -cap_table $vars($rc,cap_table)  \
                      -preRoute_res $vars($rc,pre_route_res_factor)  \
                      -preRoute_cap $vars($rc,pre_route_cap_factor)  \
                      -T $vars($rc,T)
   
     create_delay_corner -name $dc -library_set $libset -rc_corner $rc
     if {[file isfile [lindex vars($mode,pre_cts_sdc) 0]]} {
       if {[lsearch [all_constraint_modes] $mode] == -1} {
          create_constraint_mode -name $mode -sdc_files $vars($mode,pre_cts_sdc)
       } else {
          update_constraint_mode -name $mode -sdc_files $vars($mode,pre_cts_sdc)
       }
     }
   
     create_analysis_view -name $view -constraint_mode $mode -delay_corner $dc
     set_analysis_view -setup [list $view] -hold [list $view]
     foreach object "cell net" {
       foreach mode "early late" {
         foreach type "data clock" {
           if {[info exists vars($dc,${type}_${object}_${mode})]} {
             set generated 1
             set_timing_derate -delay_corner $dc -$type -${object}_delay -$mode $vars($dc,${type}_${object}_${mode})
           }
           if {[info exists vars($dc,${object}_${type}_${mode})]} {
             set_timing_derate -delay_corner $dc -$type -${object}_delay -$mode $vars($dc,${object}_${type}_${mode})
           }
         }
         if {[info exists vars($dc,cell_check_${mode})]} {
           set_timing_derate -delay_corner $dc -cell_check -$mode $vars($dc,cell_check_${mode})
         }
         if {[info exists vars($dc,check_cell_${mode})]} {
            set_timing_derate -delay_corner $dc -cell_check -$mode $vars($dc,check_cell_${mode})
         }
       }
     }
     if {[info exists vars(derate_tcl)]&&[file isfile $vars(derate_tcl)]} {
       source $vars(derate_tcl)
     }
     if {[info exists vars($dc,derate_tcl)]&&[file isfile $vars($dc,derate_tcl)]} {
       source $vars($dc,derate_tcl)
     }
     Puts "<FF> INFO: Finished executing enable_mmmc"
   
   }

   proc build_guides {} {
   
     Puts "<FF> INFO: Creating floorplan guides ..."
     global vars
     unlogCommand addInstToInstGroup
     unlogCommand createInstGroup
     unlogCommand deleteInstGroup
     unlogCommand setObjFPlanBoxList
     suppressMessage ENCSYC-1962
     suppressMessage ENCSYC-791
     if {[info exists vars(guides)]==1&&[llength $vars(guides)]>0} {
       foreach guide $vars(guides) {
         # Check to make sure guide has a bound and some includes
         if {[info exists vars(guide,$guide,bounds)]==0||[llength $vars(guide,$guide,bounds)]<4} {
           Puts "<FF> WARNING: Guide $guide does not have a properly specified bound, guide not created"
         } elseif {[info exists vars(guide,$guide,include)]==0||[llength $vars(guide,$guide,include)]<1} {
           Puts "<FF> WARNING: Guide $guide does not have any includes, guide not created"
         } else {
           catch {deleteInstGroup $guide}
           catch {unset insts}
           if {[info exists vars(guide,$guide,exclude)]==0} {
             set vars(guide,$guide,exclude) ""
           } else {
             regsub -all "\\\*" $vars(guide,$guide,exclude) "\.\*" excludes
           }
           foreach include $vars(guide,$guide,include) {
             foreach i [dbFindInstsByName ${include}*] {
               if {[info exists vars(guide,$guide,exclude)]==1&&[llength $vars(guide,$guide,exclude)]>0&&[regexp [join $excludes |] $i]<1} {
                 set insts($i) 1
               } elseif {[llength $vars(guide,$guide,exclude)]<1} {
                 set insts($i) 1
               }
             }
           }
           if {[info exists insts]==1&&[llength [array names insts]]>0} {
             set x1 [lindex $vars(guide,$guide,bounds) 0]
             set y1 [lindex $vars(guide,$guide,bounds) 1]
             set x2 [lindex $vars(guide,$guide,bounds) 2]
             set y2 [lindex $vars(guide,$guide,bounds) 3]
             createInstGroup $guide -guide $x1 $y1 $x2 $y2 
             set c 0
             foreach i [array names insts] {
               addInstToInstGroup $guide $i
               incr c
             } 
             set cmd "setObjFPlanBoxList Group $guide"
             foreach i $vars(guide,$guide,bounds) {
               set cmd "${cmd} $i"
             }
             catch {eval $cmd}
             Puts "<FF> INFO: Added $c instances to guide $guide"
           } else {
             Puts "<FF> WARNING: Specified guide $guide has no instances, not creating"
           }
         }
       }
     } else {
       Puts "<FF> INFO: No guides specified ... exiting"
     }
     logCommand addInstToInstGroup
     logCommand createInstGroup
     logCommand deleteInstGroup
     logCommand setObjFPlanBoxList
     Puts "<FF> INFO: Finished executing build_guides"
   
   }

   proc add_blockages {} {
   
      Puts "<FF>INFO: Creating blockages ..."
   
      global vars
   
      if {![info exists vars(blockages)]} {
         puts "<FF>INFO: No blockages info defined ... existing"
         return
      }
      set commands ""
      foreach blockage $vars(blockages) {
         switch $vars(blockage,$blockage,type) {
            hard {
               append commands "createObstruct $vars(blockage,$blockage,bounds) -name $blockage\n"
            }
            soft {
               append commands "createObstruct $vars(blockage,$blockage,bounds) -name $blockage -type soft\n"
            }
            partial {
               append commands "createObstruct $vars(blockage,$blockage,bounds) -name $blockage -type soft\n"
            }
         }
      }
   
      eval $commands
   
      Puts "<FF>INFO: Finished executing add_blockages ..."
   }

   proc save_results {{step ""}} {

      global vars
      global errors
      global env

      if {$step != ""} {
         set vars(step) $step
      } else {
         Puts "<FF> Argument 'step' required ..."
         return
      }

      set commands ""

      set args ""
      if {[info exists vars(save_rc)] && $vars(save_rc)} {
         if {[regexp "route" $vars(step)]} {
            append args " -rc"
          }
      }
      if {[info exists vars(save_constraints)] && $vars(save_constraints)} {
         append args " -tcon"
      }
  
      # BCL: Added subst around vars(dbs_dir) to resolve vars(rundir)
      set dir [subst $vars(dbs_dir)]
      set design $vars(design)
      if {[string compare -nocase $vars(dbs_format) "oa"]==0} {
         if {[lindex [split $vars(version) "."]  0] > 10} {
            if {$hier} {
               set command "saveDesign $args -cellview {$vars(oa_partition_lib) $vars(design) $vars(step)}\n"
            } else {
               set command "saveDesign $args -cellview {$vars(oa_design_lib) $vars(design) $vars(step)}\n"
            }
         } else {
            set command "saveOaDesign $vars(oa_design_lib) $design $vars(step)\n"
         }
      } else {
         if {[info exists vars(relative_path)] && $vars(relative_path)} {
            append args " -relativePath"
         }
         if {[info exists vars(absolute_lib_path)] && $vars(absolute_lib_path)} {
            append args " -absoluteLibPath"
         }
         set command "saveDesign $args $dir/$vars(step).enc -compress\n"
      }

      append commands $command

      if {![info exists env(VPATH)]} {
         set env(VPATH) "make"
      }

      if {$vars(makefile)} {
         append commands "exec /bin/touch $env(VPATH)/$step\n"
      }

      set header "#---------------------------------------------------------------------\n"
      append header "# <FF> GENERATING REPORTS\n"
      append header "#---------------------------------------------------------------------\n"

      if {$vars(report_power)} {
         set command "report_power -outfile $vars(rpt_dir)/$vars(step).power.rpt\n"
         append commands $command
      }

      if {[info exists vars(cpf_file)] && ([info exists vars(power_domains)] && ([llength $vars(power_domains)] > 0))} {
         append commands $header
         set header ""

         ######################################################################
         # Verify power domain
         ######################################################################

         set command "verifyPowerDomain -bind -gconn"
         append command " -isoNetPD $vars(rpt_dir)/$vars(step).isonets.rpt"
         append command " -xNetPD $vars(rpt_dir)/$vars(step).xnets.rpt\n"

         append commands $command

         ######################################################################
         # Run CLP
         ######################################################################

         if {$vars(run_clp) && ([auto_execok lec] != "")} {
            set command "runCLP "
            if {[info exists vars(clp_options)]} {
               append command $vars(clp_options)
            }
            append command "\n"
            append commands $command
         } else {
            if {![info exists vars(clp_warning)]} {
               puts "<FF> WARNING: UNABLE TO RUN CLP ... PLEASE MAKE SURE IT IS IN YOUR PATH"
               set vars(clp_warning) true
            }
         }
      }

#         append commands "#\n"
#         append commands "# HOUSEKEEPING\n"
#         append commands "#\n"

      if {[info exists vars(mail,to)]} {
         if {![info exists vars(mail,steps)] || \
             ([info exists vars(mail,steps)] && ([lsearch $vars(mail,steps) $vars(step)] != -1))} {
            append commands "Puts \"<FF> MAILING RESULTS TO $vars(mail,to)\"\n"
            append commands "if {\[file exists $vars(rpt_dir)/$vars(step).summary\]} {\n"
            append commands "   exec /bin/mail -s \"FF: $vars(design), $vars(step) completed (\[pwd\])\" < $vars(rpt_dir)/$vars(step).summary $vars(mail,to)\n"
            append commands "} else {\n"
            append commands "   exec /bin/mail -s \"FF: $vars(design), $vars(step) completed (\[pwd\])\" < /dev/null $vars(mail,to)\n"
            append commands "}\n"
         }
      }

#         append commands "exec /bin/touch \$env(VPATH)/$vars(step)\n"

      append commands [::FF::source_plug final_always_source_tcl]

      if {$vars(makefile)} { 
         append commands "if {\[info exists env(VPATH)\]} {\n"
         append commands "exec /bin/touch \$env(VPATH)/$vars(step)\n"
         append commands "}\n"
      }

      uplevel #0 eval $commands
   }

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

}
