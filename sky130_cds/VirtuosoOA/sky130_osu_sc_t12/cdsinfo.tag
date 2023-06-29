#
# This is a cdsinfo.tag file.
#
# See the "Cadence Application Infrastructure Reference Manual" for
# details on the format of this file, its semantics, and its use.
#
# The `#' character denotes a comment. Removing the leading `#'
# character from any of the entries below will activate them.
#
# CDSLIBRARY entry - add this entry if the directory containing
# this cdsinfo.tag file is the root of a Cadence library.
# CDSLIBRARY
#
# CDSLIBCHECK - set this entry to require that libraries have
# a cdsinfo.tag file with a CDSLIBRARY entry. Legal values are
# ON and OFF. By default (OFF), directories named in a cds.lib file
# do not have to have a cdsinfo.tag file with a CDSLIBRARY entry.
# CDSLIBCHECK ON
#
# DMTYPE - set this entry to define the DM system for Cadence's
# Generic DM facility. Values will be shifted to lower case.
# DMTYPE none
# DMTYPE crcs
# DMTYPE tdm
# DMTYPE sync
#
# NAMESPACE - set this entry to define the library namespace according
# to the type of machine on which the data is stored. Legal values are
# `LibraryNT' and
# `LibraryUnix'.
# NAMESPACE LibraryUnix
#
# Other entries may be added for use by specific applications as
# name-value pairs. Application documentation will describe the
# use and behaviour of these entries when appropriate.
#
# Current Settings:
#
CDSLIBRARY
DMTYPE none
NAMESPACE LibraryUnix
