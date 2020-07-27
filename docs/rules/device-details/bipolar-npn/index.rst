Bipolar (NPN)
-------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr_base__npn4`
-  Model Names: :model:`sky130_fd_pr_base__npnpar1x1`, :model:`sky130_fd_pr_base__npnpar1x2`, :model:`sky130_fd_pr_base__npn_1x1_2p0_hv`

Operating regime where SPICE models are valid

-  \|V\ :sub:`CE`\ \| = 0 to 5.0V
-  \|V\ :sub:`BE`\ \| = 0 to 5.0V
-  I\ :sub:`CE` = 0.01 to 10 µA/µm\ :sup:`2`

Details
~~~~~~~

The SKY130 process offers “free” NPN devices. The NPN uses the deep n-well as the collector. The device is not optimized, and must be used in the forward-active mode. The following sizes of NPN’s are available:

-  ungated device with emitter 1.0 x 1.0
-  ungated device with emitter 1.0 x 2.0
-  poly-gated version with octagonal emitter of A = 1.97 µm\ :sup:`2`

The :model:`sky130_fd_pr_base__npn_1x1_2p0_hv` device has a poly gate placed between the emitter and base diffusions, to prevent carrier recombination at the STI edge and increase β. The poly gate is connected to the emitter terminal.

Using this device must be done in conjunction with the correct guard rings, to avoid potential latchup issues with nearby circuitry. Reverse-active mode operation of the BJT’s are neither modeled nor permitted. E-test specs for the NPN devices are shown in the table below:


.. include:: bipolar-npn-table0.rst



Symbols for the npnpar are shown below

|symbol-bipolar-npn-1| |symbol-bipolar-npn-2| |symbol-bipolar-npn-3|

The cross-section of the :model:`sky130_fd_pr_base__npnpar1x1`/:model:`sky130_fd_pr_base__npnpar1x2` is shown below.

|cross-section-bipolar-npnpar1x|

The cross-section of the :model:`sky130_fd_pr_base__npn_1x1_2p0_hv` is shown below. The poly gate is tied to the emitter to prevent the parasitic MOSFET from turning on.

|cross-section-bipolar-npn_1x1_2p0_hv|

.. |symbol-bipolar-npn-1| image:: symbol-bipolar-npn-1.svg
.. |symbol-bipolar-npn-2| image:: symbol-bipolar-npn-2.svg
.. |symbol-bipolar-npn-3| image:: symbol-bipolar-npn-3.svg
.. |cross-section-bipolar-npnpar1x| image:: cross-section-bipolar-npnpar1x.svg
.. |cross-section-bipolar-npn_1x1_2p0_hv| image:: cross-section-bipolar-npn_1x1_2p0_hv.svg

