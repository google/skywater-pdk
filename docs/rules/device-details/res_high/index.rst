P+ poly precision resistors
---------------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`res_high_po_XpXX`, :cell:`sky130_fd_pr__res_high_po`
-  Model Type: subcircuit

Operating ranges where SPICE models are valid

-  :math:`|V_{r0} – V_{r1}| = 0` to 5.0V
-  Currents up to 500 µA/µm of width (preferred use ≤ 100 µA/µm)

Details
~~~~~~~

The resistors have 5 different fixed widths, plus a variable W/L option.

-  0.35 (0p35)
-  0.69 (0p69)
-  1.41 (1p41)
-  2.85 (2p83)
-  5.73 (5p73)

They are modeled as subcircuits, using a conventional resistor model combined with the capacitance under the resistor, as well as matching parameters and temperature coefficients. The fixed-width resistors may only be used in the above configurations. Each resistor end is contacted using a slot licon. Length is variable and measured between the front ends of the slot licons.

The fixed-width resistors are modeled using the equation

*\ :math:`R_0`\ * = head/tail resistance [Ω] (dominated by the slot licons)

*\ :math:`R_1`\ * = body resistance [Ω/µm] = :math:`R_{SH}`/W

A top-down schematic drawing of the precision resistor is shown below.

|res_high_po|

In addition to the :math:`R_0` and :math:`R_1` values, several fixed-value resistors are measured at e-test, as shown in the table below:


.. include:: res_high-table0.rst



More details on the use of the precision resistors, and their models, are in the document ***SKY130 process Family Device Models*** (002-21997), which can be obtained from SkyWater upon request.

The symbols for the 300 ohm/sq precision resistors are shown below:

|symbol-res_high_po_0p35| |symbol-res_high_po_0p69|

:model:`sky130_fd_pr__res_high_po_0p35` :model:`sky130_fd_pr__res_high_po_0p69`

|symbol-res_high_po_1p41| |symbol-res_high_po_2p85|

:model:`sky130_fd_pr__res_high_po_1p41` :model:`sky130_fd_pr__res_high_po_2p85`

|symbol-res_high_po_5p73|

:model:`sky130_fd_pr__res_high_po_5p73`

A generic version of the poly resistor is also available, which permits user inputs for W and L, and connections in series or parallel.

|symbol-res_high_po|

.. |res_high_po| image:: res_high_po.svg
.. |symbol-res_high_po_0p35| image:: symbol-res_high_po_0p35.svg
.. |symbol-res_high_po_0p69| image:: symbol-res_high_po_0p69.svg
.. |symbol-res_high_po_1p41| image:: symbol-res_high_po_1p41.svg
.. |symbol-res_high_po_2p85| image:: symbol-res_high_po_2p85.svg
.. |symbol-res_high_po_5p73| image:: symbol-res_high_po_5p73.svg
.. |symbol-res_high_po| image:: symbol-res_high_po.svg

