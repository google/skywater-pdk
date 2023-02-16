#  
#  Oklahoma State University
#  Makefile for synthesis
# 
NAME := synth

VARIANT := 18T_ms

default:
	@echo "Basic synthesis procedure for SKY130:"
	@echo

synth:
	@sed -i 's/18T_ms/${VARIANT}/g' genus_script.tcl
	@sed -i 's/18T_ms/${VARIANT}/g' constraints_top.sdc
	@echo "Synthesizing using Cadence Genus"
	@mkdir -p reports
	genus -f genus_script.tcl|tee synth.log 

clean:
	rm -rf reports genus.log
	rm -f genus.cmd*
	rm -f genus.log*
	rm -f filenames*.log

   


