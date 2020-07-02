#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright 2020 SkyWater PDK Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

import os

from dataclasses import dataclass
from dataclasses_json import dataclass_json
from enum import Enum
from typing import Optional, Union, Tuple

from .utils import comparable_to_none
from .utils import dataclass_json_passthru_config as dj_pass_cfg


LibraryOrCell = Union['Library', 'Cell']


def parse_pathname(pathname):
    """Extract library and module name for pathname.

    Returns
    -------
    obj : Library or Cell
        Library or Cell information parsed from filename
    filename : str, optional
        String containing any filename extracted.
        String containing the file extension

    See Also
    --------
    skywater_pdk.base.parse_filename
    skywater_pdk.base.Cell
    skywater_pdk.base.Library

    Examples
    --------

    >>> parse_pathname('skywater-pdk/libraries/sky130_fd_sc_hd/v0.0.1/cells/a2111o')
    (Cell(name='a2111o', library=Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash=''))), None)

    >>> parse_pathname('skywater-pdk/libraries/sky130_fd_sc_hd/v0.0.1/cells/a2111o/README.rst')
    (Cell(name='a2111o', library=Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash=''))), 'README.rst')

    >>> parse_pathname('skywater-pdk/libraries/sky130_fd_sc_hd/v0.0.1')
    (Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash='')), None)

    >>> parse_pathname('skywater-pdk/libraries/sky130_fd_sc_hd/v0.0.1/README.rst')
    (Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash='')), 'README.rst')

    >>> parse_pathname('libraries/sky130_fd_sc_hd/v0.0.1')
    (Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash='')), None)

    >>> parse_pathname('libraries/sky130_fd_sc_hd/v0.0.1/README.rst')
    (Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash='')), 'README.rst')

    >>> parse_pathname('sky130_fd_sc_hd/v0.0.1')
    (Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash='')), None)

    >>> parse_pathname('sky130_fd_sc_hd/v0.0.1/README.rst')
    (Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash='')), 'README.rst')

    >>> parse_pathname('sky130_fd_sc_hd/v0.0.1/RANDOM')
    (Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash='')), 'RANDOM')

    >>> parse_pathname('RANDOM') #doctest: +ELLIPSIS
    Traceback (most recent call last):
        ...
    ValueError: ...

    >>> parse_pathname('libraries/RANDOM/v0.0.1') #doctest: +ELLIPSIS
    Traceback (most recent call last):
        ...
    ValueError: ...

    >>> parse_pathname('libraries/skywater_fd_sc_hd/vA.B.C') #doctest: +ELLIPSIS
    Traceback (most recent call last):
        ...
    ValueError: ...
    """
    if os.path.exists(pathname):
        pathname = os.path.abspath(pathname)

    pathbits = pathname.split(os.path.sep)
    # Remove any files at the end of the path
    filename = None
    if '.' in pathbits[-1]:
        if not pathbits[-1].startswith('v'):
            filename = pathbits.pop(-1)

    obj_type = None
    obj_name = None

    lib_name = None
    lib_version = None

    while len(pathbits) > 1:
        n1 = pathbits[-1]
        n2 = pathbits[-2]
        if len(pathbits) > 2:
            n3 = pathbits[-3]
        else:
            n3 = ''

        # [..., 'cells', <cellname>]
        # [..., 'models', <modname>]
        if n2 in ('cells', 'models'):
            obj_name = pathbits.pop(-1)
            obj_type = pathbits.pop(-1)
            continue
        # [..., 'skywater-pdk', 'libraries', <library name>, <library version>]
        elif n3 == "libraries":
            lib_version = pathbits.pop(-1)
            lib_name = pathbits.pop(-1)
            assert pathbits.pop(-1) == 'libraries'
        # [..., 'skywater-pdk', 'libraries', <library name>]
        elif n2 == "libraries":
            lib_name = pathbits.pop(-1)
            assert pathbits.pop(-1) == 'libraries'
        # [<library name>, <library version>]
        elif n1.startswith('v'):
            lib_version = pathbits.pop(-1)
            lib_name = pathbits.pop(-1)
        elif filename is None:
            filename = pathbits.pop(-1)
            continue
        else:
            raise ValueError('Unable to parse: {}'.format(pathname))
        break

    if not lib_name:
        raise ValueError('Unable to parse: {}'.format(pathname))
    lib = Library.parse(lib_name)
    if lib_version:
        lib.version = LibraryVersion.parse(lib_version)
    if obj_name:
        obj = Cell.parse(obj_name)
        obj.library = lib
        return obj, filename
    else:
        return lib, filename



def parse_filename(pathname) -> Tuple[LibraryOrCell, Optional[str], Optional[str]]:
    """Extract library and module name from filename.

    Returns
    -------
    obj : Library or Cell
        Library or Cell information parsed from filename
    extra : str, optional
        String containing any extra unparsed data (like corner information)
    ext : str, optional
        String containing the file extension

    See Also
    --------
    skywater_pdk.base.parse_pathname
    skywater_pdk.base.Cell
    skywater_pdk.base.Library

    Examples
    --------

    >>> t = list(parse_filename('sky130_fd_io__top_ground_padonlyv2__tt_1p80V_3p30V_3p30V_25C.wrap.lib'))
    >>> t.pop(0)
    Cell(name='top_ground_padonlyv2', library=Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.io, name='', version=None))
    >>> t.pop(0)
    'tt_1p80V_3p30V_3p30V_25C'
    >>> t.pop(0)
    'wrap.lib'
    >>> t = list(parse_filename('v0.10.0/sky130_fd_sc_hdll__a211o__tt_1p80V_3p30V_3p30V_25C.wrap.json'))
    >>> t.pop(0)
    Cell(name='a211o', library=Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hdll', version=LibraryVersion(milestone=0, major=10, minor=0, commits=0, hash='')))
    >>> t.pop(0)
    'tt_1p80V_3p30V_3p30V_25C'
    >>> t.pop(0)
    'wrap.json'

    >>> t = list(parse_filename('sky130_fd_io/v0.1.0/sky130_fd_io__top_powerhv_hvc_wpad__tt_1p80V_3p30V_100C.wrap.json'))
    >>> t.pop(0)
    Cell(name='top_powerhv_hvc_wpad', library=Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.io, name='', version=LibraryVersion(milestone=0, major=1, minor=0, commits=0, hash='')))
    >>> from skywater_pdk.corners import parse_filename as pf_corners
    >>> pf_corners(t.pop(0))
    (Corner(corner=(CornerType.t, CornerType.t), volts=(1.8, 3.3), temps=(100,), flags=None), [])
    >>> t.pop(0)
    'wrap.json'

    >>> parse_filename('libraries/sky130_fd_io/v0.2.1/cells/analog_pad/sky130_fd_io-analog_pad.blackbox.v')[0]
    Cell(name='analog_pad', library=Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.io, name='', version=LibraryVersion(milestone=0, major=2, minor=1, commits=0, hash='')))

    >>> t = list(parse_filename('skywater-pdk/libraries/sky130_fd_sc_hd/v0.0.1/cells/a2111o/sky130_fd_sc_hd__a2111o.blackbox.v'))
    >>> t.pop(0)
    Cell(name='a2111o', library=Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=LibraryVersion(milestone=0, major=0, minor=1, commits=0, hash='')))
    >>> assert t.pop(0) is None
    >>> t.pop(0)
    'blackbox.v'

    """
    dirname, filename = os.path.split(pathname)

    # Extract a version if it exists.
    dirbase, dirversion = os.path.split(dirname)
    if dirbase.endswith('cells'):
        dirbase, dirversion = os.path.split(dirbase)
        assert dirversion == 'cells', (dirbase, dirversion)
        dirbase, dirversion = os.path.split(dirbase)
    try:
        version = LibraryVersion.parse(dirversion)
    except TypeError:
        version = None

    # Extract the file extension
    if '.' in filename:
        basename, extension = filename.split('.', 1)
    else:
        basename = filename
        extension = ''

    basename = basename.replace('-', SEPERATOR) # FIXME: !!!

    # Parse the actual filename
    bits = basename.split(SEPERATOR, 3)
    if len(bits) in (1,):
        library = Library.parse(bits.pop(0))
        extra = ""
        if bits:
            extra = bits.pop(0)
        if version:
            library.version = version
    elif len(bits) in (2, 3):
        library = Cell.parse(bits[0]+SEPERATOR+bits[1])
        if version:
            library.library.version = version
        extra = None
        if len(bits) > 2:
            extra = bits[2]
    else:
        raise NotImplementedError()

    return (library, extra, extension)


SEPERATOR = "__"

@comparable_to_none
@dataclass_json
@dataclass(order=True, frozen=True)
class LibraryVersion:
    """Version number for a library.

    See Also
    --------
    skywater_pdk.base.LibraryNode
    skywater_pdk.base.LibrarySource
    skywater_pdk.base.LibraryType
    skywater_pdk.base.LibraryVersion

    Examples
    --------

    >>> v0 = LibraryVersion.parse("v0.0.0")
    >>> v0
    LibraryVersion(milestone=0, major=0, minor=0, commits=0, hash='')
    >>> v1a = LibraryVersion.parse("v0.0.0-10-g123abc")
    >>> v1a
    LibraryVersion(milestone=0, major=0, minor=0, commits=10, hash='123abc')
    >>> v1b = LibraryVersion.parse("v0.0.0-4-g123abc")
    >>> v1b
    LibraryVersion(milestone=0, major=0, minor=0, commits=4, hash='123abc')
    >>> v2 = LibraryVersion.parse("v0.0.2")
    >>> v2
    LibraryVersion(milestone=0, major=0, minor=2, commits=0, hash='')
    >>> v3 = LibraryVersion.parse("v0.2.0")
    >>> v3
    LibraryVersion(milestone=0, major=2, minor=0, commits=0, hash='')
    >>> v4 = LibraryVersion.parse("v0.0.10")
    >>> v4
    LibraryVersion(milestone=0, major=0, minor=10, commits=0, hash='')
    >>> v0 < v1a
    True
    >>> v1a < v2
    True
    >>> v0 < v2
    True
    >>> l = [v1a, v2, v3, None, v1b, v0, v2]
    >>> l.sort()
    >>> [i.fullname for i in l]
    ['0.0.0', '0.0.0-4-g123abc', '0.0.0-10-g123abc', '0.0.2', '0.0.2', '0.2.0']
    """
    milestone: int = 0
    major: int = 0
    minor: int = 0

    commits: int = 0
    hash: str = ''

    @classmethod
    def parse(cls, s):
        if not s.startswith('v'):
            raise TypeError("Unknown version: {}".format(s))
        kw = {}
        if '-' in s:
            git_bits = s.split('-')
            if len(git_bits) != 3:
                raise TypeError("Unparsable git version: {}".format(s))
            s = git_bits[0]
            kw['commits'] = int(git_bits[1])
            assert git_bits[2].startswith('g'), git_bits[2]
            kw['hash'] = git_bits[2][1:]
        kw['milestone'], kw['major'], kw['minor'] = (
            int(i) for i in s[1:].split('.'))
        return cls(**kw)

    def as_tuple(self):
        return (self.milestone, self.major, self.minor, self.commits, self.hash)

    @property
    def fullname(self):
        o = []
        s = "{}.{}.{}".format(
            self.milestone, self.major, self.minor)
        if self.commits:
            s += "-{}-g{}".format(self.commits, self.hash)
        return s


class LibraryNode(Enum):
    """Process node for a library."""

    SKY130 = "SkyWater 130nm"

    @classmethod
    def parse(cls, s):
        s = s.upper()
        if not hasattr(cls, s):
            raise ValueError("Unknown node: {}".format(s))
        return getattr(cls, s)

    def __repr__(self):
        return "LibraryNode."+self.name

    def to_json(self):
        return self.name


class LibrarySource(str):
    """Where a library was created."""
    Known = []

    @classmethod
    def parse(cls, s):
        try:
            return cls.Known[cls.Known.index(s)]
        except ValueError:
            return cls(s)

    @property
    def fullname(self):
        if self in self.Known:
            return self.__doc__
        else:
            return 'Unknown source: '+str.__repr__(self)

    def __repr__(self):
        return 'LibrarySource({})'.format(str.__repr__(self))

    def to_json(self):
        if self in self.Known:
            return self.__doc__
        return str.__repr__(self)


Foundary = LibrarySource("fd")
Foundary.__doc__ = "The SkyWater Foundary"
LibrarySource.Known.append(Foundary)

Efabless = LibrarySource("ef")
Efabless.__doc__ = "Efabless"
LibrarySource.Known.append(Efabless)

OSU = LibrarySource("osu")
OSU.__doc__ = "Oklahoma State University"
LibrarySource.Known.append(OSU)


class LibraryType(Enum):
    """Type of library contents."""

    pr = "Primitives"
    sc = "Standard Cells"
    sp = "Build Space (Flash, SRAM, etc)"
    io = "IO and Periphery"
    xx = "Miscellaneous"

    @classmethod
    def parse(cls, s):
        if not hasattr(cls, s):
            raise ValueError("Unknown library type: {}".format(s))
        return getattr(cls, s)

    def __repr__(self):
        return "LibraryType."+self.name

    def __str__(self):
        return self.value

    def to_json(self):
        return self.value


@comparable_to_none
@dataclass_json
@dataclass
class Library:
    """Library of cells.

    See Also
    --------
    skywater_pdk.base.parse_pathname
    skywater_pdk.base.parse_filename
    skywater_pdk.base.Cell
    skywater_pdk.base.LibraryNode
    skywater_pdk.base.LibrarySource
    skywater_pdk.base.LibraryType
    skywater_pdk.base.LibraryVersion

    Examples
    --------

    >>> l = Library.parse("sky130_fd_sc_hd")
    >>> l
    Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=None)
    >>> l.fullname
    'sky130_fd_sc_hd'
    >>> l.source.fullname
    'The SkyWater Foundary'
    >>> print(l.type)
    Standard Cells

    >>> l = Library.parse("sky130_rrr_sc_hd")
    >>> l
    Library(node=LibraryNode.SKY130, source=LibrarySource('rrr'), type=LibraryType.sc, name='hd', version=None)
    >>> l.fullname
    'sky130_rrr_sc_hd'
    >>> l.source.fullname
    "Unknown source: 'rrr'"

    >>> l1 = Library.parse("sky130_fd_sc_hd")
    >>> l2 = Library.parse("sky130_fd_sc_hdll")
    >>> l = [l2, None, l1]
    >>> l.sort()

    """

    node: LibraryNode = dj_pass_cfg()
    source: LibrarySource = dj_pass_cfg()
    type: LibraryType = dj_pass_cfg()
    name: str = ''
    version: Optional[LibraryVersion] = None

    @property
    def fullname(self):
        output = []
        output.append(self.node.name.lower())
        output.append(self.source.lower())
        output.append(self.type.name)
        if self.name:
            output.append(self.name)
        return "_".join(output)

    @classmethod
    def parse(cls, s):
        if SEPERATOR in s:
            raise ValueError(
                "Found separator '__' in library name: {!r}".format(s))

        bits = s.split("_")
        if len(bits) < 3:
            raise ValueError(
                "Did not find enough parts in library name: {}".format(bits))

        kw = {}
        kw['node'] = LibraryNode.parse(bits.pop(0))
        kw['source'] = LibrarySource.parse(bits.pop(0))
        kw['type'] = LibraryType.parse(bits.pop(0))
        if bits:
            kw['name'] = bits.pop(0)
        return cls(**kw)


@dataclass_json
@dataclass
class Cell:
    """Cell in a library.

    See Also
    --------
    skywater_pdk.base.parse_pathname
    skywater_pdk.base.parse_filename
    skywater_pdk.base.Library

    Examples
    --------

    >>> c = Cell.parse("sky130_fd_sc_hd__abc")
    >>> c
    Cell(name='abc', library=Library(node=LibraryNode.SKY130, source=LibrarySource('fd'), type=LibraryType.sc, name='hd', version=None))
    >>> c.fullname
    'sky130_fd_sc_hd__abc'

    >>> c = Cell.parse("abc")
    >>> c
    Cell(name='abc', library=None)
    >>> c.fullname
    Traceback (most recent call last):
        ...
    ValueError: Can't get fullname for cell without a library! Cell(name='abc', library=None)
    """

    name: str
    library: Optional[Library] = None

    @property
    def fullname(self):
        if not self.library:
            raise ValueError(
                "Can't get fullname for cell without a library! {}".format(
                    self))
        return "{}__{}".format(self.library.fullname, self.name)

    @classmethod
    def parse(cls, s):
        kw = {}
        if SEPERATOR in s:
            library, s = s.split(SEPERATOR, 1)
            kw['library'] = Library.parse(library)
        kw['name'] = s
        return cls(**kw)



if __name__ == "__main__":
    import doctest
    doctest.testmod()
