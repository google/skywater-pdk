#!/usr/bin/tclsh

set msgPrefix "[file tail $argv0]"

proc flatten_list list {string map {\{ "" \} ""} $list}

proc putsFile {file} {
  set INP [open $file r]
  while {[gets $INP line] != -1}  {
    puts $line
  }
  close $INP
}

# Load Cadence Compatibility Layer when not in RTL Compiler
set isRTLCompiler [expr {[llength [info commands set_remove_assign_options]] &&
                         [llength [info commands get_attribute]] &&
                         [string equal [get_attribute program_short_name /] "rc"]}]

if {!${isRTLCompiler}} {
    if {[catch {package require compatibility} errMsg]} {
        if {[file exists buildinfra/bin/compatibility.tcl]} {
            source "buildinfra/bin/compatibility.tcl"
        } else {
            puts "Error: compatibility.tcl not found! \'compatibility.tcl\' is searched as follows:"
            puts "\t1) based on existence and contents of pkgIndex.tcl"
            puts "\t2) based on existence and contents of INFRA environment variable"
            puts "\t3) based on existence of compatibility.tcl in ../buildinfra/"
            return -code error
        }
    }
}

if {![info exists ::ns(compat)]}  { set ::ns(compat) "::aeware" }

# Default for cvs
set bomFile "BOM.txt"
set cvsStatusFile ""
set flowInfoFile ""
set appInfoFile ""
set bomVersion ""
set cvsRootDir ""

# Parse options (from compatibility layer)
switch -- [parse_options $msgPrefix {} $argv \
  "-cvs_status_file sos specifies the name of the cvs status file to analyze" cvsStatusFile \
  "-cvs_rpt_root_dir sos the root directory to use for manifest generation of cvs status reports" cvsRootDir \
  "-bom_file sos specifies the name of the BOM (manifest) file to write" bomFile \
  "-flow_info sos specifies a flow info file to use (and includes flow version info in the generated BOM)" flowInfoFile \
  "-app_info sos specifies an applet info file to use (and includes applet version info in the generated BOM)" appInfoFile \
  "-bom_version sos specifies a version to use for the BOM itself (i.e., a top level version)" bomVersion \
  "-debug bOs enable debug message output" debug ] {
  -2 { return }
  0 { return -code error }
}

file delete -force $bomFile
set OSTREAM [open $bomFile "w"]
puts $OSTREAM "#################################################################"
puts $OSTREAM "# Foundation Flow RTL->GDSII Implementation System" 
puts $OSTREAM "# Copyright (c) 1997-[clock format [clock seconds] -format %Y] Cadence Design Systems, Inc. All Rights Reserved."
puts $OSTREAM "# Version       : $bomVersion"
puts $OSTREAM "# Summary       : Foundation Flow Kit Manifest"
puts $OSTREAM "# Description   : List of kit contents. This includes"
puts $OSTREAM "#                 RC and EDI code generation packages, applets,"
puts $OSTREAM "#                 flows, and/or component scripts."
puts $OSTREAM "# Created on    : [exec date]"
puts $OSTREAM "#################################################################"
puts $OSTREAM "# Top level release content and versions:"
puts $OSTREAM "# EDIFF: $bomVersion"

#
# Only print RCFF if flowInfo was provided
# (The presence of applets does not necessarily imply the presence of the RC Foundation Flow)
#
if {$flowInfoFile ne ""} {
  puts $OSTREAM "\n# RCFF:"
}

#
# Load/Print flow version info if $flowInfoFile provided
#
if {$flowInfoFile ne ""} {
  puts $OSTREAM "#   Flows:"
  source $flowInfoFile
  set flowsTmpList [array names flowInfo -regexp {,version}]
  foreach flow $flowsTmpList {
    regsub -all {::flows::(.*),version} $flow {\1} flow
    lappend flowsList $flow
  }
  foreach flow [lsort -dictionary $flowsList] {
    if {[info exists flowInfo(::flows::$flow,version)]} {
      puts $OSTREAM "[format "#     %-*s %-*s" 40 ${flow}: 20 $flowInfo(::flows::$flow,version)]"
    }
  }
}

#
# Load/Print applet version info if $flowInfoFile provided
#
if {$appInfoFile ne ""} {
  puts $OSTREAM "#   Applets:"
  catch {source $appInfoFile}
  set appletsTmpList [array names appInfo -regexp {,version}]
  foreach applet $appletsTmpList {
    regsub -all {::applet::(.*),version} $applet {\1} applet
    lappend appletsList $applet
  }
  foreach applet [lsort -dictionary $appletsList] {
    if {[info exists appInfo(::applet::$applet,version)]} {
      puts $OSTREAM "[format "#     %-*s %-*s" 40 ${applet}: 20 $appInfo(::applet::$applet,version) ]"
    }
  }
}
#
# Analyze cvs status file and print versions if it was provided
#
if {$cvsStatusFile ne ""} {
  set filelist ""
  puts $OSTREAM "\n# Version Info For Component Scripts (For internal use only):"
  puts $OSTREAM "# -----------------------------------------------------------------------+---------"
  puts $OSTREAM "#                File Name                                               | Version "
  puts $OSTREAM "# -----------------------------------------------------------------------+---------"
  set IS [open $cvsStatusFile "r"]
  array set lineArr ""
  set lineno 1
  while {![eof $IS]} {
    gets $IS lineArr($lineno)
    if {[regexp {Repository revision:\s+(\S+)\s+(\S+),v$} $lineArr($lineno) full version fullFilePath]} {
      set re ".*$cvsRootDir/(.*)\$"
      if {$cvsRootDir ne "" && ![regexp $re $fullFilePath full File]} {
        set File $fullFilePath
      }
      lappend filelist $File
      set ${File}(version) $version
    }
    incr lineno
  }
  close $IS

  foreach File [lsort -dictionary $filelist] {
    puts $OSTREAM [format "# %-*s | %-*s" 70 $File 8 [set ${File}(version)]]
  }
}
puts $OSTREAM "#"
puts $OSTREAM "# END MANIFEST"
close $OSTREAM
