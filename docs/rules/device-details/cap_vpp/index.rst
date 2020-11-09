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


.. include:: cap_vpp-table0.rst

.. |symbol-cap_vpp-parallel| image:: symbol-cap_vpp-parallel.svg
.. |symbol-cap_vpp-perpendicular| image:: symbol-cap_vpp-perpendicular.svg
