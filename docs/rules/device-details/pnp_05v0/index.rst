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


.. include:: pnp_05v0-table0.rst



Symbols for the :model:`sky130_fd_pr__pnp_05v5` is shown below

|symbol-pnp_05v0-a| |symbol-pnp_05v0-b|

The cross-section of the :model:`sky130_fd_pr__pnp_05v5` is shown below.

No deep n-well exists in this device; the collector is the substrate.

|cross-section-pnp_05v0|

.. |symbol-pnp_05v0-a| image:: symbol-pnp_05v0-a.svg
.. |symbol-pnp_05v0-b| image:: symbol-pnp_05v0-b.svg
.. |cross-section-pnp_05v0| image:: cross-section-pnp_05v0.svg

