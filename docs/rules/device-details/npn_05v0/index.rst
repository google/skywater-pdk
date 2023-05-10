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


.. include:: npn_05v0-table0.rst



Symbols for the :model:`sky130_fd_pr__npn_05v5` are shown below

|symbol-npn_05v0-1| |symbol-npn_05v0-2| |symbol-npn_05v0-3|

The cross-section of the :model:`sky130_fd_pr__npn_05v5` is shown below.

|cross-section-npn_05v0|

The cross-section of the :model:`sky130_fd_pr__npn_11v0` is shown below. The poly gate is tied to the emitter to prevent the parasitic MOSFET from turning on.

|cross-section-npn_11v0|

.. |symbol-npn_05v0-1| image:: symbol-npn_05v0-1.svg
.. |symbol-npn_05v0-2| image:: symbol-npn_05v0-2.svg
.. |symbol-npn_05v0-3| image:: symbol-npn_05v0-3.svg
.. |cross-section-npn_05v0| image:: cross-section-npn_05v0.svg
.. |cross-section-npn_11v0| image:: cross-section-npn_11v0.svg

