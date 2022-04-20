.. include:: common.inc


.. toctree::
    :hidden:

    versioning
    Current Status <status>
    known_issues


.. toctree::
    :caption: Process Design Rules
    :name: rules
    :maxdepth: 2
    :hidden:

    rules/background
    rules/masks

    rules/assumptions

    rules/layers

    rules/summary

    rules/periphery
    rules/wlcsp
    rules/hv

    rules/antenna

    rules/rcx

    rules/device-details

    rules/errors


.. toctree::
    :caption: PDK Contents
    :name: pdk-contents
    :maxdepth: 4
    :hidden:

    Libraries <contents/libraries>
    File Types <contents/file_types>


.. toctree::
    :caption: Analog Design
    :name: analog
    :hidden:

    With Cadence Virtuoso <analog/virtuoso>
    With MAGIC <analog/magic>
    With Klayout <analog/klayout>
    With Berkeley Analog Generator (BAG) <analog/bag>
    With FASoC <analog/fasoc>
    With your design flow? <analog/new>


.. toctree::
    :caption: Digital Design
    :name: digital
    :hidden:

    With Cadence Innovus <digital/innovus>
    With OpenROAD <digital/openroad>
    With your design flow? <digital/new>


.. toctree::
    :caption: Simulation
    :name: sim
    :hidden:

    sim/index
    With Cadence Spectre <sim/spectre>
    With ngspice <sim/ngspice>
    With your design flow? <analog/new>


.. toctree::
    :caption: Physical & Design Verification
    :name: verification
    :hidden:

    verification/index
    Automated Design Rule (DRC) Checking <verification/drc>
    - With Mentor Calibre
    - With MAGIC
    - With Klayout
    Layout Versus Schematic (LVS) Checking <verification/lvs>
    - With Mentor Calibre
    - With netgen
    Parasitic Extraction (PEX) <verification/pex>
    - With Calibre xRC
    - With MAGIC


.. toctree::
    :hidden:

    Python API <python-api/index>

    previous
    glossary

    contributing
    partners

    references


Welcome to SkyWater SKY130 PDK's documentation!
===============================================

.. warning::
    This documentation is currently a **work in progress**.

.. image:: _static/skywater-pdk-logo.png
    :align: center
    :alt: SkyWater PDK Logo Image.


.. _CurrentStatus:

Current Status - |current-status|
=================================

.. include:: status.rst
    :start-after: current_status_text


Resources
=========

The latest SkyWater SKY130 PDK design resources can be downloaded from the following repositories:

* `On Github @ google/skywater-pdk <https://github.com/google/skywater-pdk>`_
* `Google CodeSearch interface @ https://cs.opensource.google/skywater-pdk <https://cs.opensource.google/skywater-pdk>`_
* `foss-eda-tools.googlesource.com/skywater-pdk <https://foss-eda-tools.googlesource.com/skywater-pdk/>`_


Indices and tables
==================

* :ref:`glossary`
* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
