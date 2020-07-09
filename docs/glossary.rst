Glossary
========

.. Companies

.. glossary::

    SkyWater
    SkyWater Technology
      `SkyWater Technology <https://www.SkyWatertechnology.com/>`_

    Cypress
    Cypress Technologies
      `Cypress Technologies <http://cypress.com/>`_

    Linear ASICs
      `Linear ASICs <https://linearasics.com/>`_

    Mentor
    Mentor Graphics
      `Mentor, a Siemens Business is a US-based electronic design automation (EDA) multinational corporation for electrical engineering and electronics. <https://en.wikipedia.org/wiki/Mentor_Graphics>`

    OSU
       Oklahoma State University

.. Acronyms

.. glossary::

    sc
    Standard Cell
        The basic building blocks of digital circuit design.

    ce
        Memory Core

    DRC
    Design Rule Check
    Design Rule Checking
       Design rule checking or check(s) is the process of determing whether the
       physical layout of a particular chip layout satisfies a series of
       required parameters called design rules.

    LVS
    Layout Verse Schematic
       Layout Versus Schematic (LVS) verification is the process of determining
       whether a particular integrated circuit layout corresponds to the
       original :ref:`schematic` or :ref:`circuit diagram` of the design.

    PEX
    Parasitic Extraction
       Parasitic extraction is calculation of the parasitic effects in both the
       designed devices and the required wiring interconnects of an electronic
       circuit. This includes all parasitic components (often called parasitic
       devices) including parasitic;

        * capacitances,
        * resistances, and
        * inductances.

    NLDM
      Non-Linear Delay Model

    CCS
    ECSM
      Current Source Models


    CIF
    Caltech Intermediate Form
        From the 1990's, the CIF format has largely been replaced by the GDS
        format.
    MiM
    MIM
    MiM caps
        Stands for "metal-insulator-metal" and is a type of IC capacitor
        structure.

        These are capacitors that are made between two metal route layers,
        usually close to the top of the metal stack.

        Generally they are around 1fF/um^2, a lot better than MoM caps.

        The capacitance of MiM caps is on the top and bottom of the metal
        (while the capacitance of MoM caps is sidewall cap).

    MoM
    MoM caps
    VPP
    VPP capacitor
        Stands for "metal-oxide-metal" and is a type of IC capacitor structure.

        These are capacitors which are made by interleaving fingers of metal.

        Sometimes MoM caps are referred to as "VPP" capacitors (stands for
        "vertical parallel plate").

        The capacitance of MoM caps is capacitance of the metal sidewalls which
        is significantly lower than that provided MiM caps.



.. File formats

.. glossary::

    .lef
    LEF
    Library Exchange Format
      Abstract description of the layout for place and route.

    .lib
    Liberty Models
    Liberty Timing Models
    Liberty Wire Load Models
      Liberty Files are a IEEE Standard for defining: PVT Characterization,
      Relating Input and Output Characteristics, Timing, Power, Noise.

      Wire Load Models estimate the parasitics based on the fanout of a net.

    CALMA
    Calma
    Calma Format
      Calma was the company behind the development of GDS. 
      https://en.wikipedia.org/wiki/Calma


.. Tools

.. glossary::

    Mentor Calibre
      The Calibre® product suite developed by :term:`Mentor Graphics`. Heavily
      used for IC Verification and Signoff.

    MAGIC
      `MAGIC <http://opencircuitdesign.com/magic/>`_

    ngspice
      `ngspice <http://ngspice.sourceforge.net/>`_

    OpenRoad
      The digital design flow developed by
      `The OpenRoad Project <https://theopenroadproject.org/>`_


.. Terms specific to this documentation

.. glossary::

    s8phirs_10r
    SkyWater S8
    SkyWater SKY130 technology
    SkyWater SKY130 process
      The SkyWater SKY130 130nm process with 5 metal layers.

    s8_osu130
      The Oklahoma State University Digital Standard Cells.

    s8_schd
      The SkyWater High Density Digital Standard Cells.

    license
    Apache 2.0 license
      The Apache 2.0 license.
