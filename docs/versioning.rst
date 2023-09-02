.. include:: common.inc

Versioning Information
======================


.. include:: common.inc

.. _CurrentStatus:

Current Status -- |current-status|
----------------------------------

.. warning::
   Google and SkyWater are currently treating the current content as an **experimental preview** / **alpha release**.

While the SKY130 process node and the PDK from which this open source release was derived have been used to create many designs that have been successfully manufactured commercially in significant quantities, the open source PDK is not intended to be used for production settings at this current time. It *should* be usable for doing test chips and initial design verification (but this is not guaranteed).

Google, SkyWater and our partners are currently doing internal validation and test designs, including silicon validation or the released data and plan to publish these results.

The PDK will be tagged with a production version when ready to do production design, see the ":ref:`Versioning Information`" section for a full description of the version numbering scheme.

To get notified about future new releases of the PDK, and other important news, please sign up on the
`skywater-pdk-announce mailing list <https://groups.google.com/forum/#!forum/skywater-pdk-announce>`_
[`join link <https://groups.google.com/forum/#!forum/skywater-pdk-announce/join>`_].


Version Number Format
---------------------

Version numbers for both the PDK and the supplied libraries are fully specified by a 3-digit version number followed by a git commit count and a git commit short hash.

The 3-digit-number will be tagged in the associated git repository as ``vX.Y.Z`` and the fully specified value can be found by running |git-describe|_ tool inside the correct git repository.

.. |git-describe| replace:: ``git describe``
.. _git-describe: https://git-scm.com/docs/git-describe

The version number is broken down as ``vX.Y.Z-AAA-gHHHHH``;

* The letter ``v``.

* ``X`` = The "Milestone Release" Number

  * **0** indicates **"alpha"** level. The IP has **not** undergone full qualification. Parts of the IP **may be immature and untested**.

  * **1** indicates **"beta"** level. The IP has undergone qualification testing but has **not** been hardware verified.

  * **2** indicates **production** level. The IP has passed qualification testing and has been hardware verified.

* ``Y`` = The "Major Release" Number

* ``Z`` = The "Minor Release" Number

* A single hyphen character ``-``

* ``AAA`` = The `git commit count <https://git-scm.com/docs/git-describe#_examples>`_ since the version number was tagged.

* A single hyphen character followed by the letter g ``-g``

* ``HHHH`` = A `git commit short hash <https://git-scm.com/book/en/v2/Git-Tools-Revision-Selection#_short_sha_1>`_ which uniquely identifies a specific git commit inside the associated git repository.
