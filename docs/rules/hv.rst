High Voltage Methodology
========================

High Voltage is defined as a voltage outside the range of GND to Vcc.  Any device that is subjected to a voltage outside the range of GND to Vcc is considered a high voltage device.  These devices are subjected to special design rules and biasing conditions.  The biasing conditions of these high voltage devices are detailed in the ETD.

Failure Mechanisms in High Voltage Devices
------------------------------------------

The TDR have a special rules section for the layout and DRC of the high voltage (hv) device.

These rules are framed so as to prevent the following failure mechanisms in circuits that use these devices:

Transistor Performance Degradation under HV Gate Stress (Section 2.2.2 of EDR)
  The maximum voltage across the gate oxide (gate to channel voltage) is restricted to:

   a. Any HV NMOS device: 7.3 V @ 25C.
   b. Any HV PMOS device: 8.1 V @ 25C.

  These voltages are not operating voltages, but points of failure.
  They should not be exceeded in any circuit at any time.

Junction Leakage/breakdown
  The maximum source/drain to substrate junction voltages are restricted to the following:

  a. Any HV NMOS device: 11.0 V @ 25C.
  b. Any HV PMOS device: 11.0 V @ 25C.

  These voltages are not operating voltages, but points of failure.
  They should not be exceeded in any circuit at any time.

Gated-Diode Leakage/Breakdown
  All high voltage devices use 110A gate oxide thickness just like low voltage (0 to Vcc) devices.

  The maximum gate-to-junction voltage differentials should be not exceed the voltage criteria set by conditions (1) and (2) above.

  In addition, hv p-channel devices are required to be laid out as ring devices (also called half-fieldless and fieldless devices), where the hv junction does not abut field oxide edge. These devices also get the extra junction grading implant into the ringed gate with the HVPDM mask.

Source to Drain Punch-through
  To prevent punch-through, the hv devices have expanded channel lengths:

  a. HV NMOS/PMOS device channel length = 0.500 um final.

Parasitic Isolation Field Leakage
  HV poly is prohibited from forming gates with adjacent hv diffusions, and from crossing well boundaries.

  Exceptions to this rule are made only in cases where the bulk of the isolation device formed is back-biased by at least 300 mV.

  The presence of the back bias cannot be checked by the CAD flow at this time. Exceptions pass clean through DRC with the presence of the “hv_bb” tag on the hv poly.

  The usage of the ``hv_bb`` tag is subject to approval by technology.

Sub-threshold EndCap Leakage
  The extension of poly forming a high voltage gate onto field to prevent subthreshold leakage due to line-end shortening of the poly/field oxide endcap.


High Voltage Implementation Methodology
---------------------------------------

Following are the features of the high voltage rules:


High Voltage Diffusion (hvSRCDRN)
  The source of high voltage is a diffusion(source/drain) tagged within the high voltage identification layer diff:hv.  The whole diffusion feature need to be completely enclosed by the diff:hv layer.

  The source/drains that are tagged with the diff:hv layer are called taggedhvSRCDRN within the CAD flow code. The propagation of the high voltage property within the tagged piece of diffusion stops at a gate, i.e.. if tagging is done on the drain side, the source does not become a high voltage feature.

  Beginning with taggedhvSRCDRN, high voltage propagates through standard interconnect to other SRCDRN or poly.  Any SRCDRN derives the high voltage property through electrically shorting to a taggedhvSRCDRN is called a derivedhvSRCDRN within the CAD flow.  Hence by definition, within the CAD flow,

	hvSRCDRN = OR(taggedhvSRCDRN derivedhvSRCDRN)

  ``Rule hv.X.1`` (high voltage source/drain regions must be tagged by diff:hv) will check the presence of the diff:hv tag and flag on all derivedhvSRCDRN. When the layout is finally clean of all hv.diff.1 errors, hvSRCDRN will consist of only taggedhvSRCDRN (all derivedhvSRCDRN will need to be tagged with diff:hv to remove errors). This is shown in Fig.1.

  ``Rule hv.diff.1`` (Minimum hv_source/drain spacing to diff for edges of hv_source/drain and diff not butting tap) prevents adjacent diffusions from punching through.  Note that this rule specifies the spacing of a hvSRCDRN to any diffusion – be it another hvSRCDRN or a normal diffusion.  This rule also applies to N+/P+ resistors that become hv by propagation.  This is shown schematically in Fig.2.

  ``Rule hv.diff.2`` (P-channel hv_source/drain must be enclosed by a ring_FET gate) is required to prevent excess field oxide/gate edge leakage in high voltage p-channel devices (Fig.3).  This ring_FET gate by definition is a hvring_FET (as it abuts hv diff).

High Voltage Poly (hvPoly)
  A high voltage poly feature (hvPoly) is defined as a poly feature which is electrically shorted to hvSRCDRN, or to another high voltage feature (like another hvPoly) through an interconnect.  The whole poly feature becomes high voltage feature.

  hvpoly propagates the high voltage property to other features which are electrically shorted (through licon1 & li1); but does not act as a source of high voltage.  This means that hvpoly does not make underlying diffusions or wells high voltage – it acts as a “conductor” and propagates the high voltage property to other electrically connected features.

  hvpoly cannot form parasitic field isolation devices, unless this device is back-biased.  Hence, the following rules are in place:

  ``hv.poly.1``
    Hv poly feature can be drawn over only one diff region and is not allowed to cross nwell boundary except as allowed in rule hv.X.3.  Please refer to Fig.4.

  ``hv.X.3``
    High voltage poly can be drawn over multiple diff regions that are ALL reverse-biased by at least 300 mV (existence of reverse-bias is not checked by the CAD flow).

    In this case, the high voltage poly can be tagged with the ``text:dg`` label with a value “hv_bb”.

    Exceptions to this use of the hv_bb label must be approved by technology.

    Under certain bias conditions, high voltage poly tagged with hv_bb can cross an nwell boundary.

    Use of the hv_bb label on high voltage poly crossing an nwell boundary must be approved by technology.

    This is shown in Fig.5.

    All high voltage poly tagged with hv_bb will not be checked to ``hv.poly.1``, ``hv.poly.2``, ``hv.poly.3`` and ``hv.poly.4``.

	* ``hv.poly.2``: Spacing of hv poly on field to unrelated diff (Fig.6).
	* ``hv.poly.3``: Spacing of hv poly on field to n-well (Fig.6).
	* ``hv.poly.4``: Enclosure of hv poly on field by n-well (Fig.6).

  Poly resistors can become high voltage features if the poly is electrically shorted to hvSRCDRN, or to another high voltage feature.  Nevertheless, these devices cannot act as sources of hv, and the hv propagation stops at the edge of this device.

High Voltage Poly Gate (hvFET_gate)
  A high voltage poly gate (``hvFET_gate``) is a gate (``PolyAndDiff``) abutting hvSRCDRN.  This is specified in rule ``hv.poly.8`` (Any poly gate abutting hv_source/drain becomes a high voltage poly gate).

  Note that this is the only definition of a hvFET_gate and the only way a gate can become a hvFET_gate.

  This is shown schematically in Fig.7.

  The high voltage property of the ``hvFET_gate`` is limited to the gate only – the whole poly feature does not become a hvPoly.

  The following rules are in place for hvFET_gates (please refer to Fig.12):

  * ``hv.diff.2``: P-channel hv_source/drains must be enclosed by a ring_FET gate.
    This is required to prevent excess field oxide/gate edge leakage in high voltage p-channel devices.
    A p-channel hvring_FET gate is shown schematically in Fig.8.

  * ``hv.poly.5``: Hv poly gate length (which is bigger than a normal gate length)

  * ``hv.poly.6``: Extension of poly forming an ``hvFET_gate`` beyond hv diffusion

  * ``hv.poly.7``: Minimum overlap of poly forming ``hvring_FET`` and diffusion

Stoppers to High Voltage Propagation
  The following act as stoppers for hv propagation (shown in Fig.10):

  * For a ``hv_source``/``drain`` tagged with ``diff:hv``, the high voltage property terminates at the intersection of this hv diff with a poly, i.e. at the gate edge.  This means that one side of the device can have a hv diff, while the other side of the gate can remain low voltage.

  * N+/P+ diffusion resistors are allowed per the Allowed Resistors table in the TDR.  These resistors do not originate high voltage.  They also do not propagate high voltage, although the device itself becomes a high voltage device.  The hv rule hv.diff.1 needs to be checked for these devices.

  * Diodes do not originate high voltage.  Nevertheless, they propagate high voltage and become high voltage devices when high voltage is propagated to them.  The hv rule hv.diff.1 needs to be checked for these devices.

  * A poly forming a poly resistor can become hvPoly by virtue of shorting to a hv_source/drain or shorting to another high voltage feature through an interconnect.  The high voltage propagation stops at a poly resistor, although the device itself becomes high voltage.  This device will be checked to the following hv rules: hv.poly.1, hv.poly.2, hv.poly.3, and hv.poly.4.  These rule checks can be exempted by the use of the "hv_bb" tag with the approval of technology.

  * The high voltage propagation also stops at a P-Well resistor.  The device becomes a hv device.  There are no specific rule checks for this hv device.

Summary of High Voltage Propagation
  The high voltage propagation methodology is summarized below in Table 1.

  A test case utilizing the outlined methodology is shown in Fig.12.


.. csv-table:: Table 1. Truth table for high voltage generation, propagation and retention.
   :file: hv/table-1.csv
   :header-rows: 1
   :stub-columns: 1

.. include:: hv/table-1-key.rst


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
