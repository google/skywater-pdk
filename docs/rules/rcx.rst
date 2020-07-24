Parasitic Layout Extraction
===========================

This table list layers and contacts included in SPICE models, and parasitic layers include in the AssuraLayout Extraction.

The modeled columns indicate sheets and contacts that are parasitic resistance/capacitance  included in the model extraction measurements.

The CAD columns indicate sheets and contacts that are parasitics included in the schematic/layout RCX from Assura.

.. csv-table:: Parasitic Extraction Table
   :file: rcx/rcx-all.csv
   :header-rows: 2


.. note:: The models includes M1/M2 capacitance. As a result of RCX extraction limitation M1/M2 routing over the varactor will have no capacitance extraction.

Routing and placement of devices over or under Precision resistors (xhrpoly_X_X) should be avoided.

The parasitic capacitance between 3-terminal MIMC and any routing/devices is not included in layout RCX, except M3 by 1 snap grid width.

No artificial fringing capacitance is extracted for MIMC M2/M3 due to CAD algorithm after CAPM sizing.

The parasitic capacitance between Precision resistors (xhrpoly_X_X) and any routing/devices is not included in layout RCX.

S8Q-5R is not supported for RF ESD diode RCX blocking.

The ``areaid:substratecut`` will be extracted as a 0.123 ohm two terms resistor.

Resistance Rules
----------------

.. todo:: This table should be rendered like the periphery rules.

.. csv-table:: Table of resistance rules
   :file: rcx/resistance.csv
   :header-rows: 2


Capacitance Rules
-----------------

.. todo:: This table should be rendered like the periphery rules.

.. csv-table:: Table of capacitance rules
   :file: rcx/capacitance.csv
   :header-rows: 2


Discrepencies
-------------

Non-precision poly resistors
  These resistors do not extract capacitance to substrate.

  This needs to be accounted for manually by using ICPS_0150_0210 (cap per perimeter), and ICPS_2000_4000 (cap per area).

Un-shielded VPP's
  Any routing above an un-shielded VPP will not be extracted.

  The impact of this on total capacitance and parasitic capacitance is already comprehended in the model corners, however, cross-talk is not modeled. Also, parasitic cap is routed to ground and this may not be ideal for the scenario.
  The parasitic cap can be estimated using RescapWeb.
