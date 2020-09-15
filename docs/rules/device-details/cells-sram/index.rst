SRAM cells
----------

The SKY130 process currently supports only single-port SRAM’s, which are contained in hard-IP libraries. These cells are constructed with smaller design rules (Table 9), along with OPC (optical proximity correction) techniques, to achieve small memory cells. Use of the memory cells or their devices outside the specific IP is prohibited. The schematic for the SRAM is shown below in Figure 10. This cell is available in the S8 IP offerings and is monitored at e-test through the use of “pinned out” devices within the specific arrays.

|figure-10-schematics-of-the-single-port-sram|

**Figure 10. Schematics of the Single Port SRAM.**

A Dual-Port SRAM is currently being designed using a similar approach. Compilers for the SP and DP SRAM’s will be available end-2019.

Operating Voltages where SPICE models are valid

-  V\ :sub:`DS` = 0 to 1.8V
-  V\ :sub:`GS` = 0 to 1.8V
-  V\ :sub:`BS` = 0 to -1.8V

Details
~~~~~~~

N-pass FET (SRAM)
^^^^^^^^^^^^^^^^^

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr_base__nfet`
-  Model Name (SRAM): :model:`sky130_fd_pr_base__npass.1`


.. include:: cells-sram-table0.rst



N-latch FET (SRAM)
^^^^^^^^^^^^^^^^^^

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr_base__nfet`
-  Model Name (SRAM): :model:`sky130_fd_pr_base__npd.1`


.. include:: cells-sram-table1.rst



P-latch FET (SRAM)
^^^^^^^^^^^^^^^^^^

Spice Model Information
~~~~~~~~~~~~~~~~~~~~~~~

-  Cell Name: :cell:`sky130_fd_pr_base__pfet`
-  Model Name (SRAM): :model:`sky130_fd_pr_base__ppu.1`


.. include:: cells-sram-table2.rst



.. |figure-10-schematics-of-the-single-port-sram| image:: figure-10-schematics-of-the-single-port-sram.svg

