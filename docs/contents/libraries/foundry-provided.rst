SkyWater Foundry Provided Standard Cell Libraries
=================================================

There are seven standard cell libraries provided directly by the SkyWater Technology foundry available for use on SKY130 designs, which differ in intended applications and come in three separate cell heights.

Libraries :lib:`sky130_fd_sc_hs` (high speed), :lib:`sky130_fd_sc_ms` (medium speed), :lib:`sky130_fd_sc_ls` (low speed), and :lib:`sky130_fd_sc_lp` (low power) are compatible in size, with a 0.48 x 3.33um site, equivalent to about 11 :layer:`met1` tracks.

Libraries :lib:`sky130_fd_sc_hd` (high density) and :lib:`sky130_fd_sc_hdll` (high density, low leakage) contain standard cells that are smaller, utilizing a 0.46 x 2.72um site, equivalent to 9 :layer:`met1` tracks.

The :lib:`sky130_fd_sc_hvl` (high voltage) library contains 5V devices and utilizes a 0.48 x 4.07um site, or 14 :layer:`met1` tracks.

Supply voltage, FETs, and approximate cell counts for these libraries appear in the table below:

+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
|                                   | :lib:`sky130_fd_sc_lp`              | :lib:`sky130_fd_sc_ls`              | :lib:`sky130_fd_sc_ms`              | :lib:`sky130_fd_sc_hs`              | :lib:`sky130_fd_sc_hd`          | :lib:`sky130_fd_sc_hdll`            | :lib:`sky130_fd_sc_hvl`              |
+===================================+=====================================+=====================================+=====================================+=====================================+=================================+=====================================+======================================+
| VDD                               | 1.8                                 | 1.8                                 | 1.8                                 | 1.8                                 | 1.8                             | 1.8                                 | 5                                    |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| NMOS devices used                 | :cell:`sky130_fd_pr__nfet_01v8`     | :cell:`sky130_fd_pr__nfet_01v8`     | :cell:`sky130_fd_pr__nfet_01v8_lvt` | :cell:`sky130_fd_pr__nfet_01v8_lvt` | :cell:`sky130_fd_pr__nfet_01v8` | :cell:`sky130_fd_pr__nfet_01v8`     | :cell:`sky130_fd_pr__nfet_g5v0d10v5` |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| PMOS devices used                 | :cell:`sky130_fd_pr__pfet_01v8_hvt` | :cell:`sky130_fd_pr__pfet_01v8_hvt` | :cell:`sky130_fd_pr__pfet_01v8`     | :cell:`sky130_fd_pr__pfet_01v8_lvt` | :cell:`sky130_fd_pr__pfet_01v8` | :cell:`sky130_fd_pr__pfet_01v8_hvt` | :cell:`sky130_fd_pr__pfet_g5v0d10v5` |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| inverters, buffers                | 108                                 | 48                                  | 48                                  | 48                                  | 56                              | 62                                  | 19                                   |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| AND, OR, NAND, NOR                | 159                                 | 66                                  | 86                                  | 86                                  | 153                             | 170                                 | 8                                    |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| XOR, XNOR                         | 16                                  | 12                                  | 12                                  | 12                                  | 8                               | 10                                  | 2                                    |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| AND-OR-INV, OR-AND-INV            | 138                                 | 71                                  | 71                                  | 71                                  | 115                             | 125                                 | 4                                    |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| AND-OR, OR-AND                    | 132                                 | 68                                  | 68                                  | 68                                  | 132                             | 134                                 | 4                                    |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| Adders, Comparators, Multiplexors | 59                                  | 37                                  | 33                                  | 33                                  | 31                              | 44                                  | 11                                   |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| Latches and Flip-Flops            | 92                                  | 68                                  | 68                                  | 68                                  | 60                              | 60                                  | 17                                   |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| Custom power gating, bus cells    | 43                                  | 66                                  | 42                                  | 42                                  | 51                              | 42                                  |                                      |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| Macro cells                       |                                     | 5                                   |                                     |                                     |                                 |                                     |                                      |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+
| UDB custom cells                  |                                     | 21                                  | 17                                  |                                     |                                 |                                     |                                      |
+-----------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+-------------------------------------+---------------------------------+-------------------------------------+--------------------------------------+

The libraries uses 4 terminal transistors throughout. Individual cells do not have tap in them for the most part (there are a few exceptions). Instead, there are tap cells provided that allow for a staggered tap grid to be placed and connected to allow for body biasing, sleep mode support, and latchup protection.

The following sections will review the libraries in more detail, in terms of performance.

+-------------------------+-----------+--------------+--------------+--------------+
| Architecture Comparison | Low Speed | High Density | High Density | High Voltage |
|                         |           |              | Low Leakage  |              |
+=========================+===========+==============+==============+==============+
| TAP BAR                 | NO        | NO           | NO           | YES          |
+-------------------------+-----------+--------------+--------------+--------------+
| X-GRID                  | 0.480     | 0.460        | 0.460        | 0.480        |
+-------------------------+-----------+--------------+--------------+--------------+
| Y-GRID                  | 0.370     | 0.340        | 0.340        | 0.370        |
+-------------------------+-----------+--------------+--------------+--------------+
| CELL HEIGHT             | 9 GRIDS   | 8 GRIDS      | 8 GRIDS      | 11 GRIDS     |
+-------------------------+-----------+--------------+--------------+--------------+
| CELL HEIGHT             | 3.330     | 2.720        | 2.720        | 4.07         |
+-------------------------+-----------+--------------+--------------+--------------+
| NAND2 WIDTH             | 3 GRIDS   | 3 GRIDS      | 4 GRIDS      | 5 GRIDS      |
+-------------------------+-----------+--------------+--------------+--------------+
| NAND2 WIDTH             | 1.440     | 1.380        | 1.840        | 2.400        |
+-------------------------+-----------+--------------+--------------+--------------+
| NAND2 AREA              | 4.7952    | 3.7536       | 5.0048       | 9.770        |
+-------------------------+-----------+--------------+--------------+--------------+
| WPMAX                   | 1.120     | 1.000        | 1.000        | 1.500        |
+-------------------------+-----------+--------------+--------------+--------------+
| WNMAX                   | 0.740     | 0.650        | 0.650        | 0.75         |
+-------------------------+-----------+--------------+--------------+--------------+


:lib:`sky130_fd_sc_hd` - High Density Standard Cell Library
-----------------------------------------------------------

The :lib:`sky130_fd_sc_hd` library is designed for high density.

Compared to :lib:`sky130_fd_sc_ls`, this library enables higher routed gated density, lower dynamic power consumption, and comparable timing and leakage power. As a trade-off it has lower drive strength and does not support any drop in replacement medium or high speed library.

-  :lib:`sky130_fd_sc_hd` includes clock-gating cells to reduce active power during non-sleep modes.

-  Latches and flip-flops have scan equivalents to enable scan chain creation.

-  Multi-voltage domain library cells are provided.

-  Routed Gate Density is 160 kGates/mm^2 or better.

-  leakage @ttleak\_1.80v\_25C (no body bias) is 0.86 nA / kGate

-  :cell:`sky130_fd_sc_XX__buf_16` max cap (ss\_1.60v\_-40C, in/out tran=1.5ns) is 0.746 pF

-  Body Bias-able


:lib:`sky130_fd_sc_hdll` - High Density, Low Leakage Standard Cell Library
--------------------------------------------------------------------------

The :lib:`sky130_fd_sc_hdll` library is a low leakage high density standard cell library.

Compared to :lib:`sky130_fd_sc_hd`, this library enables 5-10X lower leakage power, but the same X, Y pin grids, routing layer pitches, and cell height.

Blocks should be DRC clean when intermingled with :lib:`sky130_fd_sc_hd` cells.

Raw gate density (number of :cell:`sky130_fd_sc_hdll__nand2_1` gates able to fit in 1mm2) for :lib:`sky130_fd_sc_hd` is 266kGates/mm2 and 200kGates/mm2 for :lib:`sky130_fd_sc_hdll`.

-  Includes integrating clock-gating cells to reduce active power during non-sleep modes

-  Latches and flip-flops in the library have a scan equivalent implementation to enable scan chain creation and testing supported by the synthesis tools

-  Multi-voltage domain library cells are provided

-  Routed Gate Density is 120 kGates/mm^2

-  leakage @ttleak\_1.80v\_25C (no body bias) is 0.08 nA / kGate

-  :cell:`sky130_fd_sc_XX__buf_16` max cap (ss\_1.60v\_-40C, in/out tran=1.5ns) < 1 pF

-  Multi-Voltage Design Support

-  Body Bias-able


:lib:`sky130_fd_sc_hs` - Low Voltage (<2.0V), High Speed, Standard Cell Library
-------------------------------------------------------------------------------

:lib:`sky130_fd_sc_hs` library enables the implementation of low voltage high speed logic blocks in the SKY130 technology.

:lib:`sky130_fd_sc_hs` cells are drop-in compatible with :lib:`sky130_fd_sc_ms`a or :lib:`sky130_fd_sc_ls` for the same function and drive strength. :lib:`sky130_fd_sc_hs` has the highest speed and the highest leakage of these.

All logic cells are implemented with low voltage transistors and should be powered within the limits of those transistors. Specifically, the timing and power models are valid from 1.60V up to 1.95V, with timing data included for 10% and 20% dynamic IR drop analysis.

All cells are functional at 1.2v. The low to high level shifter cells are capable of shifting from 1.2v to 1.95v.


:lib:`sky130_fd_sc_ms`  - Low Voltage (<2.0V), Medium Speed, Standard Cell Library
----------------------------------------------------------------------------------

:lib:`sky130_fd_sc_ms` is drop-in compatible with :lib:`sky130_fd_sc_ls` or :lib:`sky130_fd_sc_hs` libraries for cells of the same function and drive strength. :lib:`sky130_fd_sc_ms` cells have medium speed and leakage.

:lib:`sky130_fd_sc_ms` is implemented with low voltage transistors; timing and power models are valid from 1.60V up to 1.95V. All cells are functional at 1.2v.

The low to high level shifter cells are capable of shifting from 1.2v to 1.95v.

-  The library supports low leakage sleep mode via state retention flops

-  Includes integrating clock-gating cells to reduce active power during non-sleep modes

-  Latches and flip-flops in the library have a scan equivalent implementation to enable scan chain creation and testing supported by the synthesis tools

-  Library details:

   -  Inverters and buffers: 48

   -  AND, OR, NAND, NOR gates: 86

   -  Exclusive-OR and Exclusive-NOR: 12

   -  Inverted And-Or and Inverted Or-And: 71

   -  And-Or and Or-And: 68

   -  Adders, Comparators and Multiplexers: 33

   -  Latches and filp-flops: 68

   -  Low Power Flow Cells: 42

   -  UDB custom cells: 17


:lib:`sky130_fd_sc_ls`  - Low Voltage (<2.0V), Low Speed, Standard Cell Library
-------------------------------------------------------------------------------

:lib:`sky130_fd_sc_ls` cells are drop-in compatible with :lib:`sky130_fd_sc_ms`a or :lib:`sky130_fd_sc_hs` for the same function and drive strength. :lib:`sky130_fd_sc_ls` has the lowest speed and the lowest leakage of these.

:lib:`sky130_fd_sc_ls` is implemented with low voltage transistors; timing and power models are valid from 1.60V up to 1.95V. All cells are functional at 1.2v.

The low to high level shifter cells are capable of shifting from 1.2v to 1.95v.

-  The library supports low leakage sleep mode via sleep transistors

-  Includes integrating clock-gating cells to reduce active power during non-sleep modes

-  Latches and flip-flops in the library have a scan equivalent implementation to enable scan chain creation and testing supported by the synthesis tools

-  Drop-in compatible with :lib:`sky130_fd_sc_ms` and :lib:`sky130_fd_sc_hs` libraries

-  Only the high to low level-shifters are functional at 1v (:cell:`sky130_fd_sc_ls__lpflow_lsbuf_hl_*`). The low to high level-shifters (:cell:`sky130_fd_sc_ls__lpflow_lsbuf_lh_*`) are not functional at 1v as the threshold voltages of the FETs are not enough to flip the state.

-  Library details:

   -  Inverters and buffers: 48

   -  AND, OR, NAND, NOR gates: 86

   -  Exclusive-OR and Exclusive-NOR: 12

   -  Inverted And-Or and Inverted Or-And: 71

   -  And-Or and Or-And: 68

   -  Adders, Comparators and Multiplexers: 37

   -  Latches and filp-flops: 68

   -  Low Power Flow Cells: 66

   -  Macro Cells: 5

   -  UDB Custom Cells: 21


:lib:`sky130_fd_sc_lp` - Low Voltage (<2.0V), Low Power, Standard Cell Library
------------------------------------------------------------------------------

:lib:`sky130_fd_sc_lp` is the largest of the SKY130 standard cell libraries at nearly 750 cells. All logic cells are implemented with low voltage transistors and should be powered within the limits of those transistors. Specifically, the timing and power models are valid from 1.55V up to 2.0V.

-  :lib:`sky130_fd_sc_lp` supports low leakage sleep mode via sleep transistors

-  Includes integrating clock-gating cells to reduce active power during non-sleep modes

-  Latches and flip-flops have scan equivalents to enable scan chain creation

-  Larger Library size:

   -  Inverters, Buffers: 108

   -  AND, OR, NAND, NOR gates: 159

   -  Exclusive-OR, Exclusive-NOR: 16

   -  AND-OR-Inverted, OR-AND-Inverted: 138

   -  AND-OR, OR-AND: 132

   -  Adders, Comparators, Multiplexors: 59

   -  Custom Power gating, bus cells: 43

   -  Latches and flip-flops: 92


:lib:`sky130_fd_sc_hvl` - High Voltage (5V), Standard Cell Library
------------------------------------------------------------------

The :lib:`sky130_fd_sc_hvl` library has the smallest cell count of the SKY130 standard cell libraries, but is the only one that enables 5V tolerant logic blocks. All logic cells are implemented with 5v tolerant transistors; timing and power models are valid from 1.65v to 5.5v. The low voltage to high voltage level shifter is functional shifting from 1.2v to 5.5v.

Raw gate density (number of :cell:`sky130_fd_sc_hvl__nand2_1` gates able to fit in 1mm2) should be 170kGates/mm2.

Routed should be >= 100kGates/mm2. Due to the gate length for these high voltage transistors, the actual gate density is lower than 170kGates/mm2. The size of a 2-input NAND gate in this library is actually 5 grids wide, whereas the 170k calculation is based on a gate that is 3 grids wide. With a 5 grid wide gate, the raw gate density is 102kGates/mm2.
