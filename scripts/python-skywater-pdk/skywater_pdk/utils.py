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

import dataclasses
import dataclasses_json
import functools
import random
import sys

from dataclasses import dataclass
from dataclasses_json import dataclass_json
from enum import Flag
from typing import Optional, Tuple, Any


def dataclass_json_passthru_config(*args, **kw):
    return dataclasses.field(
        *args,
        metadata=dataclasses_json.config(
            encoder=lambda x: x.to_json(),
            #decoder=lambda x: x.from_json(),
        ),
        **kw,
    )

def dataclass_json_passthru_sequence_config(*args, **kw):
    def to_json_sequence(s):
        if s is None:
            return None
        o = []
        for i in s:
            if hasattr(i, 'to_json'):
                o.append(i.to_json())
            else:
                o.append(i)
        return o

    return dataclasses.field(
        *args,
        metadata=dataclasses_json.config(
            encoder=to_json_sequence,
            #decoder=lambda x: x.from_json(),
        ),
        **kw,
    )



def comparable_to_none(cls):
    """

    Examples
    --------

    >>> @comparable_to_none
    ... @dataclass(order=True)
    ... class A:
    ...     a: int = 0
    >>> @comparable_to_none
    ... @dataclass(order=True)
    ... class B:
    ...     b: Optional[A] = None
    >>> b0 = B()
    >>> repr(b0)
    'B(b=None)'
    >>> str(b0)
    'B(b=None)'
    >>> b1 = B(A())
    >>> repr(b1)
    'B(b=A(a=0))'
    >>> str(b1)
    'B(b=A(a=0))'
    >>> b2 = B(A(2))
    >>> repr(b2)
    'B(b=A(a=2))'
    >>> str(b2)
    'B(b=A(a=2))'
    >>> l = [b0, b1, b2, None]
    >>> for i in range(0, 3):
    ...     random.shuffle(l)
    ...     l.sort()
    ...     print(l)
    [None, B(b=None), B(b=A(a=0)), B(b=A(a=2))]
    [None, B(b=None), B(b=A(a=0)), B(b=A(a=2))]
    [None, B(b=None), B(b=A(a=0)), B(b=A(a=2))]

    """
    class ComparableToNoneVersion(cls):
        def __ge__(self, other):
            if other is None:
                return True
            return super().__ge__(other)
        def __gt__(self, other):
            if other is None:
                return True
            return super().__gt__(other)
        def __le__(self, other):
            if other is None:
                return False
            return super().__le__(other)
        def __lt__(self, other):
            if other is None:
                return False
            return super().__lt__(other)
        def __eq__(self, other):
            if other is None:
                return False
            return super().__eq__(other)
        def __hash__(self):
            return super().__hash__()
        def __repr__(self):
            s = super().__repr__()
            return s.replace('comparable_to_none.<locals>.ComparableToNoneVersion', cls.__name__)

    for a in functools.WRAPPER_ASSIGNMENTS:
        if not hasattr(cls, a):
            continue
        setattr(ComparableToNoneVersion, a, getattr(cls, a))

    return ComparableToNoneVersion


def _is_optional_type(t):
    """

    Examples
    --------

    >>> _is_optional_type(Optional[int])
    True
    >>> _is_optional_type(Optional[Tuple])
    True
    >>> _is_optional_type(Any)
    False
    """
    return hasattr(t, "__args__") and len(t.__args__) == 2 and t.__args__[-1] is type(None)


def _get_the_optional_type(t):
    """

    Examples
    --------

    >>> _get_the_optional_type(Optional[int])
    <class 'int'>
    >>> _get_the_optional_type(Optional[Tuple])
    typing.Tuple
    >>> class A:
    ...     pass
    >>> _get_the_optional_type(Optional[A])
    <class '__main__.A'>
    >>> _get_type_name(_get_the_optional_type(Optional[A]))
    'A'
    """
    assert _is_optional_type(t), t
    return t.__args__[0]


def _get_type_name(ot):
    """

    Examples
    --------

    >>> _get_type_name(int)
    'int'
    >>> _get_type_name(Tuple)
    'Tuple'
    >>> _get_type_name(Optional[Tuple])
    'typing.Union[typing.Tuple, NoneType]'
    """
    if hasattr(ot, "_name") and ot._name:
        return ot._name
    elif hasattr(ot, "__name__") and ot.__name__:
        return ot.__name__
    else:
        return str(ot)


class OrderedFlag(Flag):
    def __ge__(self, other):
        if other is None:
            return True
        if self.__class__ is other.__class__:
            return self.value >= other.value
        return NotImplemented
    def __gt__(self, other):
        if other is None:
            return True
        if self.__class__ is other.__class__:
            return self.value > other.value
        return NotImplemented
    def __le__(self, other):
        if other is None:
            return False
        if self.__class__ is other.__class__:
            return self.value <= other.value
        return NotImplemented
    def __lt__(self, other):
        if other is None:
            return False
        if self.__class__ is other.__class__:
            return self.value < other.value
        return NotImplemented
    def __eq__(self, other):
        if other is None:
            return False
        if self.__class__ is other.__class__:
            return self.value == other.value
        return NotImplemented
    def __hash__(self):
        return hash(self._name_)


if __name__ == "__main__":
    import doctest
    doctest.testmod()
