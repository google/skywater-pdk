MiM capacitors
--------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__cap_mim_m3__base`, :cell:`sky130_fd_pr__cap_mim_m4__base`
-  Model Names: :model:`sky130_fd_pr__model__cap_mim`, :model:`sky130_fd_pr__cap_mim_m4`

Operating Voltages where SPICE models are valid

-  :math:`|V_{c0} – V_{c1}| = 0` to 5.0V

Details
~~~~~~~

The MiM capacitor is constructed using a thin dielectric over metal, followed by a thin conductor layer on top of the dielectric. There are two possible constructions:

-  CAPM over Metal-3
-  CAP2M over Metal-4

The constructions are identical, and the capacitors may be stacked to maximize total capacitance.

Electrical specs are listed below:


.. include:: cap_mim-table0.rst



The symbol for the MiM capacitor is shown below. Note that the cap model is a sub-circuit which accounts for the parasitic contact resistance and the parasitic capacitance from the bottom plate to substrate.

|symbol-cap_mim|

Cell name

M \* W \* L

Calc capacitance

The cross-section of the “stacked” MiM capacitor is shown below:

|cross-section-cap_mim|

.. |symbol-cap_mim| image:: symbol-cap_mim.svg
.. |cross-section-cap_mim| image:: cross-section-cap_mim.svg

