.. include:: common.inc

Known Issues
============

This section of the documentation provides a list of currently known issues in the currently released files.

See also the `SkyWater PDK GitHub issue list <https://github.com/google/skywater-pdk/issues>`_ to see the latest reported issues.


.. include:: status.rst
    :start-after: current_status_text


Documentation
-------------

A number of sections in the documentation still have pending TODO items. These will be fixed over the coming months.

The current cell datasheets only include basic information about the cell. These datasheets will be continuously updated with new information as the generator is improved.

PDK Contents Issues
-------------------

Tooling Compatibility
~~~~~~~~~~~~~~~~~~~~~

Cadence Virtuoso Support
************************

The first publication of this is missing files required for optimal Cadence Virtuoso usage. These files will be released publicly at a future date after further work (see `Issue #1 <https://github.com/google/skywater-pdk/issues/1>`_).

These files are;

* OpenAccess versions of the cells
* Cadence PCells, including

  - Parameterized primitives including FETs, Capacitors, Resistors, Inductors, etc
  - Seal Ring

* Cadence SKILL scripts that support Virtuoso functions such as netlisting

Before these files are released access to the manually created previous version of these files is available through SkyWater directly under NDA.

Mentor Calibre Support
**********************

The first publication of this PDK is missing files required to do design verification with Mentor Calibre. Scripts for generating these files from the published documentation will be released at a future date  (see `Issue #2 <https://github.com/google/skywater-pdk/issues/2>`_).

This includes;

* Physical checking of design rules
* Logic vs schematic checks
* Latchup and soft design rules
* Fill structure generator

Before the scripts are released which generated the needed files for Mentor Calibre from the release documentation, manually created files which provide similar functionality are available from SkyWater directly under NDA.

Specific Libraries
------------------

:lib:`sky130_fd_pr_base`
~~~~~~~~~~~~~~~~~~~~~~~~

See `Cadence Virtuoso Support`_ section.

:lib:`sky130_fd_pr_rf`
~~~~~~~~~~~~~~~~~~~~~~

The :lib:`sky130_fd_pr_rf` library is provided for references purposes only, all new designs should be based on the :lib:`sky130_fd_pr_rf2` library.

See `Cadence Virtuoso Support`_ section.

:lib:`sky130_fd_pr_rf2`
~~~~~~~~~~~~~~~~~~~~~~~

See `Cadence Virtuoso Support`_ section.


:lib:`sky130_osu_sc` - SKY130 Oklahoma State University provided standard cell library
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The SKY130 Oklahoma State University provided standard cells library is currently empty, only a placeholder is currently provided.

The SKY130 Oklahoma State University provided standard cells library will be integrated at a future date (see `Issue #10 <https://github.com/google/skywater-pdk/issues/10>`_).

:lib:`sky130_fd_sp_flash` - SKY130 Flash Build Space
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The flash build space is currently empty, only a placeholder is currently provided.

The components of the SRAM build space compatible with OpenRAM will be released at a future date (see `Issue #4 <https://github.com/google/skywater-pdk/issues/4>`_).


:lib:`sky130_fd_sp_sram` - SKY130 SRAM Build Space
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The flash build space is currently empty, only a placeholder is currently provided.

The components of SRAM build space will be released at a future date (see `Issue #3 <https://github.com/google/skywater-pdk/issues/3>`_).

:lib:`sky130_fd_io` - SKY130 Foundry Provided IO Cells
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The IO cell library is currently empty, only a placeholder is currently provided.

The IO cell library will be released at a future date (see `Issue #5 <https://github.com/google/skywater-pdk/issues/5>`_).

:lib:`sky130_ef_io` - SKY130 eFabless Provided IO Cells
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The IO cell library is currently empty, only a placeholder is currently provided.

The IO cell library will be released at a future date (see `Issue #9 <https://github.com/google/skywater-pdk/issues/9>`_).

Design Rule Checking
--------------------

Using Mentor Calibre
~~~~~~~~~~~~~~~~~~~~

See `Mentor Calibre Support`_ section.

At the moment, if you are required to use Calibre as part of your design flow, it is recommended that you also use the open source tool Magic to check for errors and fix any issues reported.

Using Magic
~~~~~~~~~~~

Currently Magic does not have DRC checking rules for checking the specialized exceptions for SRAM cells in the :lib:`sky130_fd_sp_sram` SKY130 SRAM Build Space. These will be released at around the same time as the SKY130 SRAM Build Space.


Scripts and PDK Tooling
-----------------------

A number of scripts are used to generate various files in the PDK including many of the liberty, spice files, schematic images, and much more.

These scripts will be published inside the PDK at a future date (see `Issue list <https://github.com/google/skywater-pdk/issues?q=is%3Aopen+is%3Aissue+label%3Atype-todo+label%3Ascripts-python>`_).

