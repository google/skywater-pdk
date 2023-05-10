Explanation of symbols:

* ``-`` = Layer illegal for the device
* ``+`` = Layer allowed to overlap
* ``D`` = DRAWN indicates that a layer is drawn by Design.
* ``C`` = CREATED indicates that the layer is only created by CAD.

.. rubric:: Footnotes

.. [#f1] Low vt needs to be set on the schematic element
.. [#f2] Ncm is drawn inside core. Otherwise it is created in periphery. See rules ncm.X.* for details
.. [#f3] Drawn over half of device
.. [#f4] ASSUMPTION: FET models will be same regardless of backend flow
.. [#f5] The 2 core FETs and flash npass must have a poly.ml label with their model name.
.. [#f6] over the drain
.. [#f7] over the source
.. [#f8] Information for RCX
.. [#f9] Uses a black box for LVS. This is a fixed layout; Use symbol provided by modeling group
.. [#f10] LVS will check that phighvt inside areaid.ce overlaps ncm
.. [#f11] The default model is sonos_e, sonos_de and nvssonos_e. If sonos_p, sonos_dp and nvssonos_p model are required, poly.ml must be used
.. [#f12] The capacitor.dg is drawn 0.17um from the edge of the cell to be LVS clean
.. [#f13] Devices are LVS'ed by cell name, m=1 per cell, fixed area and perimeter (see QHC-18)
.. [#f14] (dnwell not (pwres or pnp or npn or areaid.en or areaid.de or areaid.po)) not nwell must have condiode text; Refer to VUN-104, 192 for condiode usage
.. [#f15] Tech element is created by the user, no CAD supplied tech element
.. [#f16] There are multiple configurations of the Cu inductor. The layers present in one configuration may not be drawn in the other configuration. Also rdl will not be routed over met5 cu inductor, not checkable by CAD flow.
.. [#f17] Used for substrate noise isolation regions only
.. [#f18] Either UHVI or areaid.low_vt should be drawn over the sturctures
.. [#f19] Psub-Deep Nwell Diode must have condiode text "condiodeHvPsub"; CVA-596
.. [#f20] mrp1 can't overlay capacitor.dg: exempted s8rf2_xcmvpp11p5x11p7_lim5shield from the rule
