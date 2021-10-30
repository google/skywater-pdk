5.0V native NMOS FET
--------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_05v0_nvt`
-  Model Name: :model:`sky130_fd_pr__nfet_05v0_nvt`

Operating Voltages where SPICE models are valid for :model:`sky130_fd_pr__nfet_05v0_nvt`

-  :math:`V_{DS} = 0` to 5.5V
-  :math:`V_{GS} = 0` to 5.5V
-  :math:`V_{BS} = +0.3` to -5.5V

Details
~~~~~~~

The native device is constructed by blocking out all VT implants.

The model and EDR (e-test) parameters are compared below.

The 5V device has minimum gate length of 0.9 µm.


.. include:: ../nfet_03v3_nvt-and-nfet_05v0_nvt/nfet_03v3_nvt-and-nfet_05v0_nvt-table0.rst


The symbols for the :model:`sky130_fd_pr__nfet_05v0_nvt` devices are shown below.

|symbol-nfet_05v0_nvt|

The cross-section of the native devices is shown below.

.. note:: The only differences between the :model:`sky130_fd_pr__nfet_03v3_nvt` and :model:`sky130_fd_pr__nfet_05v0_nvt` devices are the minimum gate length and the VDS requirements.

|cross-section-nfet_05v0_nvt|

.. |symbol-nfet_05v0_nvt| image:: symbol-nfet_05v0_nvt.svg
.. |cross-section-nfet_05v0_nvt| image:: ../nfet_03v3_nvt-and-nfet_05v0_nvt/cross-section-nfet_03v3_nvt-and-nfet_05v0_nvt.svg

