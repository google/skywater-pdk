#####################################################################################
# pre place checks
#####################################################################################

#####################################################################################
# Check DESIGN
#####################################################################################
checkDesign -netlist -physicalLibrary -timingLibrary -powerGround -outDir $vars(rpt_dir)
summaryReport -noHtml -outfile $vars(rpt_dir)/$vars(design).summaryReport.rpt
reportGateCount -module $vars(design) -stdCellOnly -level 100 -outfile $vars(rpt_dir)/$vars(design).stdgatecount.rpt
reportGateCount -module $vars(design) -level 100 -outfile $vars(rpt_dir)/$vars(design).gatecount.rpt
reportNetStat 

###################################################################################
# Timing library checks
###################################################################################
setAnalysisMode -checkType setup
reportPowerDomain -file $vars(rpt_dir)/setup_libs.rpt
setAnalysisMode -checkType hold
reportPowerDomain -file $vars(rpt_dir)/hold_libs.rpt
setAnalysisMode -checkType setup

#####################################################################################
# Power domain checks
#####################################################################################
foreach PD $vars(power_domains) {
reportPowerDomain -powerDomain $PD -file $vars(rpt_dir)/$PD.rpt -shifter -isoInst -pgNet -bindLib
}

###################################################################################
# Isolation checks
###################################################################################
foreach PD $vars(power_domains) {
reportIsolation -fromPowerDomain $PD -outfile $vars(rpt_dir)/from_$PD\_iso.rpt -highlight
}

verifyPowerDomain -gconn -xNetPD -isoNetPD -bind

###################################################################################
# Check timing
###################################################################################
set_global report_timing_format {instance arc cell  net fanout load  slew delay incr_delay arrival required}
check_timing -verbose > $vars(rpt_dir)/check_timing.rpt

timeDesign -prePlace -expandedViews -numPaths 1000 -outDir $vars(rpt_dir)

puts "### End of pre-place checks"
