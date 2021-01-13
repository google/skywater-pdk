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


import argparse
import enum
import json
import os
import pathlib
import pprint
import re
import sys

from collections import defaultdict

from typing import Tuple, List, Dict

from math import frexp, log2

from . import sizes
from .utils import sortable_extracted_numbers


debug = False

LOG2_10 = log2(10)

class TimingType(enum.IntFlag):
    """

    >>> TimingType.parse("ff_100C_1v65")
    ('ff_100C_1v65', <TimingType.basic: 1>)

    >>> TimingType.parse("ff_100C_1v65_ccsnoise")
    ('ff_100C_1v65', <TimingType.ccsnoise: 3>)

    >>> TimingType.basic in TimingType.ccsnoise
    True

    >>> TimingType.parse("ff_100C_1v65_pwrlkg")
    ('ff_100C_1v65', <TimingType.leakage: 4>)

    >>> (TimingType.basic).describe()
    ''
    >>> (TimingType.ccsnoise).describe()
    '(with ccsnoise)'
    >>> (TimingType.leakage).describe()
    '(with power leakage)'
    >>> (TimingType.leakage | TimingType.ccsnoise).describe()
    '(with ccsnoise and power leakage)'

    >>> (TimingType.leakage | TimingType.ccsnoise).names()
    'basic, ccsnoise, leakage'

    >>> TimingType.ccsnoise.names()
    'basic, ccsnoise'
    """

    basic    = 1

    # ccsnoise files are basic files with extra 'ccsn_' values in the timing
    # data.
    ccsnoise = 2 | basic

    # leakage files are separate from the basic files
    leakage  = 4

    def names(self):
        o = []
        for t in TimingType:
            if t in self:
                o.append(t.name)
        return ", ".join(o)

    def describe(self):
        o = []
        if TimingType.ccsnoise in self:
            o.append("ccsnoise")
        if TimingType.leakage in self:
            o.append("power leakage")
        if not o:
            return ""
        return "(with "+" and ".join(o)+")"

    @property
    def file(self):
        if self == TimingType.ccsnoise:
            return "_ccsnoise"
        elif self == TimingType.leakage:
            return "_pwrlkg"
        return ""

    @classmethod
    def parse(cls, name):
        ttype = TimingType.basic
        if name.endswith("_ccsnoise"):
            name = name[:-len("_ccsnoise")]
            ttype = TimingType.ccsnoise
        elif name.endswith("_pwrlkg"):
            name = name[:-len("_pwrlkg")]
            ttype = TimingType.leakage
        return name, ttype

    @property
    def singular(self):
        return len(self.types) == 1

    @property
    def types(self):
        tt = set(t for t in TimingType if t in self)
        if TimingType.ccsnoise in tt:
            tt.remove(TimingType.basic)
        return list(tt)



def cell_corner_file(lib, cell_with_size, corner, corner_type: TimingType):
    """

    >>> cell_corner_file("sky130_fd_sc_hd", "a2111o", "ff_100C_1v65", TimingType.basic)
    'cells/a2111o/sky130_fd_sc_hd__a2111o__ff_100C_1v65.lib.json'
    >>> cell_corner_file("sky130_fd_sc_hd", "a2111o_1", "ff_100C_1v65", TimingType.basic)
    'cells/a2111o/sky130_fd_sc_hd__a2111o_1__ff_100C_1v65.lib.json'
    >>> cell_corner_file("sky130_fd_sc_hd", "a2111o_1", "ff_100C_1v65", TimingType.ccsnoise)
    'cells/a2111o/sky130_fd_sc_hd__a2111o_1__ff_100C_1v65_ccsnoise.lib.json'

    """
    assert corner_type.singular, (lib, cell_with_size, corner, corner_type, corner_type.types())

    sz = sizes.parse_size(cell_with_size)
    if sz:
        cell = cell_with_size[:-len(sz.suffix)]
    else:
        cell = cell_with_size

    fname = "cells/{cell}/{lib}__{cell_sz}__{corner}{corner_type}.lib.json".format(
        lib=lib, cell=cell, cell_sz=cell_with_size, corner=corner, corner_type=corner_type.file)
    return fname


def top_corner_file(libname, corner, corner_type: TimingType, directory_prefix = "timing"):
    """

    >>> top_corner_file("sky130_fd_sc_hd", "ff_100C_1v65", TimingType.ccsnoise)
    'timing/sky130_fd_sc_hd__ff_100C_1v65_ccsnoise.lib.json'
    >>> top_corner_file("sky130_fd_sc_hd", "ff_100C_1v65", TimingType.basic)
    'timing/sky130_fd_sc_hd__ff_100C_1v65.lib.json'
    >>> top_corner_file("sky130_fd_sc_hd", "ff_100C_1v65", TimingType.basic, "")
    'sky130_fd_sc_hd__ff_100C_1v65.lib.json'

    """
    assert corner_type.singular, (libname, corner, corner_type, corner_type.types())

    if directory_prefix:
      return "{prefix}/{libname}__{corner}{corner_type}.lib.json".format(
          libname=libname,
          corner=corner,
          corner_type=corner_type.file,
          prefix = directory_prefix)

    return "{libname}__{corner}{corner_type}.lib.json".format(
          libname=libname,
          corner=corner,
          corner_type=corner_type.file)


def collect(library_dir) -> Tuple[Dict[str, TimingType], List[str]]:
    """Collect the available timing information in corners.

    Parameters
    ----------
    library_dir: str
        Path to a library.

    Returns
    -------
    lib : str
        Library name

    corners : {str: TimingType}
        corners in the library.

    cells : list of str
        cells in the library.
    """

    if not isinstance(library_dir, pathlib.Path):
        library_dir = pathlib.Path(library_dir)

    libname0 = None

    corners = {}
    all_cells = set()
    for p in library_dir.rglob("*.lib.json"):
        if not p.is_file():
            continue
        if "timing" in str(p):
            continue

        fname, fext = str(p.name).split('.', 1)

        libname, cellname, corner = fname.split("__")
        if libname0 is None:
            libname0 = libname
        assert libname0 == libname, (libname0, libname)

        corner_name, corner_type = TimingType.parse(corner)

        if corner_name not in corners:
            corners[corner_name] = [corner_type, set()]

        corners[corner_name][0] |= corner_type
        corners[corner_name][1].add(cellname)
        all_cells.add(cellname)

    for c in corners:
        corners[c] = (corners[c][0], list(sorted(corners[c][1])))

    assert corners, library_dir
    assert all_cells, library_dir
    assert libname0, library_dir

    all_cells = list(sorted(all_cells))

    # Sanity check to make sure the corner exists for all cells.
    for corner, (corner_types, corner_cells) in sorted(corners.items()):
        missing = set()
        for cell_with_size in all_cells:
            if cell_with_size not in corner_cells:
                missing.add(cell_with_size)

        if not missing:
            continue

        print("Missing", ", ".join(missing), "from", corner, corner_types)

    return libname0, corners, all_cells

    for corner, (corner_types, corner_cells) in sorted(corners.items()):
        for corner_type in corner_types.types:
            fname = cell_corner_file(libname0, cell_with_size, corner, corner_type)
            fpath = os.path.join(library_dir, fname)
            if not os.path.exists(fpath) and debug:
                print("Missing", (fpath, corner, corner_type, corner_types))

    timing_dir = os.path.join(library_dir, "timing")
    assert os.path.exists(timing_dir), timing_dir
    for corner, (corner_types, corner_cells) in sorted(corners.items()):
        for corner_type in corner_types.types:
            fname = top_corner_file(libname0, corner, corner_type)
            fpath = os.path.join(library_dir, fname)
            if not os.path.exists(fpath) and debug:
                print("Missing", (fpath, corner, corner_type, corner_types))

    return libname0, corners, all_cells


def remove_ccsnoise_from_timing(data, dataname):
    assert "timing" in data, (dataname, data.keys(), data)

    timing = data["timing"]

    if isinstance(timing, list):
        for i, t in enumerate(timing):
            assert isinstance(t, dict), (dataname, i, t)
            remove_ccsnoise_from_dict(t, "{}.timing[{:3d}]".format(dataname, i))
    elif isinstance(timing, dict):
        remove_ccsnoise_from_dict(timing, dataname+".timing")
    else:
        assert False, (dataname, type(timing), timing)


def remove_ccsnoise_from_dict(data, dataname):
    if "timing" in data:
        remove_ccsnoise_from_timing(data, dataname)

    ccsn_keys = set()
    for k in data:
        if "ccsn_" in k:
            ccsn_keys.add(k)

    for k in ccsn_keys:
        if debug:
            print("{:s}: Removing {}".format(dataname, k))
        del data[k]



def remove_ccsnoise_from_cell(data, cellname):
    remove_ccsnoise_from_dict(data, cellname)

    for k, v in list(data.items()):
        if k.startswith("pin "):
            pin_data = data[k]
            if "input_voltage" in pin_data:
                del pin_data["input_voltage"]

            remove_ccsnoise_from_dict(pin_data, "{}.{}".format(cellname, k))

        if k.startswith("bus"):
            bus_data = data[k]
            remove_ccsnoise_from_dict(bus_data, "{}.{}".format(cellname, k))


remove_ccsnoise_from_library = remove_ccsnoise_from_dict


def generate(library_dir, lib, corner, ocorner_type, icorner_type, cells, output_directory):
    output_directory_prefix = None if output_directory else "timing"
    top_fname = top_corner_file(lib, corner, ocorner_type, output_directory_prefix).replace('.lib.json', '.lib')
    output_directory = output_directory if output_directory else library_dir
    top_fpath = os.path.join(output_directory, top_fname)

    top_fout = open(top_fpath, "w")
    def top_write(lines):
        print("\n".join(lines), file=top_fout)

    otype_str = "({} from {})".format(ocorner_type.name, icorner_type.names())
    print("Starting to write", top_fpath, otype_str, flush=True)

    common_data = {}

    common_data_path = os.path.join(library_dir, "timing", "{}__common.lib.json".format(lib))
    assert os.path.exists(common_data_path), common_data_path
    with open(common_data_path) as f:
        d = json.load(f)
        assert isinstance(d, dict)
        for k, v in d.items():
            assert k not in common_data, (k, common_data[k])
            common_data[k] = v

    top_data_path = os.path.join(library_dir, top_corner_file(lib, corner, icorner_type))
    assert os.path.exists(top_data_path), top_data_path
    with open(top_data_path) as f:
        d = json.load(f)
        assert isinstance(d, dict)
        for k, v in d.items():
            if k in common_data:
                print("Overwriting", k, "with", v, "(existing value of", common_data[k], ")")
            common_data[k] = v

    # Remove the ccsnoise if it exists
    if ocorner_type != TimingType.ccsnoise:
        remove_ccsnoise_from_library(common_data, "library")

    attribute_types = {}
    output = liberty_dict("library", lib+"__"+corner, common_data, attribute_types)
    assert output[-1] == '}', output
    top_write(output[:-1])

    for cell_with_size in cells:
        fname = cell_corner_file(lib, cell_with_size, corner, icorner_type)
        fpath = os.path.join(library_dir, fname)
        assert os.path.exists(fpath), fpath

        with open(fpath) as f:
            cell_data = json.load(f)

        # Remove the ccsnoise if it exists
        if ocorner_type != TimingType.ccsnoise:
            remove_ccsnoise_from_cell(cell_data, cell_with_size)

        top_write([''])
        top_write(liberty_dict(
            "cell",
            "%s__%s" % (lib, cell_with_size),
            cell_data,
            [cell_with_size],
            attribute_types,
        ))

    top_write([''])
    top_write(['}'])
    top_fout.close()
    print("   Finish writing", top_fpath, flush=True)
    print("")


# * The 'delay_model' should be the 1st attribute in the library
# * The 'technology' should be the 1st attribute in the library

LIBERTY_ATTRIBUTE_ORDER = re.sub('/\\*[^*]*\\*/', '', """
library (name_string) {
    /* Library-Level Simple and Complex Attributes */
    define (...,...,...) ;
    technology (name_enum) ;
    delay_model : "model" ;

    bus_naming_style : "string" ;
    date : "date" ;
    comment : "string" ;

    /* Unit definitions */
    time_unit : "unit" ;
    voltage_unit : "unit" ;
    leakage_power_unit : "unit" ;
    current_unit : "unit" ;
    pulling_resistance_unit : "unit" ;
    ..._unit : "unit" ;
    /* FIXME: Should capacitive_load_unit always be last? */
    capacitive_load_unit (value, unit) ;

    /* FIXME: Why is define_cell_area here, while other defines are up above? */
    define_cell_area (area_name, resource_type) ;

    revision : float | string ;

    /* Default Attributes and Values */
    default_cell_leakage_power : float ;
    default_fanout_load : float ;
    default_inout_pin_cap : float ;
    default_input_pin_cap : float ;
    default_max_transition : float ;
    default_output_pin_cap : float ;
    default_... : ... ;

    /* Scaling Factors Attributes and Values */
    k_process_cell_fall ... ;
    k_process_cell_rise ... ;
    k_process_fall_propagation ... ;
    k_process_fall_transition ... ;
    k_process_rise_propagation ... ;
    k_process_rise_transition ... ;
    k_temp_cell_fall ... ;
    k_temp_cell_rise ... ;
    k_temp_fall_propagation ... ;
    k_temp_fall_transition ... ;
    k_temp_rise_propagation ... ;
    k_temp_rise_transition ... ;
    k_volt_cell_fall ... ;
    k_volt_cell_rise ... ;
    k_volt_fall_propagation ... ;
    k_volt_fall_transition ... ;
    k_volt_rise_propagation ... ;
    k_volt_rise_transition ... ;
    k_... : ... ;

    /* Library-Level Group Statements */
    operating_conditions (name_string) {
        ... operating conditions description ...
    }
    wire_load (name_string) {
        ... wire load description ...
    }
    wire_load_selection (name_string) {
        ... wire load selection criteria...
    }
    power_lut_template (namestring)  {
        ... power lookup table template information...
    }
    lu_table_template (name_string) {
        variable_1 : value_enum ;
        variable_2 : value_enum ;
        variable_3 : value_enum ;
        index_1 ("float, ..., float");
        index_2 ("float, ..., float");
        index_3 ("float, ..., float");
    }
    normalized_driver_waveform (waveform_template_name) {
        driver_waveform_name : string; /* Specifies the name of the driver waveform table */
        index_1 ("float, ... float"); /* Specifies input net transition */
        index_2 ("float, ... float"); /* Specifies normalized voltage */
        values ("float, ... float", \ /* Specifies the time in library units */
            ... , \\
            "float, ... float");
    }

    /* Cell definitions */
    cell (namestring2) {
        ... cell description ...
    }

    ...

    /* FIXME: What are these and why are they last */
    type (namestring) {
        ... type description ...
    }
    input_voltage (name_string) {
        ... input voltage information ...
    }
    output_voltage (name_string) {
        ... output voltage information ...
    }
}
""")


RE_LIBERTY_LIST = re.compile("(.*)_([0-9]+)")
RE_NUMBERS = re.compile('([0-9]+)')


def _lookup_attribute_pos(name):
    # Pad with spaces so you don't get substring matches.
    name = ' ' + name
    if name.endswith('_'):
        name = name + ' '
    i = LIBERTY_ATTRIBUTE_ORDER.find(name)
    if i != -1:
        return float(i)
    return None


def liberty_attribute_order(attr_name):
    """

    FIXME: Make these doctests less fragile...
    >>> liberty_attribute_order("define")
    (33.0, 0.0)

    >>> liberty_attribute_order('voltage_map')
    (inf, inf)

    >>> liberty_attribute_order('slew_lower_threshold_pct_fall')
    (inf, inf)

    >>> liberty_attribute_order('time_unit')
    (203.0, 0.0)
    >>> liberty_attribute_order('random_unit')
    (357.0, 0.0)
    >>> liberty_attribute_order('capacitive_load_unit')
    (386.0, 0.0)

    >>> liberty_attribute_order('technology')
    (60.0, 0.0)
    >>> liberty_attribute_order('technology("cmos")')
    (60.0, 0.0)

    >>> liberty_attribute_order('delay_model')
    (89.0, 0.0)

    >>> liberty_attribute_order("cell")
    (2282.0, 0.0)

    >>> v1, v2 = "variable_1", "variable_2"
    >>> i1, i2, i3, i4 = "index_1", "index_2", "index_3", "index_4"
    >>> print('\\n'.join(sorted([v2, i1, v1, i2, i3, i4], key=liberty_attribute_order)))
    variable_1
    variable_2
    index_1
    index_2
    index_3
    index_4

    >>> liberty_attribute_order("values")
    (2182.0, 0.0)

    >>> print('\\n'.join(sorted([
    ...     'default_inout_pin_cap',
    ...     'k_XXXX',
    ...     'k_temp_cell_fall',
    ...     'default_XXXX',
    ... ], key=liberty_attribute_order)))
    default_inout_pin_cap
    default_XXXX
    k_temp_cell_fall
    k_XXXX


    """
    assert ':' not in attr_name, attr_name

    m = RE_LIBERTY_LIST.match(attr_name)
    if m:
        k, n = m.group(1), m.group(2)

        i = _lookup_attribute_pos(k)
        if not i:
            i = float('inf')

        return float(i), float(n)

    lookup_name = attr_name
    i = _lookup_attribute_pos(lookup_name)
    if i:
        return i, 0.0

    if '(' in lookup_name:
        lookup_name = lookup_name[:lookup_name.index('(')]

    if 'default_' in attr_name:
        lookup_name = 'default_...'
    if '_unit' in attr_name:
        lookup_name = '..._unit'
    if 'k_' in attr_name:
        lookup_name = 'k_...'

    i = _lookup_attribute_pos(lookup_name)
    if i:
        return i, 0.0

    return float('inf'), float('inf')


def is_liberty_list(k):
    """

    >>> is_liberty_list("variable_1")
    True
    >>> is_liberty_list("index_3")
    True
    >>> is_liberty_list("values")
    True
    """
    m = RE_LIBERTY_LIST.match(k)
    if m:
        k, n = m.group(1), m.group(2)

    return k in ('variable', 'index', 'values')


def liberty_guess(o):
    """

    >>> liberty_guess('hello')  # doctest: +ELLIPSIS
    <function liberty_str at ...>
    >>> liberty_guess(1.0)      # doctest: +ELLIPSIS
    <function liberty_float at ...>
    >>> liberty_guess(1)        # doctest: +ELLIPSIS
    <function liberty_float at ...>
    >>> liberty_guess(None)
    Traceback (most recent call last):
        ...
    ValueError: None has unguessable type: <class 'NoneType'>

    """
    if isinstance(o, str):
        return liberty_str
    elif isinstance(o, (float,int)):
        return liberty_float
    else:
        raise ValueError("%r has unguessable type: %s" % (o, type(o)))


def liberty_bool(b):
    """

    >>> liberty_bool(True)
    'true'
    >>> liberty_bool(False)
    'false'
    >>> liberty_bool(1.0)
    'true'
    >>> liberty_bool(1.5)
    Traceback (most recent call last):
        ...
    ValueError: 1.5 is not a bool

    >>> liberty_bool(0.0)
    'false'
    >>> liberty_bool(0)
    'false'
    >>> liberty_bool(1)
    'true'
    >>> liberty_bool("error")
    Traceback (most recent call last):
        ...
    ValueError: 'error' is not a bool

    """
    try:
        b2 = bool(b)
    except ValueError:
        b2 = None

    if b2 != b:
        raise ValueError("%r is not a bool" % b)

    return {True: 'true', False: 'false'}[b]


def liberty_str(s):
    """

    >>> liberty_str("hello")
    '"hello"'

    >>> liberty_str('he"llo')
    Traceback (most recent call last):
        ...
    ValueError: '"' is not allow in the string: 'he"llo'

    >>> liberty_str(1.0)
    '"1.0000000000"'

    >>> liberty_str(1)
    '"1.0000000000"'

    >>> liberty_str([])
    Traceback (most recent call last):
        ...
    ValueError: [] is not a string

    >>> liberty_str(True)
    Traceback (most recent call last):
        ...
    ValueError: True is not a string

    """
    try:
        if isinstance(s, (int, float)):
            s = liberty_float(s)
    except ValueError:
        pass

    if not isinstance(s, str):
        raise ValueError("%r is not a string" % s)

    if '"' in s:
        raise ValueError("'\"' is not allow in the string: %r" % s)

    return '"'+s+'"'


def liberty_int(f):
    """

    >>> liberty_int(1.0)
    1
    >>> liberty_int(1.5)
    Traceback (most recent call last):
        ...
    ValueError: 1.5 is not an int

    >>> liberty_int("error")
    Traceback (most recent call last):
        ...
    ValueError: 'error' is not an int

    """
    try:
        f2 = int(f)
    except ValueError as e:
        f2 = None

    if f2 is None or f2 != f:
        raise ValueError("%r is not an int" % f)
    return int(f)


def liberty_float(f):
    """

    >>> liberty_float(1.9208818e-02)
    '0.0192088180'

    >>> liberty_float(1.5)
    '1.5000000000'

    >>> liberty_float(1e20)
    '1.000000e+20'

    >>> liberty_float(1)
    '1.0000000000'

    >>> liberty_float(1e9)
    '1000000000.0'

    >>> liberty_float(1e10)
    '1.000000e+10'

    >>> liberty_float(1e15)
    '1.000000e+15'

    >>> liberty_float(True)
    Traceback (most recent call last):
        ...
    ValueError: True is not a float

    >>> liberty_float(False)
    Traceback (most recent call last):
        ...
    ValueError: False is not a float

    >>> liberty_float(0)
    '0.0000000000'

    >>> liberty_float(None)
    Traceback (most recent call last):
        ...
    ValueError: None is not a float

    >>> liberty_float('hello')
    Traceback (most recent call last):
        ...
    ValueError: 'hello' is not a float


    """
    try:
        r = float(f)
    except (ValueError, TypeError):
        r = None

    if isinstance(f, bool):
        r = None

    if f is None or r != f:
        raise ValueError("%r is not a float" % f)

    width = 11

    mag = int(frexp(r)[1]/LOG2_10)
    if mag > 9:
        return f'%{width}e' % r
    if mag < 0:
        return f"%{width+1}.{width-1}f" % r
    else:
        return f"%{width+1}.{width-mag-1}f" % r

LIBERTY_ATTRIBUTE_TYPES = {
    'boolean':  liberty_bool,
    'string':   liberty_str,
    'int':      liberty_int,
    'float':    liberty_float,
}


INDENT="    "


def liberty_composite(k, v, i=tuple()):
    """

    >>> def pl(l):
    ...     print("\\n".join(l))

    >>> pl(liberty_composite("capacitive_load_unit", [1.0, "pf"], []))
    capacitive_load_unit(1.0000000000, "pf");

    >>> pl(liberty_composite("voltage_map", [("vpwr", 1.95), ("vss", 0.0)], []))
    voltage_map("vpwr", 1.9500000000);
    voltage_map("vss", 0.0000000000);

    >>> pl(liberty_composite("library_features", 'report_delay_calculation', []))
    library_features("report_delay_calculation");

    """
    if isinstance(v, tuple):
        v = list(v)
    if not isinstance(v, list):
        v = [v]
    #assert isinstance(v, list), (k, v)

    if isinstance(v[0], (list, tuple)):
        o = []
        for j, l in enumerate(v):
            o.extend(liberty_composite(k, l, i))
        return o

    o = []
    for l in v:
        if isinstance(l, (float, int)):
            o.append(liberty_float(l))
        elif isinstance(l, str):
            assert '"' not in l, (k, v)
            o.append('"%s"' % l)
        else:
            raise ValueError("%s - %r (%r)" % (k, l, v))

    return ["%s%s(%s);" % (INDENT*len(i), k, ", ".join(o))]


def liberty_join(l):
    """

    >>> l = [5, 1.0, 10]
    >>> liberty_join(l)(l)
    '5.0000000000, 1.0000000000, 10.000000000'

    >>> l = [1, 5, 8]
    >>> liberty_join(l)(l)
    '1, 5, 8'

    """
    d = defaultdict(lambda: 0)

    for i in l:
        d[type(i)] += 1

    def types(l):
        return [(i, type(i)) for i in l]

    if d[float] > 0:
        assert (d[float]+d[int]) == len(l), (d, types(l))
        def join(l):
            return ", ".join(liberty_float(f) for f in l)
        return join

    elif d[int] > 0:
        assert d[int] == len(l), (d, types(l))
        def join(l):
            return ", ".join(str(f) for f in l)
        return join

    raise ValueError("Invalid value: %r" % types(l))


def liberty_list(k, v, i=tuple()):
    o = []
    if isinstance(v[0], list):
        o.append('%s%s(' % (INDENT*len(i), k))
        join = liberty_join(v[0])
        for l in v:
            o.append('%s"%s", \\' % (INDENT*(len(i)+1), join(l)))

        o0 = o.pop(0)
        o[0] = o0+o[0].lstrip()

        o[-1] = o[-1][:-3] + ');'
    else:
        join = liberty_join(v)
        o.append('%s%s("%s");' % (INDENT*len(i), k, join(v)))

    return o


def liberty_dict(dtype, dvalue, data, indent=tuple(), attribute_types=None):
    """

    >>> def g(a, b, c):
    ...     return {"group_name": a, "attribute_name":b, "attribute_type": c}
    >>> d = {'float': 1.0, "str": "str"}
    >>> print('\\n'.join(liberty_dict("library", "test", d)))
    library ("test") {
        float : 1.0000000000;
        str : "str";
    }
    >>> d['define'] = [g("cell", "float", "string")]
    >>> print('\\n'.join(liberty_dict("library", "test", d)))
    library ("test") {
        define(float,cell,string);
        float : 1.0000000000;
        str : "str";
    }
    >>> d['define'] = [g("library", "float", "string")]
    >>> print('\\n'.join(liberty_dict("library", "test", d)))
    library ("test") {
        define(float,library,string);
        float : "1.0000000000";
        str : "str";
    }

    """
    assert isinstance(data, dict), (dtype, dvalue, data)

    if attribute_types is None:
        attribute_types = {}
    assert isinstance(attribute_types, dict), (dtype, dvalue, attribute_types)

    o = []

    if dvalue:
        dbits = dvalue.split(",")
        for j, d in enumerate(dbits):
            if '"' in d:
                assert d.startswith('"'), (dvalue, dbits, indent)
                assert d.endswith('"'), (dvalue, dbits, indent)
                dbits[j] = d[1:-1]
        dvalue = ','.join('"%s"' % d.strip() for d in dbits)
    o.append('%s%s (%s) {' % (INDENT*len(indent), dtype, dvalue))

    # Sort the attributes
    def attr_sort_key(item):
        k, v = item

        if "," in k:
            ktype, kvalue = k.split(",", 1)
            sortable_kv = sortable_extracted_numbers(kvalue)
        else:
            ktype = k
            kvalue = ""
            sortable_kv = tuple()

        if ktype == "comp_attribute":
            sortable_kt = liberty_attribute_order(kvalue)
        else:
            sortable_kt = liberty_attribute_order(ktype)

        return sortable_kt, ktype, sortable_kv, kvalue, k, v

    di = [attr_sort_key(i) for i in data.items()]
    di.sort()
    if debug:
        print(" "*len(str(indent)), "s1   s2     ", "%-40s" % "ktype", '%-40r' % "kvalue", "value")
        print("-"*len(str(indent)), "---- ----   ", "-"*40, "-"*40, "-"*44)
        for sk, kt, skv, kv, k, v in di:
            print(str(indent), "%4.0f %4.0f --" % sk, "%-40s" % kt, '%-40r' % kv, end=" ")
            sv = str(v)
            print(sv[:40], end=" ")
            if len(sv) > 40:
                print('...', end=" ")
            print()


    # Output all the attributes
    if dtype not in attribute_types:
        dtype_attribute_types = {}
        attribute_types[dtype] = dtype_attribute_types
    dtype_attribute_types = attribute_types[dtype]

    for _, ktype, _, kvalue, k, v in di:
        indent_n = list(indent)+[k]

        if ktype == 'define':
            for d in sorted(data['define'], key=lambda d: d['group_name']+'.'+d['attribute_name']):

                aname = d['attribute_name']
                gname = d['group_name']
                atype = d['attribute_type']

                o.append('%sdefine(%s,%s,%s);' % (
                    INDENT*len(indent_n), aname, gname, atype))

                assert atype in LIBERTY_ATTRIBUTE_TYPES, (atype, d)
                if gname not in attribute_types:
                    attribute_types[gname] = {}
                attribute_types[gname][aname] = LIBERTY_ATTRIBUTE_TYPES[atype]

        elif ktype == "comp_attribute":
            o.extend(liberty_composite(kvalue, v, indent_n))

        elif isinstance(v, dict):
            assert isinstance(v, dict), (dtype, dvalue, k, v)
            o.extend(liberty_dict(ktype, kvalue, v, indent_n, attribute_types))

        elif isinstance(v, list):
            assert len(v) > 0, (dtype, dvalue, k, v)
            if isinstance(v[0], dict):
                def sk(o):
                    return o.items()

                for l in sorted(v, key=sk):
                    o.extend(liberty_dict(ktype, kvalue, l, indent_n, attribute_types))

            elif is_liberty_list(ktype):
                o.extend(liberty_list(ktype, v, indent_n))

            elif "table" == ktype:
                o.append('%s%s : "%s";' % (INDENT*len(indent_n), k, ",".join(v)))

            elif "clk_width" == ktype:
                for l in sorted(v):
                    o.append('%s%s : "%s";' % (INDENT*len(indent_n), k, l))

            else:
                raise ValueError("Unknown %s: %r\n%s" % ((ktype, kvalue, k), v, indent_n))

        else:
            if ktype in dtype_attribute_types:
                liberty_out = dtype_attribute_types[ktype]
            else:
                liberty_out = liberty_guess(v)
            ov = liberty_out(v)
            o.append("%s%s : %s;" % (INDENT*len(indent_n), k, ov))

    o.append("%s}" % (INDENT*len(indent)))
    return o




def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
            "library_path",
            help="Path to the library.",
            type=pathlib.Path,
            nargs=1)
    parser.add_argument(
            "corner",
            help="Corner to write output for.",
            default=None,
            nargs='*')

    parser.add_argument(
            "--ccsnoise",
            help="Include ccsnoise in file output.",
            action='store_true',
            default=False)
    parser.add_argument(
            "--leakage",
            help="Include power leakage in file output.",
            action='store_true',
            default=False)
    parser.add_argument(
            "--debug",
            help="Include verbose debug output on the console.",
            action='store_true',
            default=False)
    parser.add_argument(
            "-o",
            "--output_directory",
            help="Sets the parent directory of the liberty files",
            default="")

    args = parser.parse_args()
    if args.debug:
        global debug
        debug = True

    libdir = args.library_path[0]

    retcode = 0

    lib, corners, all_cells = collect(libdir)

    if args.ccsnoise:
        output_corner_type = TimingType.ccsnoise
    elif args.leakage:
        output_corner_type = TimingType.leakage
    else:
        output_corner_type = TimingType.basic

    if args.corner == ['all']:
        args.corner = list(sorted(k for k, (v0, v1) in corners.items() if output_corner_type in v0))

    if args.corner:
        for acorner in args.corner:
            if acorner in corners:
                continue
            print()
            print("Unknown corner:", acorner)
            retcode = 1
        if retcode != 0:
            args.corner.clear()

    if not args.corner:
        print()
        print("Available corners for", lib+":")
        for k, v in sorted(corners.items()):
            print("  -", k, v[0].describe())
        print()
        return retcode

    print("Generating", output_corner_type.name, "liberty timing files for", lib, "at", ", ".join(args.corner))
    print()
    for corner in args.corner:
        input_corner_type, corner_cells = corners[corner]
        if output_corner_type not in input_corner_type:
            print("Corner", corner, "doesn't support", output_corner_type, "(only {})".format(input_corner_type))
            return 1

        if output_corner_type == TimingType.basic and TimingType.ccsnoise in input_corner_type:
            input_corner_type = TimingType.ccsnoise
        else:
            input_corner_type = output_corner_type

        generate(
            libdir, lib,
            corner, output_corner_type, input_corner_type,
            corner_cells, args.output_directory
        )
    return 0


if __name__ == "__main__":
    import doctest
    fail, _ = doctest.testmod()
    if fail > 0:
        sys.exit(1)
    sys.exit(main())
