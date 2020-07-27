Vertical Parallel Plate (VPP) capacitors
----------------------------------------

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr_base__cap_int3_vppcap`
-  Model Names: :model:`sky130_fd_pr_base__xcmvppXxY _{MMshield}`

   -  X and Y are size dimentions
   -  {MMshield} refers to metal layer used as shield

Operating Voltages where SPICE models are valid

-  \|V\ :sub:`c0` – V\ :sub:`c1`\ \| = 0 to 5.5V

Details
~~~~~~~

The VPP caps utilize the tight spacings of the metal lines to create capacitors using the available metal layers. The fingers go in opposite directions to minimize alignment-related variability, and the capacitor sits on field oxide to minimize silicon capacitance effects. A schematic diagram of the layout is shown below:

M3

**M2**

LI

M1

LAYOUT of M2, M3, M4

LAYOUT of LI and M1 (with POLY sheet)

**POLY**

**M4**

These capacitors are fixed-size, and they can be connected together to multiply the effective capacitance of a given node. There are multiple constructions under two different cell names:

cap\_int3—these are older versions, where stacked metal lines run parallel

-  xcmvpp3 (M1 \|\| M2 only, 7.84 x 8.58)
-  xcmvpp4 (M1 \|\| M2 only, 4.38 x 4.59)
-  xcmvpp5 (M1 \|\| M2 only, 2.19 x 4.59)
-  xcmvpp4p4x4p6\_m1m2 (M1 :sub:`┴` M2, 4.4 x 4.6, 4 quadrants)
-  xcmvpp11p5x11p7\_m1m2 (M1 :sub:`┴` M2, 11.5 x 11.7, 4 quadrants)
-  xcmvpp\_hd5\_4x2
-  xcmvpp\_hd5\_atlas\_fingercap\_l5 (M1 \|\| M2 \|\| M3 \|\| M4, 2.7 x 5.0)
-  xcmvpp\_hd5\_atlas\_fingercap2\_l5 (M1 \|\| M2 \|\| M3 \|\| M4, 2.85 x 5.0)
-  xcmvpp\_hd5\_atlas\_fingercap\_l10 (M1 \|\| M2 \|\| M3 \|\| M4, 2.7 x 10.0)
-  xcmvpp\_hd5\_atlas\_fingercap\_l20 (M1 \|\| M2 \|\| M3 \|\| M4, 2.7 x 20.0)
-  xcmvpp\_hd5\_atlas\_fingercap\_l40 (M1 \|\| M2 \|\| M3 \|\| M4, 2.7 x 40.0)

The symbol for the cap\_int3 is shown below. The terminals c0 and c1 represent the two sides of the capacitor, with b as the body (sub or well).

|symbol-capacitor-vpp-cap_int3|

cap\_int3

vppcap—newer versions, where stacked metal lines run perpendicular and there are shields on top and bottom

-  xcmvpp11p5x11p7\_m5shield (11.5x11.7, with M5 shield)
-  xcmvpp11p5x11p7\_polym5shield (11.5x11.7, with poly and M5 shield)
-  xcmvpp11p5x11p7\_lim5shield (11.5x11.7, with LI and M5 shield)
-  xcmvpp4p4x4p6\_m3\_lim5shield (4.4x4.6, M3 float, LI / M5 shield)
-  xcmvpp8p6x7p9\_m3\_lim5shield (8.6x7.9, M3 float, LI / M5 shield)
-  xcmvpp11p5x11p7\_m3\_lim5shield (11.5x11.7, M3 float, LI / M5 shield)
-  xcmvpp11p5x11p7\_m4shield (11.5x11.7, with M4 shield)
-  xcmvpp6p8x6p1\_polym4shield (6.8x6.1, with poly and M4 shield)
-  xcmvpp6p8x6p1\_lim4shield (6.8x6.1, with LI and M4 shield)
-  xcmvppx4x2xnhative10x4 (11.5x11.7, over 2 nhvnative of 10/4 each)

The symbol for the vppcap is shown below. The terminals c0 and c1 are the two capacitor terminals, “top” represents the top shield and “sub” the bottom shield.

|symbol-capacitor-vpp-cap|

The capacitors are fixed-size elements and must be used as-is; they can be used in multiples.


.. include:: capacitors-vpp-table0.rst



This page intentionally left blank

.. |symbol-capacitor-vpp-cap_int3| image:: symbol-capacitor-vpp-cap_int3.svg
.. |symbol-capacitor-vpp-cap| image:: symbol-capacitor-vpp-cap.svg

