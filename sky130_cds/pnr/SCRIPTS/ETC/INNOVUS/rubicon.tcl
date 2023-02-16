set r [catch {info level [expr [info level] -1]} e]

if {$r} {

   set vars(lint) 1
# Overload command behavior
   catch {rename setDesignMode setDesignModeOrig}
   catch {rename setAnalysisMode setAnalysisModeOrig}
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
   catch {rename set_analysis_view set_analysis_view_orig}
   catch {rename set_power_analysis_view set_power_analysis_view_orig}
   
   proc setDesignMode {args} {
      global vars
      if {$vars(lint)} { 
         ff_edi::seed_commands "setDesignMode $args"
         ff_edi::seed_options "setDesignMode $args"
      } else {
         setDesignModeOrig $args
      }
   }
   proc setAnalysisMode {args} {
      global vars
      if {$vars(lint)} { 
         ff_edi::seed_commands "setAnalysisMode $args"
         ff_edi::seed_options "setAnalysisMode $args"
      } else {
         setAnalysisModeOrig $args
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
         create_rc_corner_orig $args
      }
   }
   
   proc create_library_set {args} {
      global vars
      if {$vars(lint)} { 
         ff_edi::seed_options "create_library_set $args"
      } else {
         create_library_set_orig $args
      }
   }
   
   proc create_delay_corner {args} {
      global vars
      if {$vars(lint)} { 
         ff_edi::seed_options "create_delay_corner $args"
      } else {
         create_delay_corner_orig $args
      }
   }
   
   proc create_constraint_mode {args} {
      global vars
      if {$vars(lint)} { 
         ff_edi::seed_options "create_constraint_mode $args"
      } else {
         create_constraint_mode_orig $args
      }
   }
   
   proc create_analysis_view {args} {
      global vars
      if {$vars(lint)} { 
         ff_edi::seed_options "create_analysis_view $args"
      } else {
         create_analysis_view_orig $args
      }
   }
   
   proc set_analysis_view {args} {
      global vars
      if {$vars(lint)} { 
         ff_edi::seed_options "set_analysis_view $args"
      } else {
         set_analysis_view_orig $args
      }
   }
   
   proc set_power_analysis_view {args} {
      global vars
      if {$vars(lint)} { 
         ff_edi::seed_options "set_power_analysis_view $args"
      } else {
         set_power_analysis_view $args
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
            setDelayCalMode {
               while {[llength $args] > 0} {
                  set option [lindex $args 0]
                  set args [lreplace $args 0 0]
                  switch -regexp -- $option {
                     engine {
                        if {[string tolower [lindex $args 0] == "aae"} {
                           set vars(enable_si_aware) true  
                           set args [lreplace $args 0 0]
                        } 
                        if {[string tolower [lindex $args 0] == "signalstorm"} {
                           set vars(enable_ss) true  
                           set args [lreplace $args 0 0]
                        } 
                     }
                  }
               } 
            }
            setAnalysisMode {
               while {[llength $args] > 0} {
                  set option [lindex $args 0]
                  set args [lreplace $args 0 0]
                  switch -regexp -- $option {
                     cppr {
                        set vars(enable_cppr) [lindex $args 0]
                        set args [lreplace $args 0 0]
                     }
                     aocv {
                        set vars(enable_aocv) [lindex $args 0]
                        set args [lreplace $args 0 0]
                     }
                     onChipVariation {
                        set vars(enable_ocv) [lindex $args 0]
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
                        Puts "<FF> ... Found rc corner $rc_corner" 
                        if {![info exists vars(rc_corners)]} {
                           set vars(rc_corners) [list $rc_corner]
                        } else {
                           if {[lsearch $vars(rc_corners) $rc_corner] == -1} {
                              lappend vars(rc_corners) $rc_corner
                           }  
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
                     -atf_table {
                        set vars($rc_corner,atf_table) [lindex $args 0]
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
                        Puts "<FF> ... Found library set $library_set" 
                        if {![info exists vars(library_sets)]} {
                           set vars(library_sets) [list $library_set]
                        } else {
                           if {[lsearch $vars(library_sets) $library_set] == -1} {
                              lappend vars(library_sets) $library_set
                           }  
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
                        Puts "<FF> ... Found delay corner $delay_corner" 
                        if {![info exists vars(delay_corners)]} {
                           set vars(delay_corners) $delay_corner
                        } else {
                           if {[lsearch $vars(delay_corners) $delay_corner] == -1} {
                              lappend vars(delay_corners) [list $delay_corner]
                           }  
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
                        Puts "<FF> ... Found constraint mode $constraint_mode" 
                        if {![info exists vars(constraint_modes)]} {
                           set vars(constraint_modes) [list $constraint_mode]
                        } else {
                           if {[lsearch $vars(constraint_modes) $constraint_mode] == -1} {
                              lappend vars(constraint_modes) $constraint_mode
                           }  
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
                        if {![info exists vars(analysis_views)]} {
                           set vars(analysis_views) [list $analysis_view]
                        } else {
                           if {[lsearch $vars(analysis_views) $analysis_view] == -1} {
                              lappend vars(analysis_views) $analysis_view
                           }  
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
            set_analysis_view {
               while {[llength $args] > 0} {
                  set option [lindex $args 0]
                  set args [lreplace $args 0 0]
                  switch -regexp -- $option {
                     -setup {
                        set vars(setup_analysis_views) [lindex $args 0]
                        set args [lreplace $args 0 0]
                     }
                     -hold {
                        set vars(hold_analysis_views) [lindex $args 0]
                        set args [lreplace $args 0 0]
                     }
                  }
               } 
               if {![info exists vars(active_setup_views)]} {
                  set vars(active_setup_views) $vars(setup_analysis_views)
               }
               if {![info exists vars(active_hold_views)]} {
                  set vars(active_hold_views) $vars(hold_analysis_views)
               }
               if {![info exists vars(default_setup_view)]} {
                  set vars(default_setup_view) [lindex $vars(setup_analysis_views) 0]
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
            setDelayCalMode {
               set vars(set_delay_cal_mode) $command_string
            }
            setAnalysisMode {
               set vars(set_analysis_mode) $command_string
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
}
proc setFlowMode {args} {
   global vars
   while {[llength $args] > 0} {
      set option [lindex $args 0]
      set args [lreplace $args 0 0]
      switch -regexp -- $option {
         log_dir {
            set vars(log_dir) [lindex $args 0]
            set args [lreplace $args 0 0]
            Puts "<FF> ... Setting log directory to $vars(log_dir)"
         }
         rpt_dir {
            set vars(rpt_dir) [lindex $args 0]
            set args [lreplace $args 0 0]
            Puts "<FF> ... Setting report directory to $vars(rpt_dir)"
         }
         dbs_dir {
            set vars(dbs_dir) [lindex $args 0]
            set args [lreplace $args 0 0]
            Puts "<FF> ... Setting dbs directory to $vars(dbs_dir)"
         }
         cpf_timing {
            set vars(cpf_timing) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         cts_engine {
            set vars(cts_engine) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         enable_celtic_steps {
            set vars(enable_celtic_steps) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         enable_dlm {
            set vars(enable_dlm) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         fix_hold {
            set vars(fix_hold) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         fix_litho {
            set vars(fix_litho) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         mode {
            set vars(mode) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         save_constraints {
            set vars(save_constraints) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         save_rc {
            set vars(save_rc) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         skip_cts {
            set vars(skip_cts) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         skip_signoff_checks {
            set vars(skip_signoff_checks) [lindex $args 0]
            set args [lreplace $args 0 0]
         }
         steps {
            set steps [lindex $args 0]
            set args [lreplace $args 0 0]
         }
      }
   }
   if {[string tolower $vars(mode)] == "user"} {
      if {[info exists steps]} {
         set vars(steps) $steps
      }
   }
}
