# sky130_cds
<pre>
James E. Stine, Jr. and Rachana Erra
james.stine@okstate.edu 
Oklahoma State University
School of Electrical and Computer Engineering
VLSI Computer Architecture Research Group
</pre>

Many thanks to Cadence Design Systems including David Junkin, Barry Nelson and Anton Kotz for all their amazing help and guidance.  

Repository for SKY130 Process Design Kit and Cadence Design System tools.

**Submodules**</br>

This repository contains the Oklahoma State University standard cells for Skywater Technology 130nm (SKY130).  They are integrated as submodules to get all of the standard-cells after cloning, type:

<pre>
git submodule update --init --recursive
</pre>

You can also get each submodule individually by typing:

<pre>
git submodule update --init sky130_osu_sc_t18
</pre>

If you wish to download them individually, you can do that at these links:
<pre>
https://foss-eda-tools.googlesource.com/skywater-pdk/libs/sky130_osu_sc_t18/+/refs/heads/main
https://foss-eda-tools.googlesource.com/skywater-pdk/libs/sky130_osu_sc_t15/+/refs/heads/main
https://foss-eda-tools.googlesource.com/skywater-pdk/libs/sky130_osu_sc_t12/+/refs/heads/main
</pre>

**Sample Designs:**<br/>

Right now there are two sample designs in the repository. One is a purely combinational design (mult.sv) and the other is a combination of combinational and sequential (mult_seq.sv). Right now, the mult_seq design is set up but can be easily modified and changed, if needed.

**Instructions to run synthesis and pnr:**

1. git clone git@github.com:stineje/sky130_cds.git

2. **Set up PDK:**<br/>
   a. cd sky130_cds<br/>
   b. git submodule update --init --recursive<br/>

3. **Run synthesis:**<br/>
   a.cd synth<br/>
   b.Add HDL to hdl subdirectory<br/>
   c.Edit genus script.tcl to load in correct SV files<br/> 
   d.Also modify genus_script.tcl to add the timing needed any loading or input/output delays. There are also options for loading that can be changed. Right now, a FF is assumed to be at the beginning and end of the timing to constrain the timing properly.Constraint settings are found within the constraints top.sdc file.<br/>
   e.make synth<br/> 
   f.All output is logged to synth.out that should be checked on completion. Reports are found within the reports directory and any mapped HDL is found in the top directory.<br/>

4. **Place-and-Route:**<br/>
   a. Edit setup.tcl and change the design, netlist, and sdc location. These can be found by searching for mult seq in a text editor. These items should match the files done through synthesis.<br/>
   b.innovus_config.tcl has plugins that allow commands to be run when needed. Right now, some plugins are enabled and some are not. This file would have be edited if one would want to do an additional command. These commands can be done before or after a step -- e.g.,pre init or post init.<br/>
   c.To start the process, a Makefile is used. Type the following in this order: init, place, cts, postcts hold, route, postroute, signoff. For example, you could type, make init to run through a design for the init phase. If one would want to just run through route, just type make route and the scripts should run through all the scripts until the end of route provided the other steps have not been initiated.This, of course, is provided there are no errors.<br/>
   d.Any commands run through the pnr are in the LOG subdirectory. There is one file that lists the commands (i.e., cmd) and the other that lists output from the command or the log files (i.e., .log). Reports are found in the RPT subdirectory.<br/>
   e.To pull up a placed-and-routed design from the route stage , start innovus and type: restoreDesign DBS/route.enc.dat/ mult_seq. It is important that the last argument be the top-level design indicated during the synthesis stage.<br/>

Notes:  There is more information in the PowerPoint slides found in the doc subdirectory.
 
 **Generating a qrcTechfile for PEX using Quantus:**<br/>
 
qrcTechfile is a technology file specific to a PDK that is generated from an ict file. An ict file contains information about conductors, dielectrics, diffusion, substrate, via and so forth. It is created using the specified syntax for each of the commands.<br/>
<PRE>techgen -si sky130.ict</PRE>

 
