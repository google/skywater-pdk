   proc create_rc_corner {args} {
      global vars

      ff_map::seed_options "create_rc_corner $args"
   }
   
   proc create_library_set {args} {
      global vars

     ff_map::seed_options "create_library_set $args"
   } 
   
   proc create_timing_condition {args} {
      global vars

      ff_map::seed_options "create_timing_condition $args"
   }
   
   proc create_delay_corner {args} {
      global vars

      ff_map::seed_options "create_delay_corner $args"
   }
   
   proc update_delay_corner {args} {
      global vars

      ff_map::seed_options "update_delay_corner $args"
   }
   
   proc create_constraint_mode {args} {
      global vars

      ff_map::seed_options "create_constraint_mode $args"
   }
   
   proc create_analysis_view {args} {
      global vars

      ff_map::seed_options "create_analysis_view $args"
   }
   
   proc set_analysis_view {args} {
      global vars

      ff_map::seed_options "set_analysis_view $args"
   }
   
   proc all_analysis_views {} {
      return ""
   }
   
   proc set_power_analysis_view {args} {
      global vars

      ff_map::seed_options "set_power_analysis_view $args"
   }
   
namespace eval ff_map {

   proc seed_options {command_string} {

      global vars

      set command [lindex $command_string 0]
      set args [lreplace $command_string 0 0]

      switch $command {
         setMultiCpuUsage {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  localCpu {
                     set vars(local_cpus) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  remoteHosts {
                     set vars(remote_hosts) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  cpuPerRemoteHost {
                     set vars(cpu_per_remote_host) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
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
         setFillerMode {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  core {
                     set vars(filler_cells) [lindex $args 0]
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
                     puts "<FF>    ( Found rc corner $rc_corner )" 
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
                  -Temperature {
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
                  -qrc_tech {
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
                     puts "<FF>    ( Found library set $library_set )" 
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
         create_timing_condition {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  -name {
                     set timing_condition [lindex $args 0]
                     puts "<FF>    ( Found timing condition $timing_condition )" 
                     if {![info exists vars(timing_conditions)]} {
                        set vars(timing_conditions) $timing_condition
                     } else {
                        if {[lsearch $vars(timing_conditions) $timing_condition] == -1} {
                           lappend vars(timing_conditions) [list $timing_condition]
                        }  
                     }  
                     set args [lreplace $args 0 0]
                  }
                  -library_set {
                     set vars($timing_condition,library_set) [lindex $args 0]
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
                     puts "<FF>    ( Found delay corner $delay_corner )" 
                     if {![info exists vars(delay_corners)]} {
                        set vars(delay_corners) $delay_corner
                     } else {
                        if {[lsearch $vars(delay_corners) $delay_corner] == -1} {
                           lappend vars(delay_corners) [list $delay_corner]
                        }  
                     }  
                     set args [lreplace $args 0 0]
                  }
                  -timing_condition {
                     set vars($delay_corner,timing_condition) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -rc_corner {
                     set vars($delay_corner,rc_corner) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -library_set {
                     set vars($delay_corner,library_set) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
               }
            } 
         }
         update_delay_corner {
            while {[llength $args] > 0} {
               set option [lindex $args 0]
               set args [lreplace $args 0 0]
               switch -regexp -- $option {
                  -name {
                     set delay_corner [lindex $args 0]
                     puts "<FF>    ( Found delay corner $delay_corner )" 
                     if {![info exists vars(delay_corners)]} {
                        set vars(delay_corners) $delay_corner
                     } else {
                        if {[lsearch $vars(delay_corners) $delay_corner] == -1} {
                           lappend vars(delay_corners) [list $delay_corner]
                        }  
                     }  
                     set args [lreplace $args 0 0]
                  }
                  -timing_condition {
                     set vars($delay_corner,timing_condition) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -rc_corner {
                     set vars($delay_corner,rc_corner) [lindex $args 0]
                     set args [lreplace $args 0 0]
                  }
                  -power_domain {
                     if {![info exists vars($delay_corner,power_domains)]} {
                        set vars($delay_corner,power_domains) [lindex $args 0]
                     } else {
                        lappend vars($delay_corner,power_domains) [lindex $args 0]
                     }
                     if {![info exists vars(power_domains)]} {
                        set vars(power_domains) [lindex $args 0]
                     } else {
                        if {[lsearch $vars(power_domains) [lindex $args 0]] == -1} {
                           lappend vars(power_domains) [lindex $args 0]
                        }
                     }
                     set args [lreplace $args 0 0]
                     puts "<FF>    ( Found power domain $delay_corner )" 
                     if {![info exists vars(delay_corners)]} {
                        set vars(delay_corners) $delay_corner
                     } else {
                        if {[lsearch $vars(delay_corners) $delay_corner] == -1} {
                           lappend vars(delay_corners) [list $delay_corner]
                        }  
                     }  
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
                     puts "<FF>    ( Found constraint mode $constraint_mode )" 
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
            if {![info exists vars(default_hold_view)]} {
               set vars(default_hold_view) [lindex $vars(hold_analysis_views) 0]
            }
         }
      }
   }
}
