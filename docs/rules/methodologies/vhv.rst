Very High Voltage Methodology
=============================

Very High Voltage is defined as a voltage outside the range of GND to High Voltage (11V). Very high voltage is 16V (12V nominal) Vcc.

Any device that is subjected to a voltage outside the range of GND to 11V is considered a Very High Voltage (VHV) device.

These devices are subjected to special design rules and biasing conditions.


Failure Mechanisms in VHV Devices
---------------------------------

The TDR have a special rules section for the layout and DRC of the VHV device.

These rules are framed so as to prevent the following failure mechanisms in
circuits that use these devices:

Transistor Performance Degradation under VHV Gate Stress
  The maximum voltage across the gate oxide (gate to channel voltage) is restricted to:

  a. Any VHV NMOS device: 5.5V.
  b. Any VHV PMOS device: 5.5V.

Junction Leakage/breakdown
  The maximum source/drain to substrate junction voltages are restricted to the following:

  a. Any VHV NMOS device: 16.0V.
  b. Any VHV PMOS device: 16.0V.

Gated-Diode Leakage/Breakdown:
  All VHV devices use 110A gate oxide thickness just like standard 5.0V Vcc devices.

  The maximum gate-to-junction voltage differentials should not exceed the voltage criteria set by conditions (1) and (2) above.

  The VHV devices need to be designed with drain extentions (DE) fabricated by lightly doped Nwells and Pwellsrespectively. Under no circumstances the poly/extended drain overlap and field oxide length should be changed.

Source to Drain Punch-through
  To prevent punch-through, the VHV devices have expanded channel lengths:

  a. VHV NMOS device channel length = 1.055 um drawn.
  b. VHV PMOS device channel length = 1.050 um drawn.

Parasitic Isolation Field Leakage
  Poly from a drain extended device is prohibited from forming gates with adjacent hv diffusions.


Sub-threshold EndCap Leakage
  The extension of poly forming a high voltage gate onto field to prevent subthreshold leakage due to line-end shortening of the poly/field oxide endcap.

Reliability performance:
  In order to preserve the reliability performance of the VHV FETs the Field Oxide (STI) length may not be changed from the values below:

  a. VHV NMOS STI length = 1.585 um
  b. VHV PMOS STI length = 1.190 um

A poly gate may never be directly connected to a VHV diffusion region.

Poly connecting two VHV nodes over field must be routed through LI or metal.

VHV Implementation Methodology
------------------------------

Following are the features of the VHV rules:

* All features operating at 16V (max) voltages can be Very-High-Voltage (VHV)

* Drain or source of the drain-extended device can be tagged with vhvi:dg layer. Device with either drain or source (not both) tagged with vhvi:dg layer serves as propagation stopper

* The VHVSourceDrain can be connected to another VHVSourceDrain or an output pad. The VHVSourceDrain does not propagate the VHV through the device

* All source/drains/gate tagged with vhvi:dg propagate VHV through any interconnects.

* Diff inside areaid.ed on the same net as VHVSourceDrain should be tagged with vhvi:dg. They serve as propagation stopper.

* Deep N-well, N-well, P-well, Diff, or Poly cannot be used as routing layers.

.. csv-table:: Table 2 - Truth table for very high voltage generation, propagation and retention.
   :file: hv/table-2.csv
   :header-rows: 1

.. include:: hv/table-2-key.rst
