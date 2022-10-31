Device Details
==============

1.8V NMOS FET
-------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_01v8`
-  Model Name: :model:`sky130_fd_pr__nfet_01v8`

Operating Voltages where SPICE models are valid

-  :math:`V_{DS} = 0` to 1.95V
-  :math:`V_{GS} = 0` to 1.95V
-  :math:`V_{BS} = +0.3` to -1.95V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs.


.. include:: device-details/nfet_01v8/nfet_01v8-table0.rst



The symbol of the :model:`sky130_fd_pr__nfet_01v8` (1.8V NMOS FET) is shown below:

|symbol-nfet_01v8|

The cross-section of the NMOS FET is shown below:

|cross-section-nfet_01v8|

The device shows the p-well inside of a deep n-well, but it can be made either with or without the DNW under the p-well

.. |symbol-nfet_01v8| image:: device-details/nfet_01v8/symbol-nfet_01v8.svg
.. |cross-section-nfet_01v8| image:: device-details/nfet_01v8/cross-section-nfet_01v8.svg


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


.. include:: device-details/nfet_01v8_lvt/nfet_01v8_lvt-table0.rst



Inverter Gate Delays using :model:`sky130_fd_pr__nfet_01v8_lvt`/:model:`sky130_fd_pr__pfet_01v8` device combinations:


.. include:: device-details/nfet_01v8_lvt/nfet_01v8_lvt-table1.rst



The symbol of the :model:`sky130_fd_pr__nfet_01v8_lvt` (1.8V low-VT NMOS FET) is shown below:

|symbol-nfet_01v8_lvt|

The cross-section of the low-VT NMOS FET is shown below. The cross-section is identical to the std NMOS FET except for the :math:`V_T` adjust implants (to achieve the lower :math:`V_T`)

|cross-section-nfet_01v8_lvt|

.. |symbol-nfet_01v8_lvt| image:: device-details/nfet_01v8_lvt/symbol-nfet_01v8_lvt.svg
.. |cross-section-nfet_01v8_lvt| image:: device-details/nfet_01v8_lvt/cross-section-nfet_01v8_lvt.svg


1.8V PMOS FET
-------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__pfet_01v8`
-  Model Name: :model:`sky130_fd_pr__pfet_01v8`

Operating Voltages where SPICE models are valid

-  :math:`V_{DS} = 0` to -1.95V
-  :math:`V_{GS} = 0` to -1.95V
-  :math:`V_{BS} = -0.1` to +1.95V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs.


.. include:: device-details/pfet_01v8/pfet_01v8-table0.rst



Inverter Gate Delays using sky130_fd_pr__nfet_01v8/:model:`sky130_fd_pr__pfet_01v8` device combinations:


.. include:: device-details/pfet_01v8/pfet_01v8-table1.rst



The symbol of the :model:`sky130_fd_pr__pfet_01v8` (1.8V PMOS FET) is shown below:

|symbol-pfet_01v8|

The cross-section of the PMOS FET is shown below:

|cross-section-pfet_01v8|

.. |symbol-pfet_01v8| image:: device-details/pfet_01v8/symbol-pfet_01v8.svg
.. |cross-section-pfet_01v8| image:: device-details/pfet_01v8/cross-section-pfet_01v8.svg


1.8V low-VT PMOS FET
--------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__pfet_01v8`
-  Model Name: :model:`sky130_fd_pr__pfet_01v8_lvt`

Operating Voltages where SPICE models are valid

-  :math:`V_{DS} = 0` to -1.95V
-  :math:`V_{GS} = 0` to -1.95V
-  :math:`V_{BS} = -0.1` to +1.95V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/pfet_01v8_lvt/pfet_01v8_lvt-table0.rst



Inverter Gate Delays using sky130_fd_pr__nfet_01v8_lvt/:model:`sky130_fd_pr__pfet_01v8_lvt` device combinations:


.. include:: device-details/pfet_01v8_lvt/pfet_01v8_lvt-table1.rst



The symbol of the :model:`sky130_fd_pr__pfet_01v8_lvt` (1.8V low-VT PMOS FET) is shown below:

|symbol-pfet_01v8_lvt|

The cross-section of the low-VT PMOS FET is shown below. The cross-section is identical to the std PMOS FET except for the :math:`V_T` adjust implants (to achieve the lower :math:`V_T`)

|cross-section-pfet_01v8_lvt|

.. |symbol-pfet_01v8_lvt| image:: device-details/pfet_01v8_lvt/symbol-pfet_01v8_lvt.svg
.. |cross-section-pfet_01v8_lvt| image:: device-details/pfet_01v8_lvt/cross-section-pfet_01v8_lvt.svg


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


.. include:: device-details/pfet_01v8_hvt/pfet_01v8_hvt-table0.rst



Inverter Gate Delays using sky130_fd_pr__nfet_01v8/:model:`sky130_fd_pr__pfet_01v8_hvt` device combinations:


.. include:: device-details/pfet_01v8_hvt/pfet_01v8_hvt-table1.rst



The symbol of the :model:`sky130_fd_pr__pfet_01v8_hvt` (1.8V high-VT PMOS FET) is shown below:

|symbol-pfet_01v8_hvt|

The cross-section of the high-VT PMOS FET is shown below. The cross-section is identical to the std PMOS FET except for the :math:`V_T` adjust implants (to achieve the higher :math:`V_T`)

|cross-section-pfet_01v8_hvt|

.. |symbol-pfet_01v8_hvt| image:: device-details/pfet_01v8_hvt/symbol-pfet_01v8_hvt.svg
.. |cross-section-pfet_01v8_hvt| image:: device-details/pfet_01v8_hvt/cross-section-pfet_01v8_hvt.svg


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


.. include:: device-details/cap_var/cap_var-table0.rst



There is no equivalent varactor for 5V operation. The NHV or PHV devices should be connected as capacitors for use at 5V.

The symbols for the varactors are shown below:

|symbol-cap_var-a| |symbol-cap_var-b|

The cross-section of the varactor is shown below:

|cross-section-cap_var|

.. |symbol-cap_var-a| image:: device-details/cap_var/symbol-cap_var-a.svg
.. |symbol-cap_var-b| image:: device-details/cap_var/symbol-cap_var-b.svg
.. |cross-section-cap_var| image:: device-details/cap_var/cross-section-cap_var.svg


3.0V native NMOS FET
--------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_01v8`
-  Model Name: :model:`sky130_fd_pr__nfet_03v3_nvt`

Operating Voltages where SPICE models are valid for :model:`sky130_fd_pr__nfet_03v3_nvt`

-  :math:`V_{DS} = 0` to 3.3V
-  :math:`V_{GS} = 0` to 3.3V
-  :math:`V_{BS} = 0` to -3.3V

Details
~~~~~~~

The native device is constructed by blocking out all VT implants.

The model and EDR (e-test) parameters are compared below. Note that the minimum gate length for 3V operation is 0.5 µm.


.. include:: device-details/nfet_03v3_nvt/../nfet_03v3_nvt-and-nfet_05v0_nvt/nfet_03v3_nvt-and-nfet_05v0_nvt-table0.rst



The symbols for the :model:`sky130_fd_pr__nfet_03v3_nvt` devices are shown below.

|symbol-nfet_0v3v3_nvt|

The cross-section of the native devices is shown below.


|cross-section-nfet_03v3_nvt|

.. |symbol-nfet_0v3v3_nvt| image:: device-details/nfet_03v3_nvt/symbol-nfet_03v3_nvt.svg
.. |cross-section-nfet_03v3_nvt| image:: device-details/nfet_03v3_nvt/../nfet_03v3_nvt-and-nfet_05v0_nvt/cross-section-nfet_03v3_nvt-and-nfet_05v0_nvt.svg

.. note:: The only differences between the :model:`sky130_fd_pr__nfet_03v3_nvt` and :model:`sky130_fd_pr__nfet_05v0_nvt` devices are the minimum gate length and the VDS requirements.

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


.. include:: device-details/nfet_05v0_nvt/../nfet_03v3_nvt-and-nfet_05v0_nvt/nfet_03v3_nvt-and-nfet_05v0_nvt-table0.rst


The symbols for the :model:`sky130_fd_pr__nfet_05v0_nvt` devices are shown below.

|symbol-nfet_05v0_nvt|

The cross-section of the native devices is shown below.

.. note:: The only differences between the :model:`sky130_fd_pr__nfet_03v3_nvt` and :model:`sky130_fd_pr__nfet_05v0_nvt` devices are the minimum gate length and the VDS requirements.

|cross-section-nfet_05v0_nvt|

.. |symbol-nfet_05v0_nvt| image:: device-details/nfet_05v0_nvt/symbol-nfet_05v0_nvt.svg
.. |cross-section-nfet_05v0_nvt| image:: device-details/nfet_05v0_nvt/../nfet_03v3_nvt-and-nfet_05v0_nvt/cross-section-nfet_03v3_nvt-and-nfet_05v0_nvt.svg


5.0V/10.5V NMOS FET
-------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_01v8`
-  Model Name: :model:`sky130_fd_pr__nfet_g5v0d10v5`

Operating Voltages where SPICE models are valid

-  :math:`V_{DS} = 0` to 11.0V
-  :math:`V_{GS} = 0` to 5.5V
-  :math:`V_{BS} = 0` to -5.5V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/nfet_g5v0d10v5/nfet_g5v0d10v5-table0.rst



The symbols of the :model:`sky130_fd_pr__nfet_g5v0d10v5` (5.0/10.5 V NMOS FET) is shown below:

|symbol-nfet_g5v0d10v5|

The cross-section of the 5.0/10.5 V NMOS FET is shown below.

|cross-section-nfet_g5v0d10v5|

.. |symbol-nfet_g5v0d10v5| image:: device-details/nfet_g5v0d10v5/symbol-nfet_g5v0d10v5.svg
.. |cross-section-nfet_g5v0d10v5| image:: device-details/nfet_g5v0d10v5/cross-section-nfet_g5v0d10v5.svg


5.0V/10.5V PMOS FET
-------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__pfet_01v8`
-  Model Name: :model:`sky130_fd_pr__pfet_g5v0d10v5`, :model:`sky130_fd_pr__esd_pfet_g5v0d10v5`

Operating Voltages where SPICE models are valid

-  :math:`V_{DS} = 0` to -11.0V
-  :math:`V_{GS} = 0` to -5.5V
-  :math:`V_{BS} = 0` to +5.5V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/pfet_g5v0d10v5/pfet_g5v0d10v5-table0.rst



Inverter gate delays are shown below:


.. include:: device-details/pfet_g5v0d10v5/pfet_g5v0d10v5-table1.rst



The symbols of the :model:`sky130_fd_pr__pfet_g5v0d10v5` and :model:`sky130_fd_pr__esd_pfet_g5v0d10v5` (5.0V/10.5V PMOS FET) are shown below:

|symbol-pfet_g5v0d10v5| |symbol-esd_pfet_g5v0d10v5|

The cross-section of the 5.0V PMOS FET is shown below.

|cross-section-pfet_g5v0d10v5|

.. |symbol-pfet_g5v0d10v5| image:: device-details/pfet_g5v0d10v5/symbol-pfet_g5v0d10v5.svg
.. |symbol-esd_pfet_g5v0d10v5| image:: device-details/pfet_g5v0d10v5/symbol-esd_pfet_g5v0d10v5.svg
.. |cross-section-pfet_g5v0d10v5| image:: device-details/pfet_g5v0d10v5/cross-section-pfet_g5v0d10v5.svg


10V/16V PMOS FET
----------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__pfet_extenddrain`
-  Model Name: :model:`sky130_fd_pr__pfet_g5v0d16v0`

Operating Voltages where SPICE models are valid, subject to SOA limitations:

-  :math:`V_{DS} = 0` to -16V (\ :math:`V_{GS} = 0`\ )
-  :math:`V_{DS} = 0` to -10V (\ :math:`V_{GS} < 0`\ )
-  :math:`V_{GS} = 0` to -5.5V
-  :math:`V_{BS} = 0` to +2.0V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/pfet_g5v0d16v0/pfet_g5v0d16v0-table0.rst



The symbol of the :model:`sky130_fd_pr__pfet_g5v0d16v0` (10V/16V PMOS FET) is shown below:

|symbol-pfet_g5v0d16v0|

The cross-section of the 10V/16V PMOS FET is shown below.

|cross-section-pfet_g5v0d16v0|

.. |symbol-pfet_g5v0d16v0| image:: device-details/pfet_g5v0d16v0/symbol-pfet_g5v0d16v0.svg
.. |cross-section-pfet_g5v0d16v0| image:: device-details/pfet_g5v0d16v0/cross-section-pfet_g5v0d16v0.svg


11V/16V NMOS FET
----------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_extenddrain`
-  Model Name: :model:`sky130_fd_pr__nfet_g5v0d16v0`

Operating Voltages where SPICE models are valid, subject to SOA limitations:

-  :math:`V_{DS} = 0` to +16V (\ :math:`V_{GS} = 0`\ )
-  :math:`V_{DS} = 0` to +11V (\ :math:`V_{GS} > 0`\ )
-  :math:`V_{GS} = 0` to 5.5V
-  :math:`V_{BS} = 0` to -2.0V

Details
~~~~~~~

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/nfet_g11v0d16v0/nfet_g11v0d16v0-table0.rst



The symbol of the :model:`sky130_fd_pr__nfet_g5v0d16v0` (11V/16V NMOS FET) is shown below:

|symbol-nfet_g11v0d16v0|

The cross-section of the 11V/16VV NMOS FET is shown below.

|cross-section-nfet_g11v0d16v0|

.. |symbol-nfet_g11v0d16v0| image:: device-details/nfet_g11v0d16v0/symbol-nfet_g11v0d16v0.svg
.. |cross-section-nfet_g11v0d16v0| image:: device-details/nfet_g11v0d16v0/cross-section-nfet_g11v0d16v0.svg


20V NMOS FET
------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_extenddrain`
-  Model Name: :model:`sky130_fd_pr__nfet_20v0`

Operating Voltages where SPICE models are valid, subject to SOA limitations:

-  :math:`V_{DS} = 0` to +22V
-  :math:`V_{GS} = 0` to 5.5V
-  :math:`V_{BS} = 0` to -2.0V

Details
~~~~~~~

The 20V NMOS FET has similar construction to the 11V/16V NMOS FET, with several differences:

-  Longer drift region
-  Longer poly gate
-  Larger W/L
-  Devices placed in pairs (drain in center, sources on outside)

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/nfet_20v0/nfet_20v0-table0.rst



The symbol of the :model:`sky130_fd_pr__nfet_20v0` (20V NMOS FET) is shown below.

|symbol-nfet_20v0|

The cross-section of the 20V NMOS FET is shown below.

|cross-section-nfet_20v0|

.. |symbol-nfet_20v0| image:: device-details/nfet_20v0/symbol-nfet_20v0.svg
.. |cross-section-nfet_20v0| image:: device-details/nfet_20v0/cross-section-nfet_20v0.svg


20V native NMOS FET
-------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_extenddrain`
-  Model Name: :model:`sky130_fd_pr__nfet_20v0_nvt`

Operating Voltages where SPICE models are valid, subject to SOA limitations:

-  :math:`V_{DS} = 0` to +22V
-  :math:`V_{GS} = 0` to 5.5V
-  :math:`V_{BS} = 0` to -2.0V

Details
~~~~~~~

The 20V native NMOS FET is similar to the 20V isolated NMOS FET, but has all Vt implants blocked to achieve a very low VT.

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/nfet_20v0_nvt/nfet_20v0_nvt-table0.rst



The symbol of the :model:`sky130_fd_pr__nfet_20v0_nvt` (20V native NMOS FET) shown below.

|symbol-nfet_20v0_nvt|

The cross-section of the 20V native NMOS FET is shown below.

|cross-section-nfet_20v0_nvt|

.. |symbol-nfet_20v0_nvt| image:: device-details/nfet_20v0_nvt/symbol-nfet_20v0_nvt.svg
.. |cross-section-nfet_20v0_nvt| image:: device-details/nfet_20v0_nvt/cross-section-nfet_20v0_nvt.svg


20V zero-VT NMOS FET
--------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_extenddrain`
-  Model Name: :model:`sky130_fd_pr__nfet_20v0_zvt`

Operating Voltages where SPICE models are valid, subject to SOA limitations:

-  :math:`V_{DS} = 0` to +22V
-  :math:`V_{GS} = 0` to 5.5V
-  :math:`V_{BS} = 0` to -2.0V

Details
~~~~~~~

The 20V NMOS zero-VT FET has p-well and all Vt implants blocked to achieve a zero VT.

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/nfet_20v0_zvt/nfet_20v0_zvt-table0.rst



The symbol of the :model:`sky130_fd_pr__nfet_20v0_zvt` (20V NMOS zero-VT FET) is still under development.

The cross-section of the 20V NMOS zero-VT FET is shown below.

|cross-section-nfet_20v0_zvt|

.. |cross-section-nfet_20v0_zvt| image:: device-details/nfet_20v0_zvt/cross-section-nfet_20v0_zvt.svg


20V isolated NMOS FET
---------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_extenddrain`
-  Model Name: :model:`sky130_fd_pr__nfet_20v0_iso`

Operating Voltages where SPICE models are valid, subject to SOA limitations:

-  :math:`V_{DS} = 0` to +22V
-  :math:`V_{GS} = 0` to 5.5V
-  :math:`V_{BS} = 0` to -2.0V

Details
~~~~~~~

The 20V isolated NMOS FET has the same construction as the 20V NMOS FET, but is built over a Deep N-well. This permits the p-well to be isolated from the substrate and permit “high-side” usage (where the PW body is held above ground).

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/nfet_20v0_iso/nfet_20v0_iso-table0.rst



The symbol of the :model:`sky130_fd_pr__nfet_20v0_iso` (20V isolated NMOS FET) is shown below.

|symbol-nfet_20v0_iso|

The cross-section of the 20V isolated NMOS FET is shown below.

|cross-section-nfet_20v0_iso|

.. |symbol-nfet_20v0_iso| image:: device-details/nfet_20v0_iso/symbol-nfet_20v0_iso.svg
.. |cross-section-nfet_20v0_iso| image:: device-details/nfet_20v0_iso/cross-section-nfet_20v0_iso.svg


20V PMOS FET
------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__pfet_extenddrain`
-  Model Name: :model:`sky130_fd_pr__pfet_20v0`

Operating Voltages where SPICE models are valid, subject to SOA limitations:

-  :math:`V_{DS} = 0` to -22V
-  :math:`V_{GS} = 0` to -5.5V
-  :math:`V_{BS} = 0` to +2.0V

Details
~~~~~~~

The 20V NMOS FET has similar construction to the 11V/16V NMOS FET, with several differences:

-  Longer drift region
-  Longer poly gate
-  Larger W/L
-  Devices placed in pairs (drain in middle, sources on outside)

Major model output parameters are shown below and compared against the EDR (e-test) specs


.. include:: device-details/pfet_20v0/pfet_20v0-table0.rst



The symbol of the :model:`sky130_fd_pr__pfet_20v0` (20V PMOS FET) is shown below.

|symbol-pfet_20v0|

The cross-section of the 20V PMOS FET is shown below.

|cross-section-pfet_20v0|

.. |symbol-pfet_20v0| image:: device-details/pfet_20v0/symbol-pfet_20v0.svg
.. |cross-section-pfet_20v0| image:: device-details/pfet_20v0/cross-section-pfet_20v0.svg


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


.. include:: device-details/esd_nfet/esd_nfet-table0.rst



The symbols of the :model:`sky130_fd_pr__esd_nfet_g5v0d10v5` and :model:`sky130_fd_pr__esd_nfet_g5v0d10v5_nvt` (ESD NMOS FET) are shown below:

|symbol-esd_nfet_g5v0d10v5| |symbol-esd_nfet_g5v0d10v5_nvt|

The cross-section of the ESD NMOS FET is shown below.

|cross-section-esd_nfet|

.. |symbol-esd_nfet_g5v0d10v5| image:: device-details/esd_nfet/symbol-esd_nfet_g5v0d10v5.svg
.. |symbol-esd_nfet_g5v0d10v5_nvt| image:: device-details/esd_nfet/symbol-esd_nfet_g5v0d10v5_nvt.svg
.. |cross-section-esd_nfet| image:: device-details/esd_nfet/cross-section-esd_nfet.svg


Diodes
------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`diode`
-  Model Names: :model:`sky130_fd_pr__diode_pw2nd_05v5`, :model:`sky130_fd_pr__diode_pw2nd_11v0`, :model:`sky130_fd_pr__diode_pw2nd_05v5_nvt`, :model:`sky130_fd_pr__diode_pw2nd_05v5_lvt`, :model:`sky130_fd_pr__diode_pd2nw_05v5`, :model:`sky130_fd_pr__diode_pd2nw_11v0`, :model:`sky130_fd_pr__diode_pd2nw_05v5_hvt`, :model:`sky130_fd_pr__diode_pd2nw_05v5_lvt`, :model:`sky130_fd_pr__model__parasitic__rf_diode_ps2nw`, :model:`sky130_fd_pr__model__parasitic__rf_diode_pw2dn`, :model:`sky130_fd_pr__model__parasitic__diode_pw2dn`, :model:`sky130_fd_pr__model__parasitic__diode_ps2dn`, :model:`dnwdiode_psub_victim`, :model:`dnwdiode_psub_aggressor`, :model:`sky130_fd_pr__model__parasitic__diode_ps2nw`, :model:`nwdiode_victim`, :model:`nwdiode_aggressor`, :model:`xesd_ndiode_h_X`, :model:`xesd_ndiode_h_dnwl_X`, :model:`xesd_pdiode_h_X (X = 100 or 200 or 300)`
-  Cell Name: :cell:`lvsdiode`
-  Model Names: :model:`sky130_fd_pr__diode_pw2nd_05v5`, :model:`sky130_fd_pr__diode_pw2nd_11v0`, :model:`sky130_fd_pr__diode_pd2nw_05v5`, :model:`sky130_fd_pr__diode_pd2nw_11v0`, :model:`sky130_fd_pr__model__parasitic__diode_ps2dn`, :model:`dnwdiode_psub_victim`, :model:`dnwdiode_psub_aggressor`, :model:`nwdiode_victim`, :model:`nwdiode_aggressor`, :model:`xesd_ndiode_h_X`, :model:`xesd_ndiode_h_dnwl_X`, :model:`xesd_pdiode_h_X (X = 100 or 200 or 300)`

Operating regime where SPICE models are valid

-  :math:`|V_{d0} – V_{d1}| = 0` to 5.0V

Details
~~~~~~~


.. include:: device-details/diodes/diodes-table0.rst



Symbols for the diodes are shown below

|symbol-diode-01|
|symbol-diode-02|
|symbol-diode-03|
|symbol-diode-04|
|symbol-diode-05|
|symbol-diode-06|
|symbol-diode-07|
|symbol-diode-08|
|symbol-diode-09|
|symbol-diode-10|
|symbol-diode-11|
|symbol-diode-12|
|symbol-diode-13|
|symbol-diode-14|
|symbol-diode-15|
|symbol-diode-16|
|symbol-diode-17|

.. |symbol-diode-01| image:: device-details/diodes/symbol-diode-01.svg
.. |symbol-diode-02| image:: device-details/diodes/symbol-diode-02.svg
.. |symbol-diode-03| image:: device-details/diodes/symbol-diode-03.svg
.. |symbol-diode-04| image:: device-details/diodes/symbol-diode-04.svg
.. |symbol-diode-05| image:: device-details/diodes/symbol-diode-05.svg
.. |symbol-diode-06| image:: device-details/diodes/symbol-diode-06.svg
.. |symbol-diode-07| image:: device-details/diodes/symbol-diode-07.svg
.. |symbol-diode-08| image:: device-details/diodes/symbol-diode-08.svg
.. |symbol-diode-09| image:: device-details/diodes/symbol-diode-09.svg
.. |symbol-diode-10| image:: device-details/diodes/symbol-diode-10.svg
.. |symbol-diode-11| image:: device-details/diodes/symbol-diode-11.svg
.. |symbol-diode-12| image:: device-details/diodes/symbol-diode-12.svg
.. |symbol-diode-13| image:: device-details/diodes/symbol-diode-13.svg
.. |symbol-diode-14| image:: device-details/diodes/symbol-diode-14.svg
.. |symbol-diode-15| image:: device-details/diodes/symbol-diode-15.svg
.. |symbol-diode-16| image:: device-details/diodes/symbol-diode-16.svg
.. |symbol-diode-17| image:: device-details/diodes/symbol-diode-17.svg


Bipolar NPN transistor
----------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__npn_05v5`
-  Model Names: :model:`sky130_fd_pr__npn_05v5`, :model:`sky130_fd_pr__npn_11v0`

Operating regime where SPICE models are valid

-  :math:`|V_{CE}| = 0` to 5.0V
-  :math:`|V_{BE}| = 0` to 5.0V
-  :math:`I_{CE} = 0.01` to 10 µA/µm\ :sup:`2`

Details
~~~~~~~

The SKY130 process offers “free” NPN devices. The NPN uses the deep n-well as the collector. The device is not optimized, and must be used in the forward-active mode. The following sizes of NPN’s are available:

-  ungated device with emitter 1.0 x 1.0
-  ungated device with emitter 1.0 x 2.0
-  poly-gated version with octagonal emitter of A = 1.97 µm\ :sup:`2`

The :model:`sky130_fd_pr__npn_11v0` device has a poly gate placed between the emitter and base diffusions, to prevent carrier recombination at the STI edge and increase β. The poly gate is connected to the emitter terminal.

Using this device must be done in conjunction with the correct guard rings, to avoid potential latchup issues with nearby circuitry. Reverse-active mode operation of the BJT’s are neither modeled nor permitted. E-test specs for the NPN devices are shown in the table below:


.. include:: device-details/npn_05v0/npn_05v0-table0.rst



Symbols for the :model:`sky130_fd_pr__npn_05v5` are shown below

|symbol-npn_05v0-1| |symbol-npn_05v0-2| |symbol-npn_05v0-3|

The cross-section of the :model:`sky130_fd_pr__npn_05v5` is shown below.

|cross-section-npn_05v0|

The cross-section of the :model:`sky130_fd_pr__npn_11v0` is shown below. The poly gate is tied to the emitter to prevent the parasitic MOSFET from turning on.

|cross-section-npn_11v0|

.. |symbol-npn_05v0-1| image:: device-details/npn_05v0/symbol-npn_05v0-1.svg
.. |symbol-npn_05v0-2| image:: device-details/npn_05v0/symbol-npn_05v0-2.svg
.. |symbol-npn_05v0-3| image:: device-details/npn_05v0/symbol-npn_05v0-3.svg
.. |cross-section-npn_05v0| image:: device-details/npn_05v0/cross-section-npn_05v0.svg
.. |cross-section-npn_11v0| image:: device-details/npn_05v0/cross-section-npn_11v0.svg


Bipolar PNP transistor
----------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__pnp_05v5`
-  Model Names: :model:`sky130_fd_pr__pnp_05v5`, :model:`sky130_fd_pr__pnp_05v5`

Operating regime where SPICE models are valid

-  :math:`|V_{CE}| = 0` to 5.0V
-  :math:`|V_{BE}| = 0` to 5.0V
-  :math:`I_{CE} = 0.01` to 10 µA/µm\ :sup:`2`

Details
~~~~~~~

The SKY130 process offer a “free” PNP device, which utilizes the substrate as the collector. This device is not independently optimized, and can be used in forward-active mode. The following sizes of PNP are available:

-  ungated device with emitter 0.68 x 0.68 (A=0.4624 µm\ :sup:`2`)
-  ungated device with emitter 3.4 x 3.4 (A=11.56 µm\ :sup:`2`)

Using this device must be done in conjunction with the correct guard rings, to avoid potential latchup issues with nearby circuitry. Reverse-active mode operation of the BJT’s are neither modeled nor permitted.

E-test specs for these devices are shown in the table below:


.. include:: device-details/pnp_05v0/pnp_05v0-table0.rst



Symbols for the :model:`sky130_fd_pr__pnp_05v5` is shown below

|symbol-pnp_05v0-a| |symbol-pnp_05v0-b|

The cross-section of the :model:`sky130_fd_pr__pnp_05v5` is shown below.

No deep n-well exists in this device; the collector is the substrate.

|cross-section-pnp_05v0|

.. |symbol-pnp_05v0-a| image:: device-details/pnp_05v0/symbol-pnp_05v0-a.svg
.. |symbol-pnp_05v0-b| image:: device-details/pnp_05v0/symbol-pnp_05v0-b.svg
.. |cross-section-pnp_05v0| image:: device-details/pnp_05v0/cross-section-pnp_05v0.svg


SRAM cells
----------

The SKY130 process currently supports only single-port SRAM’s, which are contained in hard-IP libraries. These cells are constructed with smaller design rules (Table 9), along with OPC (optical proximity correction) techniques, to achieve small memory cells. Use of the memory cells or their devices outside the specific IP is prohibited. The schematic for the SRAM is shown below in Figure 10. This cell is available in the S8 IP offerings and is monitored at e-test through the use of “pinned out” devices within the specific arrays.

|figure-10-schematics-of-the-single-port-sram|

**Figure 10. Schematics of the Single Port SRAM.**

A Dual-Port SRAM is currently being designed using a similar approach. Compilers for the SP and DP SRAM’s will be available end-2019.

Operating Voltages where SPICE models are valid

-  :math:`V_{DS} = 0` to 1.8V
-  :math:`V_{GS} = 0` to 1.8V
-  :math:`V_{BS} = 0` to -1.8V

Details
~~~~~~~

N-pass FET (SRAM)
^^^^^^^^^^^^^^^^^

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_01v8`
-  Model Name (SRAM): :model:`sky130_fd_pr__special_nfet_pass`


.. include:: device-details/special_sram/special_sram-table0.rst



N-latch FET (SRAM)
^^^^^^^^^^^^^^^^^^

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__nfet_01v8`
-  Model Name (SRAM): :model:`sky130_fd_pr__special_nfet_latch`


.. include:: device-details/special_sram/special_sram-table1.rst



P-latch FET (SRAM)
^^^^^^^^^^^^^^^^^^

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__pfet_01v8`
-  Model Name (SRAM): :model:`sky130_fd_pr__special_pfet_pass`


.. include:: device-details/special_sram/special_sram-table2.rst



.. |figure-10-schematics-of-the-single-port-sram| image:: device-details/special_sram/figure-10-schematics-of-the-single-port-sram.svg


SONOS cells
-----------

The SKY130 process currently supports two SONOS flash memory cells:

-  The original cell is supported in the S8PFHD, S8PHRC and S8PFN-20 technology options, with operating temperatures from -55°C to +155°C
-  The “star” cell is supported in the S8PHIRS technology option. Its cell size is approximately 25% smaller than the original cell, but its temperature range is restricted to -40°C to +125°C.

Spice models for the memory cells exist for multiple conditions:


.. include:: device-details/special_sonosfet/special_sonosfet-table0.rst



Program and Erase characteristics are described in more detail in the ***S8 Nonvolatile Technology Spec*** (001-08712), and summarized below:


.. include:: device-details/special_sonosfet/special_sonosfet-table1.rst



Endurance behavior is illustrated below (100K cycles guaranteed):

|sonos-erase-program|

Data retention behavior is shown below at 85C\ |sonos-data-retention|

E-test parameters are summarized below for both original and star cells:


.. include:: device-details/special_sonosfet/special_sonosfet-table2.rst



The schematic for the 2-T SONOS memory cell is shown below:

|schematic-sonos-cell|

The cross-section of the 2-T SONOS cell is shown below.

|cross-section-sonos-cell|

.. |sonos-erase-program| image:: device-details/special_sonosfet/sonos-erase-program.svg
.. |sonos-data-retention| image:: device-details/special_sonosfet/sonos-data-retention.svg
.. |schematic-sonos-cell| image:: device-details/special_sonosfet/schematic-sonos-cell.svg
.. |cross-section-sonos-cell| image:: device-details/special_sonosfet/cross-section-sonos-cell.svg


Generic resistors
-----------------

Generic resistors are supported in the PDK but are not recommended for analog applications. Resistor values will be extracted from the layout as long as the resistor layer is utilized, for LVS against schematic elements.

The following 3-terminal resistors are available, and have built-in diodes inside the models:

-  N+ diffusion (type “ :cell:`sky130_fd_pr__res_generic_nd` ”, model :model:`sky130_fd_pr__res_generic_nd` )
-  P+ diffusion (type “ :cell:`sky130_fd_pr__res_generic_pd` ”, model :model:`sky130_fd_pr__res_generic_pd` )
-  P-well (type “sky130_fd_pr__res_generic_pw”, model sky130_fd_pr__res_iso_pw)

The following 2-terminal resistors are available:

-  N+ doped gate poly (:model:`sky130_fd_pr__res_generic_po`)
-  Local interconnect (:model:`sky130_fd_pr__res_generic_l1`)
-  Metal-1 (:model:`sky130_fd_pr__res_generic_m1`)
-  Metal-2 (:model:`sky130_fd_pr__res_generic_m2`)
-  Metal-3 (:model:`sky130_fd_pr__res_generic_m3`)
-  Metal-4 (:model:`sky130_fd_pr__res_generic_m4`)
-  Metal-5 (:model:`sky130_fd_pr__res_generic_m5`)

Specs for the generic resistors are shown below.


.. include:: device-details/res_generic/res_generic-table0.rst



Symbols for all resistors are shown below:

|symbol-res_generic_nd| |symbol-res_generic_pd|

:model:`sky130_fd_pr__res_generic_nd` :model:`sky130_fd_pr__res_generic_pd`

|symbol-res_generic_pw| |symbol-res_generic_po|

:model:`sky130_fd_pr__res_generic_pw` :model:`sky130_fd_pr__res_generic_po`

|symbol-res_generic_l1| |symbol-res_generic_m1|

:model:`sky130_fd_pr__res_generic_l1` :model:`sky130_fd_pr__res_generic_m1`

|symbol-res_generic_m2| |symbol-res_generic_m3|

:model:`sky130_fd_pr__res_generic_m2` :model:`sky130_fd_pr__res_generic_m3`

|symbol-res_generic_m4| |symbol-res_generic_m5|

:model:`sky130_fd_pr__res_generic_m4` :model:`sky130_fd_pr__res_generic_m5`

.. |symbol-res_generic_nd| image:: device-details/res_generic/symbol-res_generic_nd.svg
.. |symbol-res_generic_pd| image:: device-details/res_generic/symbol-res_generic_pd.svg
.. |symbol-res_generic_pw| image:: device-details/res_generic/symbol-res_generic_pw.svg
.. |symbol-res_generic_po| image:: device-details/res_generic/symbol-res_generic_po.svg
.. |symbol-res_generic_l1| image:: device-details/res_generic/symbol-res_generic_l1.svg
.. |symbol-res_generic_m1| image:: device-details/res_generic/symbol-res_generic_m1.svg
.. |symbol-res_generic_m2| image:: device-details/res_generic/symbol-res_generic_m2.svg
.. |symbol-res_generic_m3| image:: device-details/res_generic/symbol-res_generic_m3.svg
.. |symbol-res_generic_m4| image:: device-details/res_generic/symbol-res_generic_m4.svg
.. |symbol-res_generic_m5| image:: device-details/res_generic/symbol-res_generic_m5.svg


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


.. include:: device-details/res_high/res_high-table0.rst



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

.. |res_high_po| image:: device-details/res_high/res_high_po.svg
.. |symbol-res_high_po_0p35| image:: device-details/res_high/symbol-res_high_po_0p35.svg
.. |symbol-res_high_po_0p69| image:: device-details/res_high/symbol-res_high_po_0p69.svg
.. |symbol-res_high_po_1p41| image:: device-details/res_high/symbol-res_high_po_1p41.svg
.. |symbol-res_high_po_2p85| image:: device-details/res_high/symbol-res_high_po_2p85.svg
.. |symbol-res_high_po_5p73| image:: device-details/res_high/symbol-res_high_po_5p73.svg
.. |symbol-res_high_po| image:: device-details/res_high/symbol-res_high_po.svg


P- poly precision resistors
---------------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`res_xhigh_po_XpXX`, :cell:`sky130_fd_pr__res_xhigh_po`
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

The resistors are modeled using the same equations as for the P+ poly resistors. In the case of the P- poly resistors, a separate implant is used to set the sheet resistance to 2000 ohm/sq.

Fixed value resistors have the same layout footprints as their P+ poly counterparts. Electrical and e-test specs are still TBD, once sufficient silicon has been evaluated. More details on the use of the precision resistors, and their models, are in the document ***SKY130 process Family Device Models*** (002-21997), currently under development.

The symbols for the 2000 ohm/sq precision resistors are shown below:

|symbol-res_xhigh_po_0p35| |symbol-res_xhigh_po_0p69|

:model:`sky130_fd_pr__res_xhigh_po_0p35` :model:`sky130_fd_pr__res_xhigh_po_0p69`

|symbol-res_xhigh_po_1p41| |symbol-res_xhigh_po_2p85|

:model:`sky130_fd_pr__res_xhigh_po_1p41` :model:`sky130_fd_pr__res_xhigh_po_2p85`

|symbol-res_xhigh_po_5p73|

:model:`sky130_fd_pr__res_xhigh_po_5p73`

A generic version of the poly resistor is also available, which permits user inputs for W and L, and connections in series or parallel.

|symbol-res_xhigh_po|

.. |symbol-res_xhigh_po_0p35| image:: device-details/res_xhigh/symbol-res_xhigh_po_0p35.svg
.. |symbol-res_xhigh_po_0p69| image:: device-details/res_xhigh/symbol-res_xhigh_po_0p69.svg
.. |symbol-res_xhigh_po_1p41| image:: device-details/res_xhigh/symbol-res_xhigh_po_1p41.svg
.. |symbol-res_xhigh_po_2p85| image:: device-details/res_xhigh/symbol-res_xhigh_po_2p85.svg
.. |symbol-res_xhigh_po_5p73| image:: device-details/res_xhigh/symbol-res_xhigh_po_5p73.svg
.. |symbol-res_xhigh_po| image:: device-details/res_xhigh/symbol-res_xhigh_po.svg


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


.. include:: device-details/cap_mim/cap_mim-table0.rst



The symbol for the MiM capacitor is shown below. Note that the cap model is a sub-circuit which accounts for the parasitic contact resistance and the parasitic capacitance from the bottom plate to substrate.

|symbol-cap_mim|

Cell name

M \* W \* L

Calc capacitance

The cross-section of the “stacked” MiM capacitor is shown below:

|cross-section-cap_mim|

.. |symbol-cap_mim| image:: device-details/cap_mim/symbol-cap_mim.svg
.. |cross-section-cap_mim| image:: device-details/cap_mim/cross-section-cap_mim.svg


Vertical Parallel Plate (VPP) capacitors
----------------------------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr__cap_vpp_XXpXxYYpY_{MM}(_shield(SS)*)(_float(FF)*)(_(VVVV))`
-  Model Names: :model:`sky130_fd_pr__cap_vpp_*`

   -  X and Y are size dimentions
   -  MM refers to the layers which are used for the capacitance
   -  SS refers to the layers which are used as shields (`noshield` when no shield is used)
   -  FF refers to the layers which are floating.
   -  VVVVV refers to the "variant" when there are multiple devices of the same configuration

Operating Voltages where SPICE models are valid

-  :math:`|V_{c0} – V_{c1}| = 0` to 5.5V

Details
~~~~~~~

The VPP caps utilize the tight spacings of the metal lines to create capacitors using the available metal layers. The fingers go in opposite directions to minimize alignment-related variability, and the capacitor sits on field oxide to minimize silicon capacitance effects. A schematic diagram of the layout is shown below:

.. todo::

    M3

    **M2**

    LI

    M1

    LAYOUT of M2, M3, M4

    LAYOUT of LI and M1 (with POLY sheet)

    **POLY**

    **M4**

These capacitors are fixed-size, and they can be connected together to multiply the effective capacitance of a given node. There are two different constructions.

Parallel VPP Capacitors
^^^^^^^^^^^^^^^^^^^^^^^

These are older versions, where stacked metal lines run parallel:


-  :model:`sky130_fd_pr__cap_vpp_08p6x07p8_m1m2_noshield` (M1 \|\| M2 only, 7.84 x 8.58)
-  :model:`sky130_fd_pr__cap_vpp_04p4x04p6_m1m2_noshield_o2` (M1 \|\| M2 only, 4.38 x 4.59)
-  :model:`sky130_fd_pr__cap_vpp_02p4x04p6_m1m2_noshield` (M1 \|\| M2 only, 2.19 x 4.59)
-  :model:`sky130_fd_pr__cap_vpp_04p4x04p6_m1m2_noshield` (M1 :sub:`┴` M2, 4.4 x 4.6, 4 quadrants)
-  :model:`sky130_fd_pr__cap_vpp_11p5x11p7_m1m2_noshield` (M1 :sub:`┴` M2, 11.5 x 11.7, 4 quadrants)
-  :model:`sky130_fd_pr__cap_vpp_44p7x23p1_pol1m1m2m3m4m5_noshield`
-  :model:`sky130_fd_pr__cap_vpp_02p7x06p1_m1m2m3m4_shieldl1_fingercap` (M1 \|\| M2 \|\| M3 \|\| M4, 2.7 x 5.0)
-  :model:`sky130_fd_pr__cap_vpp_02p9x06p1_m1m2m3m4_shieldl1_fingercap2` (M1 \|\| M2 \|\| M3 \|\| M4, 2.85 x 5.0)
-  :model:`sky130_fd_pr__cap_vpp_02p7x11p1_m1m2m3m4_shieldl1_fingercap` (M1 \|\| M2 \|\| M3 \|\| M4, 2.7 x 10.0)
-  :model:`sky130_fd_pr__cap_vpp_02p7x21p1_m1m2m3m4_shieldl1_fingercap` (M1 \|\| M2 \|\| M3 \|\| M4, 2.7 x 20.0)
-  :model:`sky130_fd_pr__cap_vpp_02p7x41p1_m1m2m3m4_shieldl1_fingercap` (M1 \|\| M2 \|\| M3 \|\| M4, 2.7 x 40.0)

The symbol for these capacitors is shown below. The terminals c0 and c1 represent the two sides of the capacitor, with b as the body (sub or well).

|symbol-cap_vpp-parallel|

Perpendicular VPP Capacitors
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

These are newer versions, where stacked metal lines run perpendicular and there are shields on top and bottom:

-  :model:`sky130_fd_pr__cap_vpp_11p5x11p7_l1m1m2m3m4_shieldm5` (11.5x11.7, with M5 shield)
-  :model:`sky130_fd_pr__cap_vpp_11p5x11p7_l1m1m2m3m4_shieldpom5` (11.5x11.7, with poly and M5 shield)
-  :model:`sky130_fd_pr__cap_vpp_11p5x11p7_m1m2m3m4_shieldl1m5` (11.5x11.7, with LI and M5 shield)
-  :model:`sky130_fd_pr__cap_vpp_04p4x04p6_m1m2m3_shieldl1m5_floatm4` (4.4x4.6, M3 float, LI / M5 shield)
-  :model:`sky130_fd_pr__cap_vpp_08p6x07p8_m1m2m3_shieldl1m5_floatm4` (8.6x7.9, M3 float, LI / M5 shield)
-  :model:`sky130_fd_pr__cap_vpp_11p5x11p7_m1m2m3_shieldl1m5_floatm4` (11.5x11.7, M3 float, LI / M5 shield)
-  :model:`sky130_fd_pr__cap_vpp_11p5x11p7_l1m1m2m3_shieldm4` (11.5x11.7, with M4 shield)
-  :model:`sky130_fd_pr__cap_vpp_06p8x06p1_l1m1m2m3_shieldpom4` (6.8x6.1, with poly and M4 shield)
-  :model:`sky130_fd_pr__cap_vpp_06p8x06p1_m1m2m3_shieldl1m4` (6.8x6.1, with LI and M4 shield)
-  :model:`sky130_fd_pr__cap_vpp_11p3x11p8_l1m1m2m3m4_shieldm5` (11.5x11.7, over 2 :model:`sky130_fd_pr__nfet_05v0_nvt` of 10/4 each)

The symbol for these capacitors is shown below. The terminals c0 and c1 are the two capacitor terminals, “top” represents the top shield and “sub” the bottom shield.

|symbol-cap_vpp-perpendicular|

The capacitors are fixed-size elements and must be used as-is; they can be used in multiples.


.. include:: device-details/cap_vpp/cap_vpp-table0.rst

.. |symbol-cap_vpp-parallel| image:: device-details/cap_vpp/symbol-cap_vpp-parallel.svg
.. |symbol-cap_vpp-perpendicular| image:: device-details/cap_vpp/symbol-cap_vpp-perpendicular.svg

