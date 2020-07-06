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

import re
import os

from enum import Flag
from dataclasses import dataclass
from dataclasses_json import dataclass_json
from typing import Tuple, Optional

from . import base
from .utils import OrderedFlag
from .utils import comparable_to_none
from .utils import dataclass_json_passthru_sequence_config as dj_pass_cfg


CornerTypeMappings = {}
# "wo" is "worst-case one" and corresponds to "fs"
CornerTypeMappings["wo"] = "fs"
# "wz" is "worst-case zero" and corresponds to "sf"
CornerTypeMappings["wz"] = "sf"
# "wp" is "worst-case power" and corresponds to "ff"
CornerTypeMappings["wp"] = "ff"
# "ws" is "worst-case speed" and corresponds to "ss"
CornerTypeMappings["ws"] = "ss"

CornerTypeValues = [
    'ff',
    'ss',
    'tt',
    'fs',
    'sf',
]
CORNER_TYPE_REGEX = re.compile('[tfs][tfs]')


class CornerType(OrderedFlag):
    """

    See Also
    --------
    skywater_pdk.corners.Corner
    skywater_pdk.corners.CornerFlag

    Examples
    --------

    >>> CornerType.parse('t')
    CornerType.t
    >>> CornerType.parse('tt')
    [CornerType.t, CornerType.t]
    >>> CornerType.parse('wp')
    [CornerType.f, CornerType.f]
    """
    t = 'Typical'  # all  nominal (typical) values
    f = 'Fast'     # fast, that is, values that make transistors run faster
    s = 'Slow'     # slow

    @classmethod
    def parse(cls, s):
        if s in CornerTypeMappings:
            return cls.parse(CornerTypeMappings[s])
        if len(s) > 1:
            try:
                o = []
                for c in s:
                    o.append(cls.parse(c))
                return o
            except TypeError:
                raise TypeError("Unknown corner type: {}".format(s))
        if not hasattr(cls, s):
            raise TypeError("Unknown corner type: {}".format(s))
        return getattr(cls, s)

    def __repr__(self):
        return 'CornerType.'+self.name

    def __str__(self):
        return self.value

    def to_json(self):
        return self.name


class CornerFlag(OrderedFlag):
    """

    See Also
    --------
    skywater_pdk.corners.Corner
    skywater_pdk.corners.CornerType
    """

    nointpr = 'No internal power'
    lv = 'Low voltage'
    hv = 'High voltage'
    lowhv = 'Low High Voltage'
    ccsnoise = 'Composite Current Source Noise'
    pwr = 'Power'
    xx = 'xx'
    w = 'w'

    @classmethod
    def parse(cls, s):
        if hasattr(cls, s):
            return getattr(cls, s)
        else:
            raise TypeError("Unknown CornerFlags: {}".format(s))

    def __repr__(self):
        return 'CornerFlag.'+self.name

    def __str__(self):
        return self.value

    def to_json(self):
        return self.name


@comparable_to_none
class OptionalTuple(tuple):
    pass


@comparable_to_none
@dataclass_json
@dataclass(frozen=True, order=True)
class Corner:
    """

    See Also
    --------
    skywater_pdk.corners.parse_filename
    skywater_pdk.base.Cell
    skywater_pdk.corners.CornerType
    skywater_pdk.corners.CornerFlag

    """
    corner: Tuple[CornerType, CornerType] = dj_pass_cfg()
    volts: Tuple[float, ...] = dj_pass_cfg()
    temps: Tuple[int, ...] = dj_pass_cfg()
    flags: Optional[Tuple[CornerFlag, ...]] = dj_pass_cfg(default=None)

    def __post_init__(self):
        if self.flags:
            object.__setattr__(self, 'flags', OptionalTuple(self.flags))


VOLTS_REGEX = re.compile('([0-9]p[0-9]+)V')
TEMP_REGEX = re.compile('(n?)([0-9][0-9]+)C')
def parse_filename(pathname):
    """Extract corner information from a filename.

    See Also
    --------
    skywater_pdk.base.parse_pathname
    skywater_pdk.base.parse_filehname

    Examples
    --------

    >>> parse_filename('tt_1p80V_3p30V_3p30V_25C')
    (Corner(corner=(CornerType.t, CornerType.t), volts=(1.8, 3.3, 3.3), temps=(25,), flags=None), [])

    >>> parse_filename('sky130_fd_io__top_ground_padonlyv2__tt_1p80V_3p30V_3p30V_25C.wrap.lib')
    (Corner(corner=(CornerType.t, CornerType.t), volts=(1.8, 3.3, 3.3), temps=(25,), flags=None), [])

    >>> parse_filename('sky130_fd_sc_ms__tt_1p80V_100C.wrap.json')
    (Corner(corner=(CornerType.t, CornerType.t), volts=(1.8,), temps=(100,), flags=None), [])

    >>> parse_filename('sky130_fd_sc_ms__tt_1p80V_100C.wrap.lib')
    (Corner(corner=(CornerType.t, CornerType.t), volts=(1.8,), temps=(100,), flags=None), [])

    >>> parse_filename('sky130_fd_sc_ms__tt_1p80V_25C_ccsnoise.wrap.json')
    (Corner(corner=(CornerType.t, CornerType.t), volts=(1.8,), temps=(25,), flags=(CornerFlag.ccsnoise,)), [])

    >>> parse_filename('sky130_fd_sc_ms__wp_1p65V_n40C.wrap.json')
    (Corner(corner=(CornerType.f, CornerType.f), volts=(1.65,), temps=(-40,), flags=None), [])

    >>> parse_filename('sky130_fd_sc_ms__wp_1p95V_85C_pwr.wrap.lib')
    (Corner(corner=(CornerType.f, CornerType.f), volts=(1.95,), temps=(85,), flags=(CornerFlag.pwr,)), [])

    >>> parse_filename('sky130_fd_sc_ms__wp_1p95V_n40C_ccsnoise.wrap.json')
    (Corner(corner=(CornerType.f, CornerType.f), volts=(1.95,), temps=(-40,), flags=(CornerFlag.ccsnoise,)), [])

    >>> parse_filename('sky130_fd_sc_ms__wp_1p95V_n40C_pwr.wrap.lib')
    (Corner(corner=(CornerType.f, CornerType.f), volts=(1.95,), temps=(-40,), flags=(CornerFlag.pwr,)), [])

    >>> parse_filename('sky130_fd_sc_hd__a2111o_4__ss_1p76V_n40C.cell.json')
    (Corner(corner=(CornerType.s, CornerType.s), volts=(1.76,), temps=(-40,), flags=None), [])

    >>> parse_filename('sky130_fd_sc_ls__lpflow_lsbuf_lh_1__lpflow_wc_lh_level_shifters_ss_1p95V_n40C.cell.json')
    (Corner(corner=(CornerType.s, CornerType.s), volts=(1.95,), temps=(-40,), flags=None), ['wc', 'lh', 'level', 'shifters'])

    >>> parse_filename('sky130_fd_sc_hvl__lsbufhv2hv_hl_1__ff_5p50V_lowhv_1p65V_lv_ss_1p60V_100C.cell.json')
    (Corner(corner=(CornerType.f, CornerType.s), volts=(5.5, 1.65, 1.6), temps=(100,), flags=(CornerFlag.lowhv, CornerFlag.lv)), [])

    """
    if base.SEPERATOR in pathname:
        cell, extra, extension = base.parse_filename(pathname)
    else:
        cell = None
        extra = pathname
        extension = ''

    if extension not in ('', 'lib', 'cell.lib', 'cell.json', 'wrap.lib', 'wrap.json'):
        raise ValueError('Not possible to extract corners from: {!r}'.format(extension))

    if not extra:
        extra = cell.name
        cell = None

    # FIXME: Hack?
    extra = extra.replace("lpflow_","")
    extra = extra.replace("udb_","")

    kw = {}
    kw['flags'] = []
    kw['volts'] = []
    kw['temps'] = []

    bits = extra.split("_")
    random = []
    while len(bits) > 0:
        b = bits.pop(0)
        try:
            kw['corner'] = CornerType.parse(b)
            break
        except TypeError as e:
            random.append(b)

    while len(bits) > 0:
        b = bits.pop(0)

        if VOLTS_REGEX.match(b):
            assert b.endswith('V'), b
            kw['volts'].append(float(b[:-1].replace('p', '.')))
        elif TEMP_REGEX.match(b):
            assert b.endswith('C'), b
            kw['temps'].append(int(b[:-1].replace('n', '-')))
        elif CORNER_TYPE_REGEX.match(b):
            # FIXME: These are horrible hacks that should be removed.
            assert len(b) == 2, b
            assert b[0] == b[1], b
            assert 'corner' in kw, kw['corners']
            assert len(kw['corner']) == 2, kw['corners']
            assert kw['corner'][0] == kw['corner'][1], kw['corners']
            other_corner = CornerType.parse(b)
            assert len(other_corner) == 2, other_corner
            assert other_corner[0] == other_corner[1], other_corner
            kw['corner'][1] = other_corner[0]
        else:
            kw['flags'].append(CornerFlag.parse(b))

    for k, v in kw.items():
        kw[k] = tuple(v)

    if not kw['flags']:
        del kw['flags']

    if 'corner' not in kw:
        raise TypeError('Invalid corner value: '+extra)

    return Corner(**kw), random



# 1p60V 5p50V n40C




if __name__ == "__main__":
    import doctest
    doctest.testmod()
