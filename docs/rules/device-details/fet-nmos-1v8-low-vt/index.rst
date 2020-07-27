1.8V low-VT NMOS FET
--------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr_base__nfet`
-  Model Name: :model:`sky130_fd_pr_base__nlowvt`

Operating Voltages where SPICE models are valid

-  V\ :sub:`DS` = 0 to 1.95V
-  V\ :sub:`GS` = 0 to 1.95V
-  V\ :sub:`BS` = +0.3 to -1.95V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs.


.. include:: fet-nmos-1v8-low-vt-table0.rst



Inverter Gate Delays using :model:`sky130_fd_pr_base__nlowvt`/pshort device combinations:


.. include:: fet-nmos-1v8-low-vt-table1.rst



The symbol of the :model:`sky130_fd_pr_base__nlowvt` (1.8V low-VT NMOS FET) is shown below:

|symbol-1v8-low-vt-nmos-fet|

The cross-section of the low-VT NMOS FET is shown below. The cross-section is identical to the std NMOS FET except for the V\ :sub:`T` adjust implants (to achieve the lower V\ :sub:`T`)

|cross-section-1v8-low-vt-nmos-fet|

.. |symbol-1v8-low-vt-nmos-fet| image:: symbol-1v8-low-vt-nmos-fet.svg
.. |cross-section-1v8-low-vt-nmos-fet| image:: cross-section-1v8-low-vt-nmos-fet.svg

