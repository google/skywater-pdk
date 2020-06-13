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

import abc
import os
import operator

from dataclasses import dataclass
from dataclasses_json import dataclass_json


def parse_size(s):
    """

    >>> parse_size('_1')
    CellSizeNumeric(units=1)

    >>> parse_size('a2111o_1')
    CellSizeNumeric(units=1)

    >>> parse_size('sky130_fd_sc_ms__sdfrtp_1.v')
    CellSizeNumeric(units=1)

    >>> parse_size('libraries/sky130_fd_sc_ms/v0.0.1/cells/sdfrtp/sky130_fd_sc_ms__sdfrtp_1.v')
    CellSizeNumeric(units=1)

    >>> parse_size('libraries/sky130_fd_sc_ms/v0.0.1/cells/sdfrtp/sky130_fd_sc_ms__sdfrtp_1.bb.blackbox.v')
    CellSizeNumeric(units=1)

    >>> parse_size('libraries/sky130_fd_sc_ms/v0.0.1/cells/sdfrtp/sky130_fd_sc_ms__sdfrtp.v')
    >>> parse_size('sky130_fd_sc_ms__sdfrtp.v')
    >>> parse_size('_blah')
    """
    dirname, s = os.path.split(s)
    if '.' in s:
        s = s.split('.', 1)[0]
    if s.count('_') > 0:
        s = '_' + (s.rsplit('_', 1)[-1])
    if not s or s == '_':
        return None
    try:
        return CellSize.from_suffix(s)
    except InvalidSuffixError as e:
        return None


class InvalidSuffixError(ValueError):
    def __init__(self, s):
        ValueError.__init__(self, "Invalid suffix: {}".format(s.strip()))


class CellSize(abc.ABC):
    """Drive strength variants of a given cell.

    See Also
    --------
    skywater_pdk.base.Cell
    skywater_pdk.sizes.CellSizeNumeric
    skywater_pdk.sizes.CellSizeLowPower
    skywater_pdk.sizes.CellSizeMinimum

    Examples
    --------
    >>> d1 = CellSize.from_suffix("_1")
    >>> d2 = CellSize.from_suffix("_lp")
    >>> d3 = CellSize.from_suffix("_m")
    >>> d4 = CellSize.from_suffix("_2")
    >>> CellSize.from_suffix("_abc")
    Traceback (most recent call last):
        ...
    InvalidSuffixError: Invalid suffix: _abc
    >>> l = [d1, d2, d3, d4]
    >>> l
    [CellSizeNumeric(units=1), CellSizeLowPower(lp_variant=0), CellSizeMinimum(), CellSizeNumeric(units=2)]
    >>> l.sort()
    >>> l
    [CellSizeNumeric(units=1), CellSizeNumeric(units=2), CellSizeLowPower(lp_variant=0), CellSizeMinimum()]
    """

    @abc.abstractmethod
    def describe(self):
        raise NotImplementedError

    @property
    @abc.abstractmethod
    def suffix(self):
        raise NotImplementedError

    @classmethod
    def from_suffix(cls, s):
        errors = []
        for subcls in cls.__subclasses__():
            try:
                return subcls.from_suffix(s)
            except (ValueError, AssertionError) as e:
                errors.append((subcls.__name__, e))
        assert errors, ("Unknown error!?", s)
        msg = [s, '']
        for cls_name, e in errors:
            if isinstance(e, ValueError):
                continue
            msg.append("{} failed with: {}".format(cls_name, e))
        raise InvalidSuffixError("\n".join(msg))

    def __str__(self):
        return "with size {}".format(self.describe())

    def _cmp(self, op, o):
        if not isinstance(o, CellSize):
            return False
        return op(self.suffix, o.suffix)

    # Comparison operators
    def __lt__(self, o):
        return self._cmp(operator.lt, o)

    def __le__(self, o):
        return self._cmp(operator.le, o)

    def __eq__(self, o):
        return self._cmp(operator.eq, o)

    def __ne__(self, o):
        return self._cmp(operator.ne, o)

    def __ge__(self, o):
        return self._cmp(operator.ge, o)

    def __gt__(self, o):
        return self._cmp(operator.gt, o)


@dataclass_json
@dataclass(frozen=True)
class CellSizeNumeric(CellSize):
    """

    See Also
    --------
    skywater_pdk.base.Cell
    skywater_pdk.sizes.CellSize
    skywater_pdk.sizes.CellSizeLowPower
    skywater_pdk.sizes.CellSizeMinimum

    Examples
    --------
    >>> s1 = CellSizeNumeric.from_suffix("_1")
    >>> s2 = CellSizeNumeric.from_suffix("_2")
    >>> s3 = CellSizeNumeric.from_suffix("_3")
    >>> CellSizeNumeric.from_suffix("_-1")
    Traceback (most recent call last):
        ...
    InvalidSuffixError: Invalid suffix: _-1
    >>> s1
    CellSizeNumeric(units=1)
    >>> s2
    CellSizeNumeric(units=2)
    >>> s3
    CellSizeNumeric(units=3)
    >>> str(s1)
    'with size of 1 units'
    >>> str(s2)
    'with size of 2 units'
    >>> str(s3)
    'with size of 3 units (invalid?)'
    >>> s1.describe()
    'of 1 units'
    >>> s2.describe()
    'of 2 units'
    >>> s3.describe()
    'of 3 units (invalid?)'
    >>> s1.suffix
    '_1'
    >>> s2.suffix
    '_2'
    >>> s3.suffix
    '_3'
    """
    units: int

    VALID_UNIT_VALUES = (0, 1, 2, 4, 8, 6, 12, 14, 16, 20, 32)

    def describe(self):
        suffix = ""
        if self.units not in self.VALID_UNIT_VALUES:
            suffix = " (invalid?)"

        return "of {} units{}".format(self.units, suffix)

    @property
    def suffix(self):
        return "_{}".format(self.units)

    @classmethod
    def from_suffix(cls, s):
        if not s.startswith("_"):
            raise InvalidSuffixError(s)
        i = int(s[1:])
        if i < 0:
            raise InvalidSuffixError(s)
        return cls(i)


@dataclass_json
@dataclass(frozen=True)
class CellSizeLowPower(CellSize):
    """

    See Also
    --------
    skywater_pdk.base.Cell
    skywater_pdk.sizes.CellSize
    skywater_pdk.sizes.CellSizeNumeric
    skywater_pdk.sizes.CellSizeMinimum

    Examples
    --------
    >>> lp = CellSizeLowPower.from_suffix("_lp")
    >>> lp2 = CellSizeLowPower.from_suffix("_lp2")
    >>> lp3 = CellSizeLowPower.from_suffix("_lp3")
    >>> CellSizeLowPower.from_suffix("_ld")
    Traceback (most recent call last):
        ...
    InvalidSuffixError: Invalid suffix: _ld
    >>> lp
    CellSizeLowPower(lp_variant=0)
    >>> lp2
    CellSizeLowPower(lp_variant=1)
    >>> lp3
    CellSizeLowPower(lp_variant=2)
    >>> str(lp)
    'with size for low power'
    >>> str(lp2)
    'with size for low power (alternative)'
    >>> str(lp3)
    'with size for low power (extra alternative 0)'
    >>> lp.describe()
    'for low power'
    >>> lp2.describe()
    'for low power (alternative)'
    >>> lp3.describe()
    'for low power (extra alternative 0)'
    >>> lp.suffix
    '_lp'
    >>> lp2.suffix
    '_lp2'
    >>> lp3.suffix
    '_lp3'
    """
    lp_variant: int = 0

    def describe(self):
        if self.lp_variant == 0:
            suffix = ""
        elif self.lp_variant == 1:
            suffix = " (alternative)"
        else:
            assert self.lp_variant >= 2, self.lp_variant
            suffix = " (extra alternative {})".format(self.lp_variant-2)
        return "for low power"+suffix

    @property
    def suffix(self):
        if self.lp_variant == 0:
            return "_lp"
        else:
            assert self.lp_variant > 0, self.lp_variant
            return "_lp{}".format(self.lp_variant+1)

    @classmethod
    def from_suffix(cls, s):
        if not s.startswith("_lp"):
            raise InvalidSuffixError(s)
        if s == "_lp":
            return cls()
        elif s == "_lp2":
            return cls(1)
        else:
            try:
                i = int(s[3:])
            except ValueError as e:
                raise InvalidSuffixError(s)
            assert i > 2, (s, i)
            return cls(i-1)


class CellSizeMinimum(CellSize):
    """

    See Also
    --------
    skywater_pdk.base.Cell
    skywater_pdk.sizes.CellSize
    skywater_pdk.sizes.CellSizeNumeric
    skywater_pdk.sizes.CellSizeLowPower


    Examples
    --------
    >>> m = CellSizeMinimum.from_suffix("_m")
    >>> CellSizeMinimum.from_suffix("_m2")
    Traceback (most recent call last):
        ...
    InvalidSuffixError: Invalid suffix: _m2
    >>> m
    CellSizeMinimum()
    >>> str(m)
    'with size minimum'
    >>> m.describe()
    'minimum'
    >>> m.suffix
    '_m'

    >>> m1 = CellSizeMinimum()
    >>> m2 = CellSizeMinimum()
    >>> assert m1 is m2
    """
    _object = None
    def __new__(cls):
        if cls._object is None:
            cls._object = object.__new__(cls)
        return cls._object

    def __repr__(self):
        return "CellSizeMinimum()"

    def describe(self):
        return "minimum"

    @property
    def suffix(self):
        return "_m"

    @classmethod
    def from_suffix(cls, s):
        if s != "_m":
            raise InvalidSuffixError(s)
        return cls()

    def __hash__(self):
        return id(self)

    def to_dict(self):
        return {'minimum': None}


CellSizeMinimum._object = CellSizeMinimum()


if __name__ == "__main__":
    import doctest
    doctest.testmod()
