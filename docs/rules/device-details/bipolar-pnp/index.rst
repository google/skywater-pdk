Bipolar (PNP)
-------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr_base__pnp4`
-  Model Names: :model:`sky130_fd_pr_base__pnppar`, :model:`sky130_fd_pr_base__pnppar5x`

Operating regime where SPICE models are valid

-  \|V\ :sub:`CE`\ \| = 0 to 5.0V
-  \|V\ :sub:`BE`\ \| = 0 to 5.0V
-  I\ :sub:`CE` = 0.01 to 10 µA/µm\ :sup:`2`

Details
~~~~~~~

The SKY130 process offer a “free” PNP device, which utilizes the substrate as the collector. This device is not independently optimized, and can be used in forward-active mode. The following sizes of PNP are available:

-  ungated device with emitter 0.68 x 0.68 (A=0.4624 µm\ :sup:`2`)
-  ungated device with emitter 3.4 x 3.4 (A=11.56 µm\ :sup:`2`)

Using this device must be done in conjunction with the correct guard rings, to avoid potential latchup issues with nearby circuitry. Reverse-active mode operation of the BJT’s are neither modeled nor permitted.

E-test specs for these devices are shown in the table below:


.. include:: bipolar-pnp-table0.rst



Symbols for the :model:`sky130_fd_pr_base__pnppar` is shown below

|symbol-bipolar-a| |symbol-bipolar-b|

The cross-section of the pnp is shown below.

No deep n-well exists in this device; the collector is the substrate.

|cross-section-bipolar|

.. |symbol-bipolar-a| image:: symbol-bipolar-a.svg
.. |symbol-bipolar-b| image:: symbol-bipolar-b.svg
.. |cross-section-bipolar| image:: cross-section-bipolar.svg

