.. include:: common.inc

Versioning Information
======================

Current Status
--------------

.. include:: status.rst
    :start-after: current_status_text

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
