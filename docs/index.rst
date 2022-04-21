.. include:: common.inc


Welcome to SkyWater SKY130 PDK's documentation!
===============================================

.. warning::
    This documentation is currently a **work in progress**.

.. image:: _static/skywater-pdk-logo.png
    :align: center
    :alt: SkyWater PDK Logo Image.


Resources
---------

The latest SkyWater SKY130 PDK design resources can be downloaded from the following repositories:

* `On Github @ google/skywater-pdk <https://github.com/google/skywater-pdk>`_
* `Google CodeSearch interface @ https://cs.opensource.google/skywater-pdk <https://cs.opensource.google/skywater-pdk>`_
* `foss-eda-tools.googlesource.com/skywater-pdk <https://foss-eda-tools.googlesource.com/skywater-pdk/>`_


Indices and tables
------------------

* :ref:`glossary`
* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


Table of contents
-----------------

.. toctree::
    :maxdepth: -1

    versioning
    known_issues


.. toctree::
    :caption: Process Design Rules
    :name: rules
    :maxdepth: -1

    rules/background
    rules/masks
    rules/assumptions
    rules/layers
    rules/index
    rules/methodologies/index
    rules/rcx
    rules/device-details
    rules/errors


.. toctree::
    :caption: PDK Contents
    :name: pdk-contents
    :maxdepth: -1

    Libraries <contents/libraries>
    File Types <contents/file_types>


.. toctree::
    :caption: Analog Design
    :name: analog
    :maxdepth: -1

    analog/index


.. toctree::
    :caption: Digital Design
    :name: digital
    :maxdepth: -1

    With Cadence Innovus <digital/innovus>
    With OpenROAD <digital/openroad>
    With your design flow? <digital/new>


.. toctree::
    :caption: Simulation
    :name: sim
    :maxdepth: -1

    sim/index


.. toctree::
    :caption: Physical & Design Verification
    :name: verification
    :maxdepth: -1

    verification/index
    verification/drc/index
    verification/lvs/index
    verification/pex/index


.. toctree::
    :caption: Appendix
    :maxdepth: -1

    Python API <python-api/index>

    previous
    glossary

    contributing
    partners

    references
