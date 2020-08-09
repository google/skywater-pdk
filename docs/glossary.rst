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
      `Mentor, a Siemens Business <https://en.wikipedia.org/wiki/Mentor_Graphics>`_
      is a US-based electronic design automation (EDA) multinational
      corporation for electrical engineering and electronics. 

    OSU
       Oklahoma State University
       
    VSD
    VLSI System Design
      `VLSI System Design <https://www.vlsisystemdesign.com/>`_

.. Acronyms

.. glossary::
    sc
    Standard Cell
        The basic building blocks of digital circuit design.

    ce
        Memory Core

    Antenna Rule Violations
        During manufacturing, a static charge can build up on the currently-
        topmost metal layer, and destroy the chip if there is no path to the
        substrate for this charge to bleed off during layer deposition. The
        Antenna Rule ensures that each metal layer has a route to diffusion.
    
    CIF
    Caltech Intermediate Form
        From the 1990's, the CIF format has largely been replaced by the GDS
        format.
        
    CCS
    ECSM
       Current Source Models

    DRC
    Design Rule Check
    Design Rule Checking
       Design rule checking or check(s) is the process of determing whether the
       physical layout of a particular chip layout satisfies a series of
       required parameters called design rules.

    ESD
    Electro-Static Discharge (protection from)
       Circuit elements, especially on I/O pins, intended to protect the circuit
       from the effects of `electrostatic discharge <https://en.wikipedia.org/wiki/Electrostatic_discharge/>`_.

    LVS
    Layout Verse Schematic
       Layout Versus Schematic (LVS) verification is the process of determining
       whether a particular integrated circuit layout corresponds to the
       original :ref:`schematic` or :ref:`circuit diagram` of the design.

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
    
    NLDM
      Non-Linear Delay Model

    OPHW
    OPen HardWare
       The movement to produce inspectable and modifiable computer hardware
       designs.
    
    PEX
    Parasitic Extraction
       Parasitic extraction is calculation of the parasitic effects in both the
       designed devices and the required wiring interconnects of an electronic
       circuit. This includes all parasitic components (often called parasitic
       devices) including parasitic;

        * capacitances,
        * resistances, and
        * inductances.

    PNR
    Place aNd Route
       The process of laying out the standard design cells on the 2D plane of the
       chip and connecting their corresponding inputs and outputs. Theoretically
       equivalent to the "Travelling Salesman Problem," and therefore the subject
       of much research.
    
    STA
    Static Timing Analysis
       Analysing the timing of a circuit from some level of the design. Contrast
       with performing the timing analysis on actual hardware.

    RTL
    Register Transfer Language
       A source code format that describes the transitions that hardware
       registers take at the register transfer level, such as Verilog or VHDL.

    VLSI
    Very Large Scale Integration
       Producing an integrated circuit in the million+ transistor scale, with
       multiple functions on the same chip (such as compute, memory, ROM, and
       power regulation).


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
      
    qflow
      `qflow <http://opencircuitdesign.com/qflow/>`_
      Named after Steve Beccue of MultiGIG.
      
    yosys
      `Yosys Open SYnthesis Suite <http://www.clifford.at/yosys/>`_


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
