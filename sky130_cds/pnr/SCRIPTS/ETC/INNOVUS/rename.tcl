if {![info exists vars(lint)]} {
   set vars(lint) 0
}

# Overload command behavior

catch {rename setDesignMode setDesignModeOrig}
catch {rename setDelayCalMode setDelayCalModeOrig}
catch {rename setTieHiLoMode setTieHiLoModeOrig}
catch {rename setPlaceMode setPlaceModeOrig}
catch {rename setCTSMode setCTSModeOrig}
catch {rename setCCOptMode setCCOptModeOrig}
catch {rename setFillerMode setFillerModeOrig}
catch {rename setNanoRouteMode setNanoRouteModeOrig}
catch {rename setExtractRCMode setExtractRCModeOrig}
catch {rename setSIMode setSIModeOrig}

catch {rename create_library_set create_library_set_orig}
catch {rename create_rc_corner create_rc_corner_orig}
catch {rename create_delay_corner create_delay_corner_orig}
catch {rename create_constraint_mode create_constraint_mode_orig}
catch {rename create_analysis_view create_analysis_view_orig}

proc setDesignMode {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_commands "setDesignMode $args"
   } else {
      setDesignModeOrig $args
   }
}
proc setDelayCalMode {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_commands "setDelayCalMode $args"
   } else {
      setDelayCalModeOrig $args
   }
}
proc setTieHiLoMode {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_commands "setTieHiLoMode $args"
   } else {
      setTieHiLoModeOrig $args
   }
}
proc setPlaceMode {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_commands "setPlaceMode $args"
   } else {
      setPlaceModeOrig $args
   }
}
proc setCTSMode  {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_commands "setCTSMode $args"
   } else {
      setCTSModeOrig $args
   }
}
proc setCCOptMode  {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_commands "setCCOptMode $args"
   } else {
      setCCOptModeOrig $args
   }
}
proc setFillerMode  {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_commands "setFillerMode $args"
   } else {
      setFillerModeOrig $args
   }
}
proc setNanoRouteMode  {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_commands "setNanoRouteMode $args"
   } else {
      setNanoRouteModeOrig $args
   }
}
proc setExtractRCMode  {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_commands "setExtractRCMode $args"
   } else {
      setExtractRCModeOrig $args
   }
}
proc setSIMode  {args} {
   global vars
   if {$vars(lint)} { 
	  ff_edi::seed_commands "setSIMode $args"
   } else {
	  setSIModeOrig $args
   }
}

proc create_rc_corner {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_options "create_rc_corner $args"
   } else {
      create_library_set $args
   }
}

proc create_library_set {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_options "create_library_set $args"
   } else {
      create_library_set $args
   }
}

proc create_delay_corner {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_options "create_delay_corner $args"
   } else {
      create_delay_corner $args
   }
}

proc create_constraint_mode {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_options "create_constraint_mode $args"
   } else {
      create_constraint_mode $args
   }
}

proc create_analysis_view {args} {
   global vars
   if {$vars(lint)} { 
      ff_edi::seed_options "create_analysis_view $args"
   } else {
      create_analysis_view $args
   }
}

namespace eval ff_edi {

   proc seed_options {command_string} {

      global vars

      set command [lindex $command_string 0]
      set args [lreplace $command_string 0 0]

      switch $command {
         setDesignMode {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  process {
                     set vars(process) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
         setPlaceMode {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  placeIoPins {
                     set vars(place_io_pins) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  congEffort {
                     set vars(congestion_effort) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
         setOptMode {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  allEndPoints {
                     set vars(all_end_points) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  preserveAsssertions {
                     set vars(preserve_assertions) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  leakagePowerEffort {
                     set vars(leakage_power_effort) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  dynamicPowerEffort {
                     set vars(leakage_power_effort) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
         setCTSMode {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  routeClkNets {
                     set vars(route_clock_nets) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
         setNanoRouteMode {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  drouteMultiCutViaEffort {
                     set vars(multi_cut_effort) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
         create_rc_corner {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  -name {
                     set rc_corner [lindex $args 0]
                     Puts "<FF> Found rc corner $rc_corner" 
                     if {![info exists vars(rc_corners)]} {
                        set vars(rc_corners) $rc_corner
                     } else {
                        append vars(rc_corners) $rc_corner
                     }  
                     set args [lreplace $args 0 0]
                  }
                  -T {
                     set vars($rc_corner,T) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -cap_table {
                     set vars($rc_corner,cap_table) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -qx_tech_file {
                     set vars($rc_corner,qx_tech_file) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -preRoute_res {
                      set vars($rc_corner,pre_route_res_factor) [lindex $args 0]
                   }
                  -preRoute_cap {
                      set vars($rc_corner,pre_route_cap_factor) [lindex $args 0]
                   }
                  -preRoute_clkres {
                      set vars($rc_corner,pre_route_clk_res_factor) [lindex $args 0]
                   }
                  -preRoute_clkcap {
                      set vars($rc_corner,pre_route_clk_cap_factor) [lindex $args 0]
                   }
                  -postRoute_res {
                      set vars($rc_corner,post_route_res_factor) [lindex $args 0]
                   }
                  -postRoute_cap {
                      set vars($rc_corner,post_route_cap_factor) [lindex $args 0]
                   }
                  -postRoute_res {
                      set vars($rc_corner,post_route_clk_res_factor) [lindex $args 0]
                   }
                  -postRoute_clkcap {
                      set vars($rc_corner,post_route_clk_cap_factor) [lindex $args 0]
                   }
                  -postRoute_clkres {
                      set vars($rc_corner,post_route_clk_res_factor) [lindex $args 0]
                   }
                  -postRoute_xcap {
                      set vars($rc_corner,post_route_xcap_factor) [lindex $args 0]
                   }
               }
            } 
         }
         create_library_set {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  -name {
                     set library_set [lindex $args 0]
                     Puts "<FF> Found library set $library_set" 
                     if {![info exists vars(library_sets)]} {
                        set vars(library_sets) $library_set
                     } else {
                        append vars(library_sets) $library_set
                     }  
                     set args [lreplace $args 0 0]
                  }
                  -timing {
                     set vars($library_set,timing) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
         create_delay_corner {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  -name {
                     set delay_corner [lindex $args 0]
                     Puts "<FF> Found delay corner $delay_corner" 
                     if {![info exists vars(delay_corners)]} {
                        set vars(delay_corners) $delay_corner
                     } else {
                        append vars(delay_corners) $delay_corner
                     }  
                     set args [lreplace $args 0 0]
                  }
                  -library_set {
                     set vars($delay_corner,library_set) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -rc_corner {
                     set vars($delay_corner,rc_corner) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
         create_constraint_mode {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  -name {
                     set constraint_mode [lindex $args 0]
                     Puts "<FF> Found constraint mode $constraint_mode" 
                     if {![info exists vars(constraint_modes)]} {
                        set vars(constraint_modes) $constraint_mode
                     } else {
                        append vars(delay_corners) $constraint_mode
                     }  
                     set args [lreplace $args 0 0]
                  }
                  -sdc_files {
                     set vars($constraint_mode,sdc_files) [lindex $args 0]
                     set vars($constraint_mode,pre_cts_sdc) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -ilm_sdc_files {
                     set vars($constraint_mode,ilm_sdc_files) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
         create_analysis_view {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  -name {
                     set analysis_view [lindex $args 0]
                     if {![info exists vars(constraint_modes)]} {
                        set vars(analysis_views) $analysis_view
                     } else {
                        append vars(analysis_views) $analysis_view
                     }  
                     set args [lreplace $args 0 0]
                  }
                  -constraint_mode {
                     set vars($analysis_view,constraint_mode) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -delay_corner {
                     set vars($analysis_view,delay_corner) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
      }
   }

   proc seed_commands {command_string} {

      global vars

      set command [lindex $command_string 0]
      set args [lreplace $command_string 0 0]

      Puts "<FF> Processing mode commands $command ..." 

      switch $command {
         setDesignMode {
            set vars(set_design_mode) $command_string
         }
         setTieHiLoMode {
            set vars(set_tiehilo_mode) $command_string
         }
         setPlaceMode {
            set vars(set_place_mode) $command_string
         }
         setDelayCalMode {
            set vars(set_delay_cal_mode) $command_string
         }
         setOptMode {
            set vars(set_opt_mode) $command_string
         }
         setCTSMode {
            set vars(set_cts_mode) $command_string
         }
         setCCOptMode {
            set vars(set_ccopt_mode) $command_string
         }
         setFillerMode {
            set vars(set_filler_mode) $command_string
         }
         setNanoRouteMode {
            set vars(set_route_mode) $command_string
         }
         setExtractRCMode {
            set vars(set_extract_rc_mode) $command_string
         }
         setSIMode {
            set vars(set_si_mode) $command_string
         }
      }
   }
}
