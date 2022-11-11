1.8V accumulation-mode MOS varactors
------------------------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`capbn_b`
-  Model Name: :model:`sky130_fd_pr__cap_var_lvt`, :model:`sky130_fd_pr__cap_var_hvt`
-  Model Type: subcircuit

Operating Voltages where SPICE models are valid

-  :math:`|V_0 – V_1| = 0` to 2.0V

Details
~~~~~~~

The following devices are available; they are subcircuits with the N-well to P-substrate diodes built into the model:

-  :model:`sky130_fd_pr__cap_var_lvt` - low VT PMOS device option
-  :model:`sky130_fd_pr__cap_var_hvt` - high VT PMOS device option

The varactors are used as tunable capacitors, major e-test parameters are listed below. Further details on the device models and their usage are in the SKY130 process Family Spice Models (002-21997), which can be obtained from SkyWater upon request.


.. include:: cap_var-table0.rst



There is no equivalent varactor for 5V operation. The NHV or PHV devices should be connected as capacitors for use at 5V.

The symbols for the varactors are shown below:

|symbol-cap_var-a| |symbol-cap_var-b|

The cross-section of the varactor is shown below:

|cross-section-cap_var|

.. |symbol-cap_var-a| image:: symbol-cap_var-a.svg
.. |symbol-cap_var-b| image:: symbol-cap_var-b.svg
.. |cross-section-cap_var| image:: cross-section-cap_var.svg

