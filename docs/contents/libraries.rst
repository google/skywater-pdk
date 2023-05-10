Libraries
=========

Library Naming
--------------

Libraries in the SKY130 PDK are named using the following scheme;

  :lib_process:`<Process name>` _ :lib_src:`<Library Source Abbreviation>` _ :lib_type:`<Library Type Abbreviation>` [_ :lib_name:`<Library Name>`]

All sections are **lower case** and separated by an **underscore**. The sections are;


- The :lib_process:`Process name` in is the name of the process technology, for this PDK it is always :lib_process:`sky130`.

- The :lib_src:`Library Source Abbreviations` is a short abbreviation for who created and is responsible for the library. The table below shows the current list of :lib_src:`Library Source Abbreviations`;

  +----------------------------+----------------------------------------+
  | Library Source             | :lib_src:`Library Source Abbreviation` |
  +============================+========================================+
  | The SkyWater Foundry       | :lib_src:`fd`                          |
  +----------------------------+----------------------------------------+
  | Efabless                   | :lib_src:`ef`                          |
  +----------------------------+----------------------------------------+
  | Oklahoma State University  | :lib_src:`osu`                         |
  +----------------------------+----------------------------------------+

- The :lib_type:`Library Type Abbreviation` is a short two letter abbreviation for the type of content found in the library. The table below shows the current list of :lib_type:`Library Type Abbreviations`;

  +--------------------------------+---------------------------------------+
  | Library Type                   | :lib_type:`Library Type Abbreviation` |
  +================================+=======================================+
  | Primitive Cells                | :lib_type:`pr`                        |
  +--------------------------------+---------------------------------------+
  | Digital Standard Cells         | :lib_type:`sc`                        |
  +--------------------------------+---------------------------------------+
  | Build Space (Flash, SRAM, etc) | :lib_type:`bd`                        |
  +--------------------------------+---------------------------------------+
  | IO and Periphery               | :lib_type:`io`                        |
  +--------------------------------+---------------------------------------+
  | Miscellaneous                  | :lib_type:`xx`                        |
  +--------------------------------+---------------------------------------+

- The :lib_name:`Library Name` is an optional short abbreviated name used when there are multiple libraries of a given type released from a single :lib_src:`library source`. If only one library of a given type is going to ever be released, this can be left out.

Creating New Libraries
----------------------

Third party developers are encourage to create new and interesting libraries for usage with the SKY130 process technology. These libraries can even be included in the SKY130 PDK if it meets the following criteria;

 - It is released under an OSI approved license.
 - TODO: Finish the criteria.


.. _sky130-lib-primitives:

:lib_type:`Primitive` Libraries
-------------------------------

.. _sky130-lib-primitives-foundry:

:lib_src:`Foundry` provided
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. toctree::
    :glob:
    :maxdepth: 1
    :caption: Foundry provided Primitives
    :name: sky130-lib-foundry-primitives

    libraries/sky130_fd_pr_*/README

.. _sky130-lib-standardcells:

:lib_type:`Digital Standard Cell` Libraries
-------------------------------------------

.. _sky130-lib-standardcells-foundry:

:lib_src:`Foundry` provided :lib_type:`Digital Standard Cell` Libraries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. toctree::
    :glob:
    :maxdepth: 1
    :name: sky130-lib-foundry-sc

    libraries/foundry-provided
    libraries/sky130_fd_sc_*/README

.. _sky130-lib-standardcells-thirdparty:

:lib_src:`Third party` provided :lib_type:`Digital Standard Cell` Libraries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. toctree::
    :maxdepth: 1
    :name: sky130-lib-thirdparty-sc

    libraries/sky130_osu_sc/README

.. _sky130-lib-buildspace:

:lib_type:`Build Space` Libraries
---------------------------------

The SKY130 currently offers two :lib_type:`build space` libraries. Build space libraries are designed to be used with technologies like memory compilers and built into larger macros. The provided libraries have specially crafted design rules to enable higher density compared to other libraries.

.. _sky130-lib-buildspace-foundry:

:lib_src:`Foundry` provided :lib_type:`Build Space` Libraries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. toctree::
    :glob:
    :maxdepth: 1
    :caption: Foundry provided Build Spaces
    :name: sky130-lib-foundry-sp

    libraries/sky130_fd_sp_*/README

.. _sky130-lib-io:

:lib_type:`IO and Periphery` Libraries
--------------------------------------

.. _sky130-lib-io-foundry:

:lib_src:`Foundry` provided :lib_type:`IO and Periphery` Libraries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. toctree::
    :maxdepth: 1
    :name: sky130-lib-foundry-io

    libraries/sky130_fd_io/README

.. _sky130-lib-io-thirdparty:

:lib_src:`Third party` provided :lib_type:`IO and Periphery` Libraries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. toctree::
    :maxdepth: 1
    :name: sky130-lib-thirdparty-io

    libraries/sky130_ef_io/README

.. toctree::
    :maxdepth: 1
    :name: Cells in libraries cross-index

    cell-index
