Antenna Rules
=============

Antenna rules specify the maximum allowed ratio of interconnect area exposed to plasma etch to active gate poly area that is electrically connected to it when the interconnect is etched. Interconnect areas exposed to plasma etch are:

* bottom areas of Licon, Mcon, Via, Via2

* perimeter areas of connection layers Poly, Li, Met1, Met2, Met3

Two types of checks are introduced in the following tables:

* vertical for perimeter area, and

* horizontal for contact area

The numbers checked for are in the MAX_EGAR column.

Definitions
-----------

.. csv-table:: Antenna Rules Definitions
   :file: antenna/definitions.csv
   :header-rows: 1
   :stub-columns: 1

Antenna rule numbers depend on the connection to the following devices:

pAntennaShort = (tap AndNot poly) AndNot nwell
  It is a p+ tap contact used to shortcut to substrate ground buses.

AntennaDiode = (diff OR tap) AndNot (poly OR pAntennaShort)
  It is a reverse biased diode whose leakage current will discharge the interconnect area.

These devices are not subject to LVS check and must not be reported in the schematic.

Antenna rules are defined for the following ratio:

When a diode is used
  ``EGAR``

  Etch Gate Area Ratio = (EA / A_gate) - K x (AntennaDiode_area in um2) - diode_bonus [unitless]

When diodes are not used
  ``EGAR``

  Etch Gate Area Ratio = (EA / A_gate)  [unitless]

where:

* ``K`` is a multiplying factor specified for each layer

* ``AntennaDiode_area`` is the area of the AntennaDiode used to discharge the interconnect area exposed to plasma etch (should be 0 if no diode is used)

The layout should satisfy the condition: ``EGAR`` <= ``MAX_EGAR``. The ``diode_bonus`` applies only when at least one diode is used, regardless from it's size.

Tables
------

.. todo:: Most of these tables should be removed.


.. csv-table:: Table Ia.  Antenna rules (S8D*)
   :file: antenna/table-Ia-antenna-rules-s8d.csv
   :header-rows: 1
   :stub-columns: 1

.. csv-table:: Table Ib. Antenna rules (S8TNV-5R)
   :file: antenna/table-Ib-antenna-rules-s8tnv-5r.csv
   :header-rows: 1
   :stub-columns: 1

.. csv-table:: Table Ic. Antenna rules (S8TM-5R*/S8TMC-5R*/S8TMA-5R*)
   :file: antenna/table-Ic-antenna-rules-s8tm.csv
   :header-rows: 1
   :stub-columns: 1

.. csv-table:: Table Ie. Antenna rules (S8P-5R/SP8P-5R/S8P-10R*)
   :file: antenna/table-Ie-antenna-rules-s8p.csv
   :header-rows: 1
   :stub-columns: 1

.. csv-table:: Table Ig. Antenna rules (S8P12-10R*/S8PIR-10R/S8PF-10R*)
   :file: antenna/table-Ig-antenna-rules-s8p12.csv
   :header-rows: 1
   :stub-columns: 1
