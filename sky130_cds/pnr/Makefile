VERSION=17.10-p003_1
VPATH=make
TCLSH=/usr/bin/tclsh
GEN_FLOW=SCRIPTS/gen_flow.tcl
SETUP_PATH=.
TOOL=innovus
ARGS=-64 -nowin
FSTEPS=init place cts postcts_hold route postroute signoff
SCRIPTS=FF
LOG=LOG
BROWSER=netscape
UPDATE=yes

STEPS = version setup init place cts postcts_hold route postroute signoff do_cleanup
FF_START = init
FF_STOP = signoff

all: version setup init place cts postcts_hold route postroute signoff do_cleanup

version:
	@echo "# Foundation Flows Version $(VERSION)"

help:
	@echo "==================================================="
	@echo "           $(VERSION)  Foundation Flows"
	@echo "==================================================="
	@echo "   Makefile Targets"
	@echo "==================================================="
	@echo "               setup : Setup Run Directory"
	@echo                  init : Design Import / Initialization               
	@echo                 place : Cell Placement                               
	@echo                   cts : Clock Tree Synthesis                         
	@echo          postcts_hold : PostCTS Hold Fixing                          
	@echo                 route : Global/Detail Route                          
	@echo             postroute : PostRoute Optimization                       
	@echo               signoff : Signoff Timing / Verify                      
	@echo "---------------------------------------------------"
	@echo "                 all : All design steps"
	@echo "              simple : Single script (all steps in a single session) - no stop/start"
	@echo "              single : Single script (all steps in a single session)"
	@echo "==================================================="
	@echo "   Makefile Options"
	@echo "==================================================="
	@echo "   VPATH : Make directory    (default make)"
	@echo "    TOOL : INNOVUS executable     (default innovus)"
	@echo "    ARGS : INNOVUS arguments      (default -nowin -64)"
	@echo "  UPDATE : Update scripts    (default yes)"
	@echo " SCRIPTS : Script directory  (default FF)"
	@echo "     LOG : Logfile directory (default LOG)"
	@echo "==================================================="


simple: setup
	FF_STOP=$(FF_STOP); VPATH=$(VPATH); export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_simple.tcl -log $(LOG)/simple.log $(ARGS)


single: setup
	FF_STOP=$(FF_STOP); VPATH=$(VPATH); export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_all.tcl -log $(LOG)/single.log $(ARGS)

setup:
	@/bin/mkdir -p $(VPATH) $(LOG)
	@/bin/touch $(VPATH)/$@

init: setup
	@mkdir -p $(LOG);
	@if [ "$(UPDATE)" = "yes" ] ; then \
		/usr/bin/tclsh SCRIPTS/gen_flow.tcl -m flat -d FF -v 17.1.0 -s . -y none -n  init ; \
	fi
	VPATH=$(VPATH); export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_init.tcl -log $(LOG)/init.log -overwrite $(ARGS)
place: init
	@mkdir -p $(LOG);
	@if [ "$(UPDATE)" = "yes" ] ; then \
		/usr/bin/tclsh SCRIPTS/gen_flow.tcl -m flat -d FF -v 17.1.0 -s . -y none -n  place ; \
	fi
	VPATH=$(VPATH); export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_place.tcl -log $(LOG)/place.log -overwrite $(ARGS)
cts: place
	@mkdir -p $(LOG);
	@if [ "$(UPDATE)" = "yes" ] ; then \
		/usr/bin/tclsh SCRIPTS/gen_flow.tcl -m flat -d FF -v 17.1.0 -s . -y none -n  cts ; \
	fi
	VPATH=$(VPATH); export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_cts.tcl -log $(LOG)/cts.log -overwrite $(ARGS)
postcts_hold: cts
	@mkdir -p $(LOG);
	@if [ "$(UPDATE)" = "yes" ] ; then \
		/usr/bin/tclsh SCRIPTS/gen_flow.tcl -m flat -d FF -v 17.1.0 -s . -y none -n  postcts_hold ; \
	fi
	VPATH=$(VPATH); export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_postcts_hold.tcl -log $(LOG)/postcts_hold.log -overwrite $(ARGS)
route: postcts_hold
	@mkdir -p $(LOG);
	@if [ "$(UPDATE)" = "yes" ] ; then \
		/usr/bin/tclsh SCRIPTS/gen_flow.tcl -m flat -d FF -v 17.1.0 -s . -y none -n  route ; \
	fi
	VPATH=$(VPATH); export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_route.tcl -log $(LOG)/route.log -overwrite $(ARGS)
postroute: route
	@mkdir -p $(LOG);
	@if [ "$(UPDATE)" = "yes" ] ; then \
		/usr/bin/tclsh SCRIPTS/gen_flow.tcl -m flat -d FF -v 17.1.0 -s . -y none -n  postroute ; \
	fi
	VPATH=$(VPATH); export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_postroute.tcl -log $(LOG)/postroute.log -overwrite $(ARGS)
signoff: postroute
	@mkdir -p $(LOG);
	@if [ "$(UPDATE)" = "yes" ] ; then \
		/usr/bin/tclsh SCRIPTS/gen_flow.tcl -m flat -d FF -v 17.1.0 -s . -y none -n  signoff ; \
	fi
	VPATH=$(VPATH); export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_signoff.tcl -log $(LOG)/signoff.log -overwrite $(ARGS)
debug_%:
	VPATH=$(VPATH); export STEP=$* ; export VPATH; $(TOOL) -init $(SCRIPTS)/INNOVUS/run_debug.tcl -log $(LOG)/$@.log -win $(ARGS:-nowin=)

lec_%:
	export STEP=$* ; lec -64 -xl -Dofile $(SCRIPTS)/INNOVUS/run_lec.tcl -NOGui -LOGfile $(LOG)/$@.log

help_%:
	/usr/bin/tclsh $(GEN_FLOW) -H $*

.PHONY: clean

clean:
	/bin/mv *.rpt RPT ;\
	/bin/rm -fr extLogDir* __qrc.log *cts_trace *.rpt.old *delete* placementReports* *.rguide *_mmmc \
	*_constr.pt .constr* .FE* .routing* .timing_file* .tdrlog*
	rm -rf make/*
	rm -rf LOG DBS RPT
	rm -rf innovus.cmd*
	rm -rf innovus.log*
	rm -rf checkDesign
	rm -rf timingReports
	rm -f final.gds
	rm -f final.v

do_cleanup: signoff
	$(MAKE) clean
	/bin/touch $(VPATH)/$@

reset : version
	/bin/rm -fr $(VPATH)/* extLogDir* __qrc.log *cts_trace *.rpt.old *delete* placementReports* *.rguide *_mmmc
	@for file in $(STEPS) ; \
	do \
		if [ -r $(VPATH)/$$file ] ; then \
			/bin/rm $(VPATH)/$$file ; \
		fi \
	done

block_%: setup
	@if [ "x$*" = "xsingle" ] ; then \
		ff_stop=$(FF_STOP); \
		target="$@ (from: $(FF_START) to: $(FF_STOP))"; \
	else \
		ff_stop=$* ; \
		target=$@; \
	fi; \
	if [ -r $(VPATH)/.RUNNING ] ; then \
		echo "INFO: A build seems to be running already... check $(VPATH)/.RUNNING file and remove that file if the process is dead" ; \
		/bin/head -1  $(VPATH)/.RUNNING ; \
		exit -1 ; \
	else \
		/bin/rm -f $(VPATH)/block_$${ff_stop}.DONE $(VPATH)/block_$${ff_stop}.FAILED $(VPATH)/block_$${ff_stop}.PASS ; \
		(echo "# Started building $${target} at "`/bin/date`" on "`/bin/hostname`" PID: $$$$" ; $(MAKE) $(TARGET) ) &>$(VPATH)/.RUNNING ; \
		if [ -r $(VPATH)/$${ff_stop} ] ; then \
			if [ -r $(VPATH)/.RUNNING ] ; then \
				/bin/mv $(VPATH)/.RUNNING $(VPATH)/block_$${ff_stop}.PASS ; \
				/bin/touch $(VPATH)/block_$${ff_stop} ; \
				/bin/touch $(VPATH)/block_$${ff_stop}.DONE ; \
			else \
				echo "# Something did not work properly" > $(VPATH)/block_$${ff_stop}.FAILED ; \
				/bin/touch $(VPATH)/block_$${ff_stop}.DONE ; \
				exit -1; \
			fi ; \
		else \
			if [ -r $(VPATH)/.RUNNING ] ; then \
				/bin/mv $(VPATH)/.RUNNING $(VPATH)/block_$${ff_stop}.FAILED ; \
			else \
				echo "# Something did not work properly" > $(VPATH)/block_$${ff_stop}.FAILED ; \
			fi ; \
			/bin/touch $(VPATH)/block_$${ff_stop}.DONE ; \
			exit -1 ; \
		fi ; \
	fi
