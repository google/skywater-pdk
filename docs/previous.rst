Previous Nomenclature
=====================

During the process of preparing the SkyWater SKY130 PDK for public release, consistency around naming, documentation and data cross checking was performed. This attempted to make sure that all references have been updated but despite the SkyWater PDK Author's best efforts, some references may have been missed.

This section of the document include information about previous nomenclature around both the SkyWater PDK, related process and technologies developed both by Cypress Technology, SkyWater Technology and their partners.

.. note::
    If you find any references to these terms inside the current documentation,
    please create an issue so we can update the documentation!

This section should also help people who have previously had access (under NDA) to Cypress and SkyWater PDK files or older documentation and want to migrate to this new open source PDK.

.. warning::
    Despite this repository being released under an open source license, you
    should **not** publish publically any Cypress or SkyWater IP you have been
    given access to under NDA.

    If the IP you are looking at includes references to terms found in this
    Previous Nomenclature section, it is a good indication that the IP you have
    can only be shared under appropriate NDAs and clearances you should **not**
    be publically publishing it.


.. glossary::

    :lib_process:`s8`
        The old Cypress and SkyWater name for the :lib_process:`SKY130`
        process. It stood for the "8th generation" of the SONOS technology
        developed originally by Cypress.

    :lib_process:`s180`
        The name for using 180nm technology on the 130nm process.

    :lib_process:`s8pfhd`
        The base process.  5 metal layer backend stack, 16V devices, deep
        nwell.

    :lib_process:`s8phirs`
        The base process plus rdl layer and rdl metal inductors.

    :lib_process:`s8phrc`
        The base process plus dual MiM cap layers on metal 3 and metal 4

    :lib_process:`s8pfn-20`
        The base process plus UHV (ultra-high voltage) implants for 20V device
        support.


    :lib_name:`s8iom0s8`
        An earlier name for the :lib:`sky130_fd_io` library.

    :lib_name:`scs8hd`
        An earlier name for the :lib:`sky130_fd_sc_hd` library.

