SONOS cells
-----------

The SKY130 process currently supports two SONOS flash memory cells:

-  The original cell is supported in the S8PFHD, S8PHRC and S8PFN-20 technology options, with operating temperatures from -55°C to +155°C
-  The “star” cell is supported in the S8PHIRS technology option. Its cell size is approximately 25% smaller than the original cell, but its temperature range is restricted to -40°C to +125°C.

Spice models for the memory cells exist for multiple conditions:


.. include:: special_sonosfet-table0.rst



Program and Erase characteristics are described in more detail in the ***S8 Nonvolatile Technology Spec*** (001-08712), and summarized below:


.. include:: special_sonosfet-table1.rst



Endurance behavior is illustrated below (100K cycles guaranteed):

|sonos-erase-program|

Data retention behavior is shown below at 85C\ |sonos-data-retention|

E-test parameters are summarized below for both original and star cells:


.. include:: special_sonosfet-table2.rst



The schematic for the 2-T SONOS memory cell is shown below:

|schematic-sonos-cell|

The cross-section of the 2-T SONOS cell is shown below.

|cross-section-sonos-cell|

.. |sonos-erase-program| image:: sonos-erase-program.svg
.. |sonos-data-retention| image:: sonos-data-retention.svg
.. |schematic-sonos-cell| image:: schematic-sonos-cell.svg
.. |cross-section-sonos-cell| image:: cross-section-sonos-cell.svg

