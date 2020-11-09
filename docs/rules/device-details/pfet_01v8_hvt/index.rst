1.8V high-VT PMOS FET
---------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__pfet_01v8`
-  Model Name: :model:`sky130_fd_pr__pfet_01v8_hvt`

Operating Voltages where SPICE models are valid

-  :math:`V_{DS} = 0` to -1.95V
-  :math:`V_{GS} = 0` to -1.95V
-  :math:`V_{BS} = -0.1` to +1.95V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: pfet_01v8_hvt-table0.rst



Inverter Gate Delays using sky130_fd_pr__nfet_01v8/:model:`sky130_fd_pr__pfet_01v8_hvt` device combinations:


.. include:: pfet_01v8_hvt-table1.rst



The symbol of the :model:`sky130_fd_pr__pfet_01v8_hvt` (1.8V high-VT PMOS FET) is shown below:

|symbol-pfet_01v8_hvt|

The cross-section of the high-VT PMOS FET is shown below. The cross-section is identical to the std PMOS FET except for the :math:`V_T` adjust implants (to achieve the higher :math:`V_T`)

|cross-section-pfet_01v8_hvt|

.. |symbol-pfet_01v8_hvt| image:: symbol-pfet_01v8_hvt.svg
.. |cross-section-pfet_01v8_hvt| image:: cross-section-pfet_01v8_hvt.svg

