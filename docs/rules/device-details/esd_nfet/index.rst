ESD NMOS FET
------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_01v8`
-  Model Name: :model:`sky130_fd_pr__esd_nfet_01v8`, :model:`sky130_fd_pr__esd_nfet_g5v0d10v5`, :model:`sky130_fd_pr__esd_nfet_g5v0d10v5_nvt`

Operating Voltages where SPICE models are valid

-  :math:`V_{DS} = 0` to 11.0V (:model:`sky130_fd_pr__nfet_g5v0d10v5*`), 0 to 1.95V (:model:`sky130_fd_pr__nfet_01v8*`)
-  :math:`V_{GS} = 0` to 5.0V (:model:`sky130_fd_pr__nfet_g5v0d10v5*`), 0 to 1.95V (:model:`sky130_fd_pr__nfet_01v8*`)
-  :math:`V_{BS} = 0` to -5.5V, (:model:`sky130_fd_pr__nfet_g5v0d10v5`), +0.3 to -5.5V (:model:`sky130_fd_pr__nfet_05v0_nvt`), 0 to -1.95V (:model:`sky130_fd_pr__nfet_01v8*`)

Details
~~~~~~~

The ESD FET’s differ from the regular NMOS devices in several aspects, most notably:

-  Increased isolation spacing from contacts to surrounding STI
-  Increased drain contact-to-gate spacing
-  Placement of n-well under the drain contacts

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: esd_nfet-table0.rst



The symbols of the :model:`sky130_fd_pr__esd_nfet_g5v0d10v5` and :model:`sky130_fd_pr__esd_nfet_g5v0d10v5_nvt` (ESD NMOS FET) are shown below:

|symbol-esd_nfet_g5v0d10v5| |symbol-esd_nfet_g5v0d10v5_nvt|

The cross-section of the ESD NMOS FET is shown below.

|cross-section-esd_nfet|

.. |symbol-esd_nfet_g5v0d10v5| image:: symbol-esd_nfet_g5v0d10v5.svg
.. |symbol-esd_nfet_g5v0d10v5_nvt| image:: symbol-esd_nfet_g5v0d10v5_nvt.svg
.. |cross-section-esd_nfet| image:: cross-section-esd_nfet.svg

