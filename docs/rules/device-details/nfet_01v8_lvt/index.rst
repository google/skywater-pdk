1.8V low-VT NMOS FET
--------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_01v8`
-  Model Name: :model:`sky130_fd_pr__nfet_01v8_lvt`

Operating Voltages where SPICE models are valid

-  :math:`V_{DS} = 0` to 1.95V
-  :math:`V_{GS} = 0` to 1.95V
-  :math:`V_{BS} = +0.3` to -1.95V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs.


.. include:: nfet_01v8_lvt-table0.rst



Inverter Gate Delays using :model:`sky130_fd_pr__nfet_01v8_lvt`/:model:`sky130_fd_pr__pfet_01v8` device combinations:


.. include:: nfet_01v8_lvt-table1.rst



The symbol of the :model:`sky130_fd_pr__nfet_01v8_lvt` (1.8V low-VT NMOS FET) is shown below:

|symbol-nfet_01v8_lvt|

The cross-section of the low-VT NMOS FET is shown below. The cross-section is identical to the std NMOS FET except for the :math:`V_T` adjust implants (to achieve the lower :math:`V_T`)

|cross-section-nfet_01v8_lvt|

.. |symbol-nfet_01v8_lvt| image:: symbol-nfet_01v8_lvt.svg
.. |cross-section-nfet_01v8_lvt| image:: cross-section-nfet_01v8_lvt.svg

