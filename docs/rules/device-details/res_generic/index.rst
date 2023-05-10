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


.. include:: res_generic-table0.rst



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

.. |symbol-res_generic_nd| image:: symbol-res_generic_nd.svg
.. |symbol-res_generic_pd| image:: symbol-res_generic_pd.svg
.. |symbol-res_generic_pw| image:: symbol-res_generic_pw.svg
.. |symbol-res_generic_po| image:: symbol-res_generic_po.svg
.. |symbol-res_generic_l1| image:: symbol-res_generic_l1.svg
.. |symbol-res_generic_m1| image:: symbol-res_generic_m1.svg
.. |symbol-res_generic_m2| image:: symbol-res_generic_m2.svg
.. |symbol-res_generic_m3| image:: symbol-res_generic_m3.svg
.. |symbol-res_generic_m4| image:: symbol-res_generic_m4.svg
.. |symbol-res_generic_m5| image:: symbol-res_generic_m5.svg

