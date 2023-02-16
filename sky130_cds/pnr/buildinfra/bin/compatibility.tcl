#===========================================================================
# File Name	: Source: /net/splinter/fed/cvs/infrastructure/applets/compatibility.tcl,v 
# Date Created	: 07/20/2010
# Date Modified	: Date: 2012/03/07 02:42:47 
# Version	: Revision: 1.35
# Summary	: Provide non-standard TCL commands to enable script reuse across Cadence
# Keywords      : TCL compatibility script port EDI ae-ware ETS LEC conformal
#
# Description:
#	RC has solid TCL support but also adds several useful commands that are
#	not a standard part of TCL. Commands like add_command_help, parse_options,
#	as well as others are frequently used in RC ae-ware scripts but not supported
#       by most tools. In order to enable easy port of RC script to other tools
#	within Cadence, this scripts are needed to emulate in other tools
#	what is otherwise embedded in RC exectuable
#
# Assumptions:
#	This script will be loaded in a Cadence tool that supports TCL
#
#===========================================================================
##nagelfar syntax get_metric
##nagelfar syntax get_version
##nagelfar syntax get_version_info
##nagelfar syntax getVersion
##nagelfar syntax dbGet
##nagelfar syntax get_design
##nagelfar syntax get_root_module
##nagelfar syntax getLogFileName
##nagelfar syntax timedesign
global currTool

# Load Cadence Compatibility Layer when not in RTL Compiler
if {[expr {[llength [info commands attribute_exists]] && \
	       [attribute_exists -type root program_short_name] && \
	       [string equal [get_attribute program_short_name /] "rc"]}]} {
    set currTool rc
} else {
    switch -regexp [info nameofexecutable] {
	{/(velocity|encounter)$} { set currTool encounter }
	{/ctos(gui)?$}           { set currTool ctos }
	{/(lec|LEC|verify)$}     { set currTool lec }
	{/(tclsh|tkcon)}	 { set currTool tclsh }
	default                  { set currTool "unknown" }
    }
}

# exit if running in RTL Compiler; no emulation needed there
if {![string match "rc" ${currTool}]} { 
    # Put all ae-ware in a flat namespace to ease reference from one application to another 
    # As support for additional ae-ware is added through the compatibility layer, they will
    # likely need to be added here if they have references to other ae-ware supported through 
    # the compatiblity layer
    set ::ns(compat) "::aeware::compat"
    set ::ns(parse_opt) $::ns(compat)
    set ::ns(genrpt)    $::ns(compat)
    set ::ns(applet)    $::ns(compat)
    set ::ns(redirect)  $::ns(compat)
    set ::ns(regress)   $::ns(compat)

    if {![llength [info procs alias]]} { proc alias {commandname command} { eval {interp alias {} $commandname {}} $command } }

    alias hidden_proc proc
    alias tcl_source source
    alias lcd  cd
    alias lls  ls
    alias lpwd pwd
    alias ${::ns(compat)}::get_attr ${::ns(compat)}::get_attribute
    alias ${::ns(compat)}::set_attr ${::ns(compat)}::set_attribute
    alias ${::ns(compat)}::define_attr ${::ns(compat)}::define_attribute

    if {[string match "lec" ${currTool}]} { rename add_command_help _add_command_help }


    namespace eval $::ns(compat) {
	variable quietMode 0
	variable rootAttributes
	
	if {![llength [info commands ::add_command_help]]} { namespace export add_command_help }
	if {![llength [info commands ::calling_proc]]}     { namespace export calling_proc }
	if {![llength [info commands ::dispatch_subcommand]]} { namespace export dispatch_subcommand }
	if {![llength [info commands ::define_attribute]]} { namespace export define_attribute }
	if {![llength [info commands ::get_attribute]]} { namespace export get_attribute }
	if {![llength [info commands ::set_attribute]]} { namespace export set_attribute }
	
	proc basename {fullName} { return "[file tail $fullName]" } 

	proc convert_unit {args} {
	    switch -- [parse_options "calling_proc" {} $args				 \
			   "-to sos unit to convert input to(default is picoseconds)" toUnit \
			   "srs string containing value to convert" inputStr] {
			       -2 { return }
			       0 { return -code error }
	    }  

	    set inVal [lindex $inputStr 0]
	    set inUnit [lindex $inputStr 1]
	}

	proc EdiMetricsPresent {args} {
	    set metricsCookie ".edi_metrics"
	    file delete ${metricsCookie}
	    ##nagelfar ignore
	    ::se::save_metric_file ${metricsCookie}
	    set returnVal "false"
	    switch [llength $args] {
		0 { if {[file exists "${metricsCookie}"]} { set returnVal "true" } }
		1 {
		    if {[file exists "${metricsCookie}"]} {
			set metricFile [open ${metricsCookie} r]
			while {![eof $metricFile]} { 
			    set metricLine [gets $metricFile]
			    if {![regexp {se::save_metric\s+(.*)\s+(\{.*\})} $metricLine match metricName metricVal]} { continue }
			    if {[string match $metricName $args]} { set returnVal true; break; }
			}
			close $metricFile
		    }
		}
		default { return "Error:EdiMetricsPresent allows 1 or 0 arguments!" }
	    }
	    return ${returnVal}
	}


	proc ::aeware::compat::find {args} { 
	    global currTool

	    if {[regexp {(program_version|memory_usage|runtime)} $args]} { 
		if {[regexp {\-(des|desi|desig|design)} $args]} { return  }
		if {[regexp {(root.*\-attr|-attr.*root)} $args]} { return 1 }
	    }
	    if {[regexp {\-cost_group\s+\*} $args]} { 	    
		switch ${currTool} {
		    "encounter"  { 
			# For EDI, only safe way to do this is generating a report and extracting the path groups from there
			set logFile [open [getLogFileName] r]
			seek $logFile 0 end
			timedesign -reportonly
			timedesign -hold -reportonly
			while {![eof $logFile]} { 
			    set logLine [gets $logFile]
			    if {[regexp {\|\s+Setup mode\s+\|\s+all\s+\|\s+(.*)\s+\|} ${logLine} match rawCgInfo]} { break }
			}
			close $logFile
			regsub -all {\s+} ${rawCgInfo} "" ediCgInfo
#			regsub {\|clkgate} ${ediCgInfo} "" ediCgInfo
#			regsub {\|in2reg} ${ediCgInfo} "|inclkSrc2reg" ediCgInfo
#			regsub {\|in2out} ${ediCgInfo} "|inclkSrc2out" ediCgInfo
			return [split ${ediCgInfo} "|"]
			#		    unset -nocomplain ediCgInfo
			#		    foreach_in_collection cgName [get_path_groups] { lappend ediCgInfo [get_property $cgName name] }
			#		    puts "$ediCgInfo"
		    }
		    "ctos" { return }
		}
	    }
	    if {[regexp {\-(des|desi|desig|design)\s+(\S+)} $args match findOpt findStr]} { 
		switch ${currTool} {
		    "encounter" { return [dbGet top.name] }
		    "ctos" { return [get_design] }
		    "lec" { return [get_root_module] }
		}
	    }
	    return
	}

	proc what_is {args} { return }

	proc calling_proc {args} {
	    switch -- [parse_options "calling_proc" {} $args \
			   "nos number of levels to go back for calling procs name" levels] {
			       -2 { return }
			       0 { return -code error }
	    }  
	    
	    # default is current level
	    if {[llength $levels]} {
		if {$levels <= 0} { return -code error "Error: calling_proc argument must be > 0" }
	    } else {
		set levels 0
	    }
	    
	    # don't count this call to calling_proc
	    incr levels
	    
	    #	puts "levels = $levels"
	    #	puts "i_level = [info level]"
	    #	puts "i_level_expr = [info level [expr {[info level] - $levels}]]"
	    #	puts "index = [lindex [info level [expr {[info level] - $levels}]] 0]"
	    #	puts "ns_tail = [namespace tail [lindex [info level [expr {[info level] - $levels}]] 0]]"
	    return [namespace tail [lindex [info level [expr {[info level] - $levels}]] 0]]
	}

	proc get_attribute {args} {
	    global currTool
	    variable rootAttributes
	    variable $::ns(compat)::quietMode

	    switch -- [parse_options [calling_proc] {} $args		\
			   "srs attribute name" attrName			\
			   "srm object of interest (must be unique)" objInfo] {
			       -2 { return }
			       0 { return -code error }
	    }

	    foreach obj $objInfo {
		if {[string match "encounter" ${currTool}] &&
		    [regexp "metric_?(value|tcl)?" $obj match metricArg]} {
		    if {[llength ${metricArg}]} { 
			set metricArg "-${metricArg}" 
		    } else {
			set metricArg "-value" 
		    }
		    set metricValue "N/A"
		    if {[eval EdiMetricsPresent $attrName]} { set metricValue [eval get_metric $attrName ${metricArg}] }
		    return $metricValue
		}
		if {[regexp {slack} $attrName]} {
		    if {[eval EdiMetricsPresent timing.setup.WNS.${obj}]} {
			set metricValue [get_metric timing.setup.WNS.${obj} -value]
			return ${metricValue}
		    } else {
			puts "Warning: No \'slack\' metrics available for ${obj}"
			return "N/A"
		    }
		}
		if {!${quietMode} && ![regexp {/} $obj]} { 
		    puts "Warning: only root attributes are currently supported by Cadence Compatibility Layer(CCL)" 
		    puts "         EDI also supports metrics; specify \'metric\' as the object type" 
		    puts "\tget_attribute $attrName $objInfo"
		    return -code error
		}
	    }

	    switch -regexp -- $attrName {
		{^(runtime|super_thread_runtime|super_thread_total_runtime)$} { 
		    switch -regexp ${currTool} {
			{(encounter|ctos|lec)} {
			    set f [open "|ps -p [pid] -o cputime --noheaders"]
			    set size [string trim [read $f]]
			    close $f
			    if {[regexp {(0*(\d+)-)?0*(\d+):0*(\d+):0*(\d+)} $size -> xx days hours min sec]} {
				set secTime 0
				if {[llength ${days}]} { incr secTime [expr {$days * 24 * 60 * 60}] }
				incr secTime [expr {$hours * 60 * 60}]
				incr secTime [expr {$min * 60}]
				incr secTime $sec
			    }
			    return $secTime
			}
			{(tclsh)} {
			    set f [open "|ps -p [pid] -o cputime --noheaders"]
			    set size [string trim [read $f]]
			    close $f
			    if {[regexp {(0*(\d+)-)?0*(\d+):0*(\d+):0*(\d+)} $size -> xx days hours min sec]} {
				set secTime 0
				if {[llength ${days}]} { incr secTime [expr {$days * 24 * 60 * 60}] }
				incr secTime [expr {$hours * 60 * 60}]
				incr secTime [expr {$min * 60}]
				incr secTime $sec
			    }
			    return $secTime
			}
		    }
		}
		{^memory_usage$} { 
		    switch -regexp ${currTool} {
			{(encounter|ctos|lec)} {
			    set f [open "|ps -p [pid] -o vsz --noheaders"]
			    set size [string trim [read $f]]
			    close $f
			    return [format "%.2f" [expr {$size / 1024.0}]]
			}
		    }
		}
		{^program_version$} { 
		    switch ${currTool} {
			"encounter" { return "[getVersion]" }
			"ctos" { return [format "%s(%s)" [join [lrange [get_version] 0 2] .] [join [lrange [get_version] 4 5] {}]] }
			"lec" { return [format "%s(%s)" [lindex [get_version_info] 0] [lindex [get_version_info] 2]] }
		    }
		}
		{^lp_power_unit$} { return "nW" }
		{^lp_insert_clock_gating$} { return "false" }
		{^super_thread_servers$} { return }
		{^auto_super_thread$} { return 0 }
		default { 
		    if {[info exists rootAttributes(value,$attrName)]} { 
			return "$rootAttributes(value,$attrName)" 
		    } elseif {!${quietMode}} { 
			return -code error "Error: attribute \'$attrName\' is currently not supported by Cadence Compatibility Layer(CCL)"
			
		    }
		}
	    }
	    return
	}


	proc set_attribute {args} {
	    variable rootAttributes
	    variable $::ns(compat)::quietMode
	    
	    set quiet 0
	    if {[info exists quietMode] && ${quietMode}} { set quiet 1 }

	    switch -- [parse_options [calling_proc] {} $args				\
			   "-quiet bos keeps quiet unless there are problems" quiet		\
			   "-lock bos attribute becomes read only once locked" lockAttr	\
			   "srs attribute name" attrName					\
			   "srs new value. A compound string (containing spaces) should be represented as a list (using double-quotes or braces)" attrVal \
			   "srm object(s) of interest" objInfo] {
			       -2 { return }
			       0 { return -code error }
	    }
	    
	    foreach obj $objInfo {
		if {!${quiet} && ![regexp {/} $obj]} { 
		    puts  "Error: only root attributes are currently supported by Cadence Compatibility Layer(CCL)" 
		    puts "\t\'$attrName\' will not be set to \'$attrVal\'"
		    return -code error
		}
		if {[info exists rootAttributes(value,$attrName)]} { 
		    if {![eval IsValidArg $rootAttributes(dtype,$attrName) [list $attrVal]]} {
			puts "  set_attribute $attrName $attrVal $objInfo"
			return -code error
		    }
		    if {!$quiet} {
			puts "  Setting attribute of \'$obj\': \'$attrName\' = ${attrVal}"
		    }
		    # Support for -check_function in define_attribute
		    if {[info exists rootAttributes(checkFunc,${attrName})]} { eval $rootAttributes(checkFunc,${attrName}) ${obj} ${attrVal} }
		    set rootAttributes(value,$attrName) $attrVal 
		} else { 
		    return -code error "Error: attribute \'$attrName\' not found"
		}
	    }
	}

	proc define_attribute {args} {
	    variable rootAttributes
	    variable $::ns(compat)::quietMode

	    set checkFunc {}
	    set setFunc {}
	    set computeFunc {}

	    set checkFuncHelp "name of Tcl proc used to check value. The Tcl proc returns '1' if value is OK, '0' otherwise and requires two arguments: <object> <value>"
	    set setFuncHelp "name of Tcl proc used to set value. The Tcl proc returns the new value and requires three arguments: <object> <new_value> <current_value>"
	    set computeFuncHelp "name of Tcl proc used to compute value. If this option is used the attribute becomes read-only, since its value is always computed. The Tcl proc"

	    switch -- [parse_options [calling_proc] {} $args			\
			   "-category srs category name" catName			\
			   "-data_type srs data type (boolean, \'fixed point\', \'floating point number\', integer, string)" dataType \
			   "-obj_type srs object type" objType			\
			   "-default_value sos default value" defaultVal		\
			   "-help_string sos help string" helpString		\
			   "-more_help_string sos extended help string" extraHelp	\
			   "-hidden bos hide attribute" isHidden			\
			   "-obsolete bos obsolete attribute" isObsolete		\
			   "-check_function sos $checkFuncHelp" checkFunc		\
			   "-compute_function sos  $computeFuncHelp" computeFunc	\
			   "-set_function sos $setFuncHelp" setFunc			\
			   "-skip_in_db bos if set, command write_db will not store attribute settings in the database" skipDB \
			   "srs attribute name" attrName] {
			       -2 { return }
			       0 { return -code error }
	    }
	    
	    if {!${quietMode} && [llength $setFunc]} {
		puts "Warning: user-attributes with -set_function are not supported by Cadence Compatibility Layer(CCL)"
		puts "\tattribute \'$attrName\' will not be supported"
		return
	    }
	    
	    if {!${quietMode} && [llength $computeFunc]} {
		puts "Warning: user-attributes with -compute_function are not supported by Cadence Compatibility Layer(CCL)"
		puts "\tattribute \'$attrName\' will not be supported"
		return
	    }

	    if {!${quietMode} && ![regexp {root} $objType]} {
		puts "Warning: only root level user-attributes are supported by Cadence Compatibility Layer(CCL)"
		puts "\tattribute \'$attrName\' will not be supported"
		return
	    } 
	    
	    set rootAttributes(value,$attrName) $defaultVal 
	    set rootAttributes(dtype,$attrName) $dataType
	    set rootAttributes(value,$attrName) $defaultVal 
	    if {[llength ${checkFunc}]} { set rootAttributes(checkFunc,$attrName) $checkFunc }
	}

	# Currently, add_command_help is not emulated but implemented without doing anyhting to avoid errors
	if {![llength [info commands ::add_command_help]]} { proc add_command_help {args} {} }

	# Provide help for command containing subcommands, edit_netlist is
	# an example
	proc subcommand_help {command help subcommands} {
	    puts "  $command: $help"
	    puts "Usage: $command subcommand \[-h\]"
	    puts ""
	    puts "  The 'subcommand' can be one of the following:"
	    
	    # get length of longest command name - used to pretty print help
	    set mlen 0
	    foreach subcommand $subcommands {
		set clen [string length [lindex $subcommand 0]]
		set flag [lindex $subcommand 1]
		if {$flag eq "hidden"} {
		    continue
		}
		if {$clen > $mlen} {
		    set mlen $clen
		}
	    }
	    
	    foreach subcommand $subcommands {
		set flag [lindex $subcommand 1]
		if {$flag eq "hidden"} {
		    continue
		}
		set cmd_name [lindex $subcommand 0]
		set cmd_help [lindex $subcommand 3]
		set scount [expr {$mlen -[string length $cmd_name]}]
		set spaces [string range [string repeat " " 50] 0 $scount]
		puts "[format "%s%s- %s" $cmd_name $spaces $cmd_help]"
	    }
	}
	
	# Fire off the appropriate subcommand.  edit_netlist uses this.
	# subcommands are formatted as: <name> <hidden | visible> <cmd> <help>
	proc dispatch_subcommand {command c_args subcommands help} {
	    if {[llength $c_args] < 1} {
		subcommand_help $command $help $subcommands
		return -code error "Failed on '$command $c_args'"
	    } else {
		set subcommand [lindex $c_args 0]
		
		if {[string match "-h*" $subcommand]} {
		    subcommand_help $command $help $subcommands
		    return
		} else {
		    set matches {}
		    set mlist {}
		    set cmdhelp ""
		    
		    foreach type $subcommands {
			set this_subcommand [lindex $type 0]
			
			if {[string match "$subcommand*" $this_subcommand]} {
			    if {([lindex $type 1] eq "hidden") && \
				    ($subcommand ne $this_subcommand)} {
				continue
			    }
			    set function [lindex $type 2]
			    set cmdhelp  [lindex $type 3]
			    lappend matches $this_subcommand
			    lappend mlist $type
			}
		    }
		    
		    # get exact match for subcommand for cases with same beginning
		    # e.g. 'report power' and 'report power_domain'
		    set exact 0
		    foreach type $matches {
			if {$type eq $subcommand} {
			    set exact 1
			}
		    }
		    if {$exact} {
			set matches $subcommand
			foreach type $mlist {
			    if {$subcommand eq [lindex $type 0]} {
				set function [lindex $type 2]
				set cmdhelp  [lindex $type 3]
				break
			    }
			}
		    }
		    
		    if {[llength $matches] > 1} {
			#Get the matching subcommand with least string length
			if { [string length $subcommand] > 2 } {
			    set type [lindex [lsort -index 0 $mlist] 0]
			    set function [lindex $type 2]
			    set cmdhelp [lindex $type 3]
			    
			    puts stdout "Ambiguous subcommand: $matches"
			    puts stdout "Choosing subcommand: '[lindex $type 0]'"
			} else {
			    puts stdout "Ambiguous subcommand: $matches"
			    subcommand_help $command $help $subcommands
			    return -code error "Failed on '$command $c_args'"
			}
		    }
		    
		    if {[llength $matches] == 0} {
			puts stdout "Cannot find subcommand: $subcommand"
			subcommand_help $command $help $subcommands
			return -code error "Failed on '$command $c_args'"
		    }
		}
	    }
	    
	    # Don't use concat because concat is slow.
	    set cmd [list $function]
	    set found_help 0
	    foreach arg [lrange $c_args 1 end] {
		lappend cmd $arg
		if {($arg eq "-h")   || ($arg eq "-he") || 
		    ($arg eq "-hel") || ($arg eq "-help")} {
		    set found_help 1
		}
	    }
	    
	    # print help for hidden subcommands
	    # ARGH- the regexp is converting vdir objects into strings!
	    # Please be certain that you watch out for vdir objects.
	    #if {[regexp {\-h} $cmd] && ($cmdhelp ne "")} 
	    if {$found_help && ($cmdhelp ne "")} {
		puts "  $command $matches: $cmdhelp"
	    }
	    eval $cmd
	}
    }

    namespace eval $::ns(parse_opt) {

	if {![llength [info commands ::parse_options]]} { namespace export parse_options }

	proc UsageInfo {cmd cmdOptions} {
	    upvar $cmdOptions optInfo
	    set cmdVersion {}
	    if { [expr {[llength $cmd] > 1}] && [string is double [lindex $cmd end]] } {
		set cmdVersion [lindex $cmd end]
		set cmd [lreplace ${cmd} end end]
	    }
	    set usageString {}
	    set usageHeader "\nUsage: $cmd"
	    if {[llength ${cmdVersion}]} { set usageHeader "\nCommand Version: ${cmdVersion}\nUsage: $cmd" }
	    foreach opt [lsort [array names optInfo var,*]] {
		regsub "var,"  $opt ""      optUsage
		regsub "var,"  $opt "rqmt," optRqmt
		regsub "var,"  $opt "help," optHelp
		for {set i 0} {$i < [llength $optInfo($opt)]} {incr i} {
		    if {![regexp {b\w\w} [lindex $optInfo($optRqmt) $i]]} { append optUsage " " }
		    if {![regexp {\-.*} $optUsage]} { set optUsage "" }
		    switch -regexp [lindex $optInfo($optRqmt) $i] {
			{n\w\w} { set optUsage "${optUsage}<integer>" }
			{f\w\w} { set optUsage "${optUsage}<float>" }
			{s\w\w} { set optUsage "${optUsage}<string>" }
		    }
		    if {[regexp {\wO\w} [lindex $optInfo($optRqmt) $i]]} { continue }
		    if {[regexp {\wo\w} [lindex $optInfo($optRqmt) $i]]} { set optUsage "\[${optUsage}\]" }
		    if {[regexp {\w\wm} [lindex $optInfo($optRqmt) $i]]} { set optUsage "${optUsage}+" }
		    append usageHeader " ${optUsage}"
		    lappend usageString "    ${optUsage}:"
		    lappend usageString "        [lindex $optInfo($optHelp) $i]"
		}
	    }
	    
	    # Output usage help messsage
	    puts "$usageHeader\n"
	    foreach usageLine ${usageString} { puts "$usageLine" }
	}
	
	proc ParseHelp {} {
	    puts "
 Usage: parse_options cmd file_var args \[code var\]*

     cmd <string>:
        name of the command whose options are being parsed
     file_var <string>:
        name of variable to hold file id
     args <string>:
        options being passed to the command
     code <string>:
        option parsing directive
     var <string>:
        name of variable to hold option result

The option parsing directive should be in the form:
  (<-name> )?<x><y><z>(<dirtypes>)? <help>
  where <-name> is a flag, for example \"-max\"
    multiple string objects('srm' and 'som') are not supported for flagged options.
        <x> is a character indicating the option type
           d: directory object
           n: integer
           f: float
           b: boolean
           s: string
        <y> is a character indicating optional, required or obsolete
           o: optional
           r: required
           x: obsolete
        <z> is a character indicating single or multiple
           s: single value only
           m: multiple values accepted
        <dirtypes> is a string indicating directory types
           The types must be separated by | characters
           and must be bounded by parentheses.
           For example, (port|pin) indicates that both
           port and pin directories are accepted.
        <help> is a string returned to the user if the
           \'-h\' flag is given.
"
	}
	
	proc parse_options {args} {
	    set cmd [lindex $args 0]
	    set file_var [lindex $args 1]
	    set parseArgs [lindex $args 2]
	    set parseOptions [lrange $args 3 end]
	    set switchName {}
	    set helpString {}
	    set parseRqmt {}
	    
	    if {[info exists optInfo]} { unset optInfo }
	    if {[regexp {\-(h|he|hel|help)($|\s)} $cmd]} { 
		eval ParseHelp 
		return
	    }
	    foreach opt $parseOptions {
		if {[llength $opt] == 1} {
		    set indexName "unflagged"
		    if {[llength $switchName] == 1} { regsub -all {\s}  $switchName "" indexName }
		    switch -regexp $parseRqmt {
			{b\wm} { 
			    puts "Error: Boolean options cannot be multi-valued"
			    return -code error
			}
			{br\w} { 
			    puts "Error: Boolean options cannot be required - useless"
			    return -code error
			}
			{bos} { 
			    if {[string match "unflagged" $indexName]} { 
				puts "Error: Boolean options must be unflagged"
				return -code error
			    }
			}
			{s\wm} { 
			    if {[llength $switchName] == 1} {
				puts "Error: \'som\' and \'srm\' do not support flagged options"
				return -code error
			    }
			}
		    }
		    lappend optInfo(var,$indexName) $opt
		    lappend optInfo(rqmt,$indexName) $parseRqmt
		    lappend optInfo(used,$indexName) 0
		    lappend optInfo(help,$indexName) $helpString
		    continue
		}
		if {![regexp {^\s*(\-\w+)?\s*([dbsnf][orO][sm])(\(\S+\))?\s+(.*)} $opt match switchName parseRqmt objRqmt helpString]} {
		    puts "Error: Invalid parse requirement string"
		    eval ParseHelp
		    return -code error 
		}
	    }
	    
	    # probably needs to be removed and integrated into next parsing section
	    if {[regexp {(^|\s)\-(h|he|hel|help)($|\s)} $parseArgs]} { 
		eval UsageInfo [list $cmd] optInfo
		return -2 
	    }
	    
	    set unflagCount 0
	    if {[info exists optInfo(var,unflagged)]} { set unflagCount [llength $optInfo(var,unflagged)] }
	    set unflagIndex 0
	    set argCount [llength $parseArgs]
	    #	foreach foo [array names optInfo *] { puts "optInfo($foo) -> $optInfo($foo)" ; set ::optInfo($foo) $optInfo($foo); }
	    # Process flags and flag arguments
	    for {set i 0} {$i < $argCount} {incr i} {
		set currentArg [lindex $parseArgs $i]
		if {[regexp {\-} $currentArg]} { 
		    set matchIndex [lsearch -regexp -all [array names optInfo var,*] $currentArg]
		    if { [llength $matchIndex] > 1 } { return -code error "Error: ambiguous flag \'$currentArg\' specified" }
		    if { [llength $matchIndex] == 1 } { regsub "var," [lindex [array names optInfo var,*] $matchIndex] "" currentArg }
		}
		# Identify and process flagged options
		#	    llength [lsearch -regexp -all [array names optInfo var,*] $currentArg]
		#	    info exists optInfo(var,$currentArg)
		if { [info exists optInfo(var,$currentArg)]  || [expr {$unflagCount != 0}] } {
		    set argVal {}
		    if {[info exists optInfo(var,$currentArg)]} {
			upvar $optInfo(var,$currentArg) argVar
			set argRqmt $optInfo(rqmt,$currentArg)
			if {[regexp {b(o|O)s} $argRqmt]} { 
			    set argVar 1
			    set optInfo(used,$currentArg) 1
			    continue
			}
			# If not flagged boolean, make sure there are additional arguments
			# if not enough arguments, signal error
			incr i
			if { $i == $argCount } {
			    puts "Error: \'$currentArg\' requires a valid argument"
			    eval UsageInfo [list $cmd] optInfo
			    return -code error
			}
			set optInfo(used,$currentArg) 1
			set currentArg [lindex $parseArgs $i]
		    } else {
			upvar [lindex $optInfo(var,unflagged) $unflagIndex] argVar
			set argRqmt [lindex $optInfo(rqmt,unflagged) $unflagIndex]
			lset optInfo(used,unflagged) $unflagIndex 1
			incr unflagCount -1
			incr unflagIndex 
		    }
		} 
		
		if { ![info exists optInfo(var,$currentArg)] && 
		     [expr {$unflagCount == 0}] && 
		     [expr {[llength $argVal] != 0}] && 
		     ![regexp {\w\wm} $argRqmt] } {
		    puts "Error: \'$currentArg\' is not a valid option"
		    eval UsageInfo [list $cmd] optInfo
		    return -code error
		}
		
		if {![llength $argVal]} { 
		    if {![eval IsValidArg $argRqmt [list $currentArg]]} {
			eval UsageInfo [list $cmd] optInfo
			return -code error
		    }
		}

		lappend argVal $currentArg
		
		if {[regexp {\w\ws} $argRqmt]} { 
		    set argVar [lindex $argVal 0] 
		} else {
		    set argVar $argVal
		}
	    }
	    
	    # Check for missing 'required' arguments
	    foreach optUsed [array names optInfo used,*] {
		regsub "used," $optUsed "rqmt," optRqmt
		regsub "used," $optUsed ""      unusedArg
		for {set i 0} {$i < [llength $optInfo($optUsed)]} {incr i} {
		    if {![lindex $optInfo($optUsed) $i]} {
			switch -regexp [lindex $optInfo($optRqmt) $i] {
			    {\wr\w} {
				if {[regexp {unflagged} $unusedArg]} { set unusedArg "<string>" }
				eval UsageInfo [list $cmd] optInfo
				return -code error
			    }
			    {b(o|O)s} { 
				upvar $optInfo(var,$unusedArg) argVar
				set argVar 0
			    }
			    {(d|s|n|f)(o|O)\w} { 
				upvar $optInfo(var,$unusedArg) argVar
				if {![info exists argVar]} { set argVar {} }
			    }
			}
		    }
		}
	    }
	    return 1
	}

	proc IsValidArg {rqmt str} {
	    switch -regexp $rqmt {
		{boolean$} {
		    if {![string is boolean $str]} {
			puts "Error: \'$str\' is not of type booelan when boolean required"
			return 0
		    }
		}
		{(n\w\w|integer)$} {
		    if {![string is integer $str]} {
			puts "Error: \'$str\' is not of type integer when integer required"
			return 0
		    }
		}
		{(f\w\w|floating point)$} { 
		    if {![string is double $str]} {
			puts "Error: \'$str\' is not of type float when float required"
			return 0
		    }
		}
		default { return 1 }
	    }
	    return 1
	}
    }

    namespace eval $::ns(regress) {
	variable buffer {}
	variable delta 0.0
	variable delta_hi_margin 1.25
	variable delta_lo_margin 0.60
	variable delta_hi_margin_by_os
	array set delta_hi_margin_by_os {AIX 5.0 SunOS 3.0}
	variable ignore_no_echo 0
	variable count_levels 0

	if {![llength [info commands ::assert]]} { namespace export assert }
	if {![llength [info commands ::regress]]} { namespace export regress }

	# -------------------------------------------------------------------------
	# assert -- asserts that an expression evaluates to non-zero.
	#   Used in regression tests
	proc assert {args} {
	    switch -- [parse_options [calling_proc] {} $args \
			   "srs expression to test the assertion against - return zero will produce error" test_expr] {
			       -2 { return }
			       0 { return -code error "Failed on assert" }
	    }

	    if {[catch {uplevel expr [list $test_expr]} rsl] == 1} { return -code error "Failed on badly formed assert: $rsl" }
	    if {!$rsl} { return -code error "Failed on assert(\{$test_expr\})" }
	    return
	}

	# -------------------------------------------------------------------------
	# regress
	#   Used in regression tests
	proc regress {args} {
	    variable $::ns(regress)::buffer
	    variable $::ns(regress)::count_levels
	    variable $::ns(regress)::delta
	    variable $::ns(regress)::ignore_no_echo

	    set help_str {
		e.g.  regress { 
		    puts foo
		} {
		    see "f"
		    see_no "x"
		}
		Supported regress commands are:
		see - find a string in the output buffer and advance to the end of what matched
		peek - find a string in the output buffer but don't advance
		see_no - don't find a string in the output buffer
		rsee - regular expression version of see
		rpeek - regular expression version of peek
		rsee_no - regular expression version of see_no
	    }

	    switch -- [parse_options [calling_proc] {} $args \
			   "-no_echo bos don't print anything in the log" no_echo \
			   "srs code to check" script \
			   "srs checking script \n$help_str" see_commands] {
			       -2 { return }
			       0 { return -code error "Failed on regress" }
	    }

	    set last_buffer "buffer"
	    set last_delta "delta"

	    # lint
	    set rsl {}

	    incr count_levels
	    if {$no_echo && !$ignore_no_echo} {
		set script_ok 1
		##nagelfar ignore E Bad option -mesg to redirect
		redirect -mesg -variable buffer {
		    if {[catch {uplevel $script} rsl]} {
			set script_ok 0
		    }
		}
		if { $script_ok == 0 } {
		    puts $buffer
		    set buffer $last_buffer
		    return -code error "$rsl\nFailed on regress"
		}
	    } else {
		##nagelfar ignore E Bad option -mesg to redirect
		redirect -mesg -variable -tee "buffer" {
		    if {[catch {uplevel $script} rsl]} {
			set buffer $last_buffer
			return -code error "$rsl\nFailed on regress"
		    }
		}
	    }
	    incr count_levels -1

	    ##nagelfar ignore Only braced
	    if {[catch {namespace eval $::ns(regress) $see_commands} eval_rsl]} {
		if { $no_echo && !$ignore_no_echo } {
		    puts $buffer
		}
		if {! [regexp "Failed on" $eval_rsl]} {
		    set buffer $last_buffer
		    set delta $last_delta
		    return -code error "$eval_rsl\nFailed on regress"
		}
		return -code error $eval_rsl
	    }

	    set buffer $last_buffer
	    set delta $last_delta

	    return $rsl
	}
    
	# Check for the given string in the current buffer, but leave
	# the buffer alone
	proc peek {string} {
	    variable $::ns(regress)::buffer

	    set index [string first $string $buffer]
	    if {$index < 0} {
		return -code error "Failed on \'regress peek\' [list $string]"
	    }
	}

	# Check for the given string in the current buffer, and chop
	# off everything in the buffer up through what matched
	proc see {string} {
	    variable $::ns(regress)::buffer

	    set index [string first $string $buffer]
	    if {$index < 0} {
		return -code error "Failed on \'regress see\' [list $string]"
	    }
	    # move the current position after what we just matched
	    set index [expr {$index + [string length $string]}]
	    set buffer [string range $buffer $index end]
	}

	# Check that the given string doesn't exist in the current
	# buffer.
	proc see_no {string} {
	    variable $::ns(regress)::buffer

	    set index [string first $string $buffer]
	    if {$index >= 0} {
		return -code error "Failed on \'regress see_no\' [list $string]"
	    }
	}

	# Check that the given regular expression matches in the current
	# buffer.
	proc rpeek {regexp} {
	    variable $::ns(regress)::buffer

	    if {! [regexp -- $regexp $buffer]} {
		return -code error "Failed on \'regress rpeek\' [list $regexp]"
	    }
	}

	# Check that the given regular expression matches in the current
	# buffer and chop off everything in the buffer up through what
	# matched.
	proc rsee {regexp} {
	    variable $::ns(regress)::buffer

	    if {! [regexp -- $regexp $buffer match]} {
		return -code error "Failed on \'regress rsee\' [list $regexp]"
	    }

	    # move the current position after what we just matched
	    set index [string first $match $buffer]
	    assert {$index >= 0}
	    set index [expr {$index + [string length $match]}]
	    set buffer [string range $buffer $index end]
	}

	# Check that the given regular expression doesn't match in the current
	# buffer.
	proc rsee_no {regexp} {
	    variable $::ns(regress)::buffer

	    if {[regexp -- $regexp $buffer]} {
		return -code error "Failed on \'regress rsee_no\' [list $regexp]"
	    }
	}

    }


    namespace eval $::ns(redirect) {
	if {![llength [info commands ::redirect]]} { namespace export redirect }

	proc write_gzip_file {filename} {
	    set gzip_com [exec which gzip]
	    if {[llength $gzip_com] == 0} {
		return -code error \
		    "Failed on 'write_gzip_file': unable to find gzip command"
	    }
	    if {[catch {open "|$gzip_com -c > $filename" w} file_id]} {
		return -code error \
		    "Failed on 'write_gzip_file': unable to open $filename"
	    }
	    return $file_id
	}
	
	proc append_gzip_file {filename} {
	    set gzip_com [exec which gzip]
	    if {[llength $gzip_com] == 0} {
		return -code error \
		    "Failed on 'append_gzip_file': unable to find gzip command"
	    }
	    if {[catch {open "|$gzip_com -c >> $filename" a} file_id]} {
		return -code error \
		    "Failed on 'append_gzip_file': unable to open $filename"
	    }
	    return $file_id
	}
	
	
	if {! [llength [info commands ::tcl_puts]]} {  
	    rename ::puts ::tcl_puts 
	} elseif {![llength [info commands $::ns(redirect)::file_puts]]} {
	    puts "Warning: \'puts\' could not be aliased to \'tcl_puts\'"
	    puts "\t\'tcl_puts\' already exists"
	}
	
	# make puts refer to the new tcl_puts
	interp alias {} ::puts {} ::tcl_puts
	
	# A replacement version of puts.  All this layer does is to send puts
	# commands that would have gone to stdout to the filehandle
	# given in the file argument
	proc file_puts {tee file args} {
	    switch [llength $args] {
		1 {
		    ::tcl_puts $file [lindex $args 0]
		    if {$tee} {
			::tcl_puts [lindex $args 0]
		    }
		}
		
		2 {
		    if {[lindex $args 0] eq "-nonewline"} {
			::tcl_puts -nonewline $file [lindex $args 1]
			if {$tee} {
			    ::tcl_puts -nonewline [lindex $args 1]
			}
		    } elseif {[lindex $args 0] eq "stdout"} {
			::tcl_puts $file [lindex $args 1]
			if {$tee} {
			    ::tcl_puts [lindex $args 1]
			}
		    } else {
			::tcl_puts [lindex $args 0] [lindex $args 1]
		    }
		}
		
		3 {
		    if {[lindex $args 1] eq "stdout"} {
			::tcl_puts [lindex $args 0] $file [lindex $args 2]
			if {$tee} {
			    ::tcl_puts [lindex $args 0] [lindex $args 2]
			}
		    } else {
			::tcl_puts [lindex $args 0] [lindex $args 1] [lindex $args 2]
		    }
		}
		
		default {
		    eval {::tcl_puts $args}
		}
	    }
	}
	
	# A replacement version of puts.  All this layer does is to send puts
	# commands that would have gone to stdout to the variable given
	# in the given level's stack frame
	proc var_puts {tee args} {
	    variable result
	    
	    switch [llength $args] {
		1 {
		    append result [lindex $args 0] "\n"
		    if {$tee} {
			::tcl_puts [lindex $args 0]
		    }
		}
		
		2 {
		    if {[lindex $args 0] eq "-nonewline"} {
			append result [lindex $args 1]
			if {$tee} {
			    ::tcl_puts -nonewline [lindex $args 1]
			}
		    } elseif {[lindex $args 0] eq "stdout"} {
			append result [lindex $args 1] "\n"
			if {$tee} {
			    ::tcl_puts [lindex $args 1]
			}
		    } else {
			::tcl_puts [lindex $args 0] [lindex $args 1]
		    }
		}
		
		3 {
		    if {[lindex $args 1] eq "stdout"} {
			append result [lindex $args 2]
			if {$tee} {
			    ::tcl_puts [lindex $args 0] [lindex $args 2]
			}
		    } else {
			::tcl_puts [lindex $args 0] [lindex $args 1] [lindex $args 2]
		    }
		}
		
		default {
		    eval "::tcl_puts $args"
		}
	    }
	}
	
	proc redirect {args} {
	    switch -- [parse_options [calling_proc] {} $args \
			   "-append   bos appends to the file or variable" append \
			   "-tee      bos writes to stdout also" tee \
			   "-mesg     bos ignored for all other tools (for now)" mesg \
			   "-variable bos writes to Tcl variable instead of a file" variable \
			   "srs the file or variable name to write into" file_var_name \
			   "srs the Tcl code to execute" script] {
			       -2 { return }
			       0 { return -code error }
	    }

	    if {([llength $file_var_name] != 1) && \
		    ([string index $file_var_name 0] ne "|")} {
		return -code error "$file_var_name doesn't look like a filename"
	    }
	    
	    if {$variable} {
		# remember what the alias for puts is currently so we can restore it
		set prev_alias [interp alias {} ::puts]
		# override the current puts alias
		interp alias {} ::puts {} $::ns(redirect)::var_puts $tee
		
		# remember the value of the redirect buffer so we can restore it
		namespace eval $::ns(redirect) {
		    if {[info exists result]} { set prev_result $result }
		    set result {} 
		}
	    } else {
		# open the file requested
		if {[file extension $file_var_name] eq ".gz"} {
		    if {$append} {
			set file [append_gzip_file $file_var_name]
		    } else {
			set file [write_gzip_file $file_var_name]
		    }
		} else {
		    if {$append} {
			set file [open $file_var_name a]
		    } else {
			set file [open $file_var_name w]
		    }
		}
		# remember what the alias for puts is currently so we can restore it
		set prev_alias [interp alias {} ::puts]
		
		# override the current puts alias
		interp alias {} ::puts {} [set ::ns(redirect)]::file_puts $tee $file
	    }
	    
	    # evaluate the given script
	    set error [catch {uplevel $script} rsl]
	    
	    # put the puts alias back where it was before
	    eval {interp alias {} ::puts {}} $prev_alias
	    
	    if {$variable} {
		upvar $file_var_name my_variable
		if {$append} {
		    append my_variable [namespace eval $::ns(redirect) { set result }]
		} else {
		    set my_variable [namespace eval $::ns(redirect) { set result }]
		}
		if {[namespace eval $::ns(redirect) { info exists prev_result }]} {
		    if {$tee} { namespace eval $::ns(redirect) { append prev_result $result } }
		    namespace eval $::ns(redirect) { set result $prev_result }
		}
	    } else {
		# put the stdout handle back where it was before
		close $file
	    }
	    
	    # return the results of the executed script
	    if {$error} {
		return -code "error" $rsl
	    }
	    return $rsl
	}
    }

    # This section added to implement compatible attributes or dummies for compatibility purposes
    namespace eval $::ns(compat) {
	# This attribute is defined such that setting it in all tools does not cause any errors
	# however, the attribute may not perform the intended tasks in all tools
	catch {
	    define_attribute			 \
		-category compatibility		 \
		-data_type string		 \
		-obj_type root			 \
		-default_value 	"<compatiblity-only>" \
		-help_string "Require all commands executed in the session to be echo'ed to the log." \
		source_verbose
	}

	catch {
	    define_attribute			 \
		-category compatibility		 \
		-data_type boolean		 \
		-obj_type root			 \
		-default_value 	true		 \
		-help_string "do not echo CCL warning messages" \
		ccl_display_warnings
	}
    }

    if {![llength [info commands ::define_attribute]]} { 
	namespace import $::ns(compat)::define_attribute
    }

    if {![llength [info commands ::set_attribute]]} { 
	namespace import $::ns(compat)::set_attribute
    }

    if {![llength [info commands ::get_attribute]]} { 
	namespace import $::ns(compat)::get_attribute
    }

    if {![llength [info commands ::dispatch_subcommand]]} { 
	namespace import $::ns(compat)::dispatch_subcommand
    }

    if {![llength [info commands ::redirect]]} { 
	namespace import $::ns(redirect)::redirect
    }

    if {![llength [info commands ::assert]]} { 
	namespace import $::ns(regress)::assert
    }

    if {![llength [info commands ::regress]]} { 
	namespace import $::ns(regress)::regress
    }

    if {![llength [info commands ::add_command_help]]} { 
	namespace import $::ns(compat)::add_command_help 
    }

    if {![llength [info commands ::calling_proc]]} { 
	namespace import $::ns(compat)::calling_proc 
	add_command_help calling_proc "Enable porting of RC ae-ware scripts"
    }

    if {[llength [info commands $::ns(compat)::parse_options]]} { 
      if {![llength [info commands ::parse_options]]} {
	namespace import $::ns(parse_opt)::parse_options
	add_command_help parse_options "Enable porting of RC ae-ware scripts"
      }
    }

    add_command_help $::ns(compat)::define_attribute "Enable porting of RC ae-ware scripts"
    add_command_help $::ns(compat)::get_attribute "Enable porting of RC ae-ware scripts"
    add_command_help $::ns(redirect)::redirect "redirects stdout to a file or variable temporarily" 

    regexp {\d+(\.\d+)+} {Revision: 1.35} pkgRev
    package provide compatibility $pkgRev
}

# parse_options bla {} "-a dd -b -c ff st1 st2" "-a srs a opt" aopt  "-b bos b bool" bopt  "-c srs c option" copt  "srs unflagged 1" u1  "srs unflagged 2" u2
# parse_options bla {} "-a dd" "-a srs a opt" aopt
# parse_options bla {} "-b" "-b bos b bool" bopt
# parse_options bla {} "st1" "srs unflagged 1" u1
# parse_options bla {} "4 -fii" "nos unflagged 1" u1
# parse_options test {} "-help" "-c srs cat" copt "-set_function sos sfunc" sopt
# parse_options test {} "-he" "-helper bos dummy" hbool
# parse_options bla {} {-c dskj -d jdskla -help_string "dsd djskal"} "-c srs cat" copt "-d srs dtype" dopt "-help_string sos hstring" hopt
# parse_options bla {} {-c dskj -d jdskla -help_string "dsd djskal"} "-c_1 srs cat" copt "-d_1 srs dtype" dopt "-help_string sos hstring" hopt
# parse_options bla {} {-c dskj } "-c_1 srs cat" copt
# parse_options bla {} "fieldInfo emac" "srm opt" aopt
# define_attribute -obj obj -data data -cat cat -def def -comp comp -help_s help bla

#===========================================================================
#
# Copyright 1997-2013 Cadence Design Systems, Inc.  All rights reserved worldwide. 
#
# The Tcl computer program and related information (collectively "Licensed Material") 
# contained herein are protected by copyright law and international treaties. 
#
# Cadence grants Recipient of the Licensed Material a nonexclusive right
# to use, copy, and modify the Licensed Material.   Should Recipient
# desire to distribute any portion of the Licensed Material, Recipient
# must obtain Cadence's permission.  In no event shall Recipient use the 
# Licensed Material for benchmarking purposes against Cadence's products.   
#
# The Licensed Material is provided to Recipient to use at Recipient's
# own risk. The Licensed Material may not be compatible with current or 
# future versions of Cadence products, and Cadence will not provide any 
# technical support for the Licensed Material, whether modified or not 
# by the Recipient.  THE LICENSED MATERIAL IS PROVIDED "AS IS" AND WITH 
# NO WARRANTIES, INCLUDING WITHOUT LIMITATION ANY EXPRESS WARRANTIES OR 
# IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE.
#
# IN NO EVENT SHALL CADENCE BE LIABLE TO RECIPIENT OR ANY THIRD PARTY
# FOR ANY INCIDENTAL, INDIRECT, SPECIAL OR CONSEQUENTIAL DAMAGES, OR ANY 
# OTHER DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR
# LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS 
# INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OR
# INABILITY TO USE LICENSED MATERIAL, WHETHER OR NOT THE POSSIBILITY OR 
# CAUSE OF SUCH DAMAGES WAS KNOWN TO CADENCE.
#
# Cadence Design Systems, Inc.
# 2655 Seely Avenue
# San Jose, CA 95134
#
#===========================================================================


