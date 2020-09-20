Parasitic Layout Extraction
===========================

This table list layers and contacts included in SPICE models, and parasitic layers include in the AssuraLayout Extraction.

The modeled columns indicate sheets and contacts that are parasitic resistance/capacitance  included in the model extraction measurements.

The CAD columns indicate sheets and contacts that are parasitics included in the schematic/layout RCX from Assura.

.. csv-table:: Parasitic Extraction Table
   :file: rcx/rcx-all.tsv
   :header-rows: 2
   :stub-columns: 1
   :delim: U+0009


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
   :file: rcx/resistance-rules.csv
   :stub-columns: 1

Resistance Values
-----------------

This section includes tables of basic resistance values for SKY130.

Further data can be found in the `"SKY130 Stackup Capacitance Data" spreadsheet`_.

.. csv-table:: Table - Resistances
   :file: rcx/resistance-values.tsv
   :header-rows: 1
   :delim: U+0009


Capacitance Rules
-----------------

.. todo:: This table should be rendered like the periphery rules.

.. csv-table:: Table of capacitance rules
   :file: rcx/capacitance-rules.csv
   :stub-columns: 1


Capacitance Values
------------------

This section includes tables of basic capacitance values for SKY130.

Further data can be found in the `"SKY130 Stackup Capacitance Data" spreadsheet`_.

.. _"SKY130 Stackup Capacitance Data" spreadsheet: https://docs.google.com/spreadsheets/d/1N9To-xTiA7FLfQ1SNzWKe-wMckFEXVE9WPkPPjYkaxE/edit#gid=226894802

Basic Capacitance - Fringe Downward
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fringe capacitances are a constant value per unit length and are approximations. Determined by creating a layout with a 5um x 10um rectangle of each layer over or under a much larger rectangle of the other layer. The fringe capacitance computed from the total given minus the parallel plate capacitance.

"downward direction" means that the larger plate is below the 5um x 10um plate.

The layer in the first column is always the layer with the 5um x 10um plate.

.. csv-table:: Table - Capacitance - Fringe Downward
   :file: rcx/capacitance-fringe-downward.tsv
   :header-rows: 1
   :delim: U+0009


Basic Capacitance - Fringe Upward
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fringe capacitances are a constant value per unit length and are approximations. Determined by creating a layout with a 5um x 10um rectangle of each layer over or under a much larger rectangle of the other layer. The fringe capacitance computed from the total given minus the parallel plate capacitance.

"upward direction" means that the larger plate is above the 5um x 10um plate.

The layer in the first column is always the layer with the 5um x 10um plate.

.. csv-table:: Table - Capacitance - Fringe Upward
   :file: rcx/capacitance-fringe-upward.tsv
   :header-rows: 1
   :delim: U+0009


Basic Capacitance - Parallel
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. csv-table:: Table - Capacitance - Parallel
   :file: rcx/capacitance-parallel.tsv
   :header-rows: 1
   :delim: U+0009


Discrepencies
-------------

Non-precision poly resistors
  These resistors do not extract capacitance to substrate.

  This needs to be accounted for manually by using ICPS_0150_0210 (cap per perimeter), and ICPS_2000_4000 (cap per area).

Un-shielded VPP's
  Any routing above an un-shielded VPP will not be extracted.

  The impact of this on total capacitance and parasitic capacitance is already comprehended in the model corners, however, cross-talk is not modeled. Also, parasitic cap is routed to ground and this may not be ideal for the scenario.
  The parasitic cap can be estimated using RescapWeb.

