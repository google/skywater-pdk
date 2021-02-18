#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright 2020 The SkyWater PDK Authors.
#
# Use of this source code is governed by the Apache 2.0
# license that can be found in the LICENSE file or at
# https://www.apache.org/licenses/LICENSE-2.0
#
# SPDX-License-Identifier: Apache-2.0


import csv
import itertools
import json
import os
import pprint
import re
import sys
import textwrap

from collections import defaultdict

from ..sizes import parse_size
from ..utils import OrderedEnum

from .copyright import header as copyright_header


copyright_header = """\
/**
 * Copyright 2020 The SkyWater PDK Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 */
"""


class PortGroup(OrderedEnum):
    DATA_IN_CHAR   = 10  # A, A1, D, etc
    DATA_IN_WORD   = 11  # IN

    DATA_OUT_CHAR  = 20  # X, Y, Q
    DATA_OUT_WORD  = 21  # OUT

    DATA_IO_CHAR   = 30  # Inout?
    DATA_IO_WORD   = 31  # Inout?

    DATA_CONTROL   = 40  # SET / RESET / etc

    SCAN_CHAIN     = 44  # SCD, SCE, etc

    CLOCK          = 50  # Clock
    CLOCK_CONTROL  = 51  # Clock enable

    POWER_CONTROL  = 78  # SLEEP
    POWER_OTHER    = 79  # KAPWR
    POWER_POSITIVE = 80  # VPWR
    POWER_NEGATIVE = 81  # VGND

    @property
    def type(self):
        pg = self
        if pg in (self.DATA_IN_CHAR,  self.DATA_IN_WORD,
                  self.DATA_OUT_CHAR, self.DATA_OUT_WORD,
                  self.DATA_IO_CHAR,  self.DATA_IO_WORD,):
            return 'data'
        if pg in (self.DATA_CONTROL,):
            return 'control'
        if pg in (self.CLOCK, self.CLOCK_CONTROL,):
            return 'clocks'
        if pg in (self.SCAN_CHAIN,):
            return 'scanchain'
        if pg in (self.POWER_CONTROL,  self.POWER_OTHER,
                  self.POWER_POSITIVE, self.POWER_NEGATIVE,):
            return 'power'
        assert False, self

    @property
    def desc(self):
        pg = self
        if pg in (self.DATA_IN_CHAR,  self.DATA_IN_WORD,
                  self.DATA_OUT_CHAR, self.DATA_OUT_WORD,
                  self.DATA_IO_CHAR,  self.DATA_IO_WORD,):
            return 'Data Signals'
        if pg in (self.DATA_CONTROL,):
            return 'Control Signals'
        if pg in (self.SCAN_CHAIN,):
            return 'Scan Chain'
        if pg in (self.CLOCK, self.CLOCK_CONTROL,):
            return 'Clocking'
        if pg in (self.POWER_CONTROL,  self.POWER_OTHER,
                  self.POWER_POSITIVE, self.POWER_NEGATIVE,):
            return 'Power'
        assert False, self


    @classmethod
    def classify(cls, name, modname=None):
        """

        Data Input Signals
        ++++++++++++++++++

        >>> PortGroup.classify('A')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('A1')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('A1_N')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('A_N')
        <PortGroup.DATA_IN_CHAR: 10>

        >>> PortGroup.classify('B')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('B1')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('B1_N')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('B_N')
        <PortGroup.DATA_IN_CHAR: 10>

        >>> PortGroup.classify('C')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('C1')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('C1_N')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('C_N')
        <PortGroup.DATA_IN_CHAR: 10>

        >>> PortGroup.classify('J')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('K')
        <PortGroup.DATA_IN_CHAR: 10>

        >>> PortGroup.classify('IN')
        <PortGroup.DATA_IN_WORD: 11>

        >>> PortGroup.classify('D')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('D_N')
        <PortGroup.DATA_IN_CHAR: 10>

        >>> PortGroup.classify('P0')
        <PortGroup.DATA_IN_CHAR: 10>
        >>> PortGroup.classify('N1')
        <PortGroup.DATA_IN_CHAR: 10>

        >>> PortGroup.classify('CI')
        <PortGroup.DATA_IN_WORD: 11>
        >>> PortGroup.classify('CIN')
        <PortGroup.DATA_IN_WORD: 11>

        SCD
        Scan Chain Data
        >>> PortGroup.classify('SCD')
        <PortGroup.SCAN_CHAIN: 44>

        SCE
        Scan Chain Enable
        >>> PortGroup.classify('SCE')
        <PortGroup.SCAN_CHAIN: 44>

        Data Output Signals
        +++++++++++++++++++

        >>> PortGroup.classify('X')
        <PortGroup.DATA_OUT_CHAR: 20>
        >>> PortGroup.classify('X_N')
        <PortGroup.DATA_OUT_CHAR: 20>

        >>> PortGroup.classify('Y')
        <PortGroup.DATA_OUT_CHAR: 20>
        >>> PortGroup.classify('Y_N')
        <PortGroup.DATA_OUT_CHAR: 20>

        >>> PortGroup.classify('Z')
        <PortGroup.DATA_OUT_CHAR: 20>
        >>> PortGroup.classify('Z_N')
        <PortGroup.DATA_OUT_CHAR: 20>

        >>> PortGroup.classify('Q')
        <PortGroup.DATA_OUT_CHAR: 20>

        >>> PortGroup.classify('OUT')
        <PortGroup.DATA_OUT_WORD: 21>

        >>> PortGroup.classify('HI')
        <PortGroup.DATA_OUT_WORD: 21>
        >>> PortGroup.classify('LO')
        <PortGroup.DATA_OUT_WORD: 21>

        >>> PortGroup.classify('COUT')
        <PortGroup.DATA_OUT_WORD: 21>

        >>> PortGroup.classify('SUM')
        <PortGroup.DATA_OUT_WORD: 21>

        Data Control Signals
        ++++++++++++++++++++

        >>> PortGroup.classify('SET')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('SET_N')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('SET_B')
        <PortGroup.DATA_CONTROL: 40>

        >>> PortGroup.classify('S')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('S_N')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('S_B')
        <PortGroup.DATA_CONTROL: 40>

        >>> PortGroup.classify('R')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('R_N')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('R_B')
        <PortGroup.DATA_CONTROL: 40>

        >>> PortGroup.classify('RESET')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('RESET_N')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('RESET_B')
        <PortGroup.DATA_CONTROL: 40>

        >>> PortGroup.classify('RESET')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('RESET_N')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('RESET_B')
        <PortGroup.DATA_CONTROL: 40>

        Data Enable
        >>> PortGroup.classify('DE')
        <PortGroup.DATA_CONTROL: 40>

        Tristate Enable
        >>> PortGroup.classify('TE_B')
        <PortGroup.DATA_CONTROL: 40>

        Select lines on muxes
        >>> PortGroup.classify('S0')
        <PortGroup.DATA_CONTROL: 40>
        >>> PortGroup.classify('S4')
        <PortGroup.DATA_CONTROL: 40>

        Clock Signals
        +++++++++++++

        #>>> PortGroup.classify('C')
        #<PortGroup.CLOCK: 50>

        #>>> PortGroup.classify('CN')
        #<PortGroup.CLOCK: 50>

        #>>> PortGroup.classify('C_N')
        #<PortGroup.CLOCK: 50>

        >>> PortGroup.classify('CLK')
        <PortGroup.CLOCK: 50>

        >>> PortGroup.classify('GCLK')
        <PortGroup.CLOCK: 50>

        >>> PortGroup.classify('CLK_N')
        <PortGroup.CLOCK: 50>

        >>> PortGroup.classify('G')
        <PortGroup.CLOCK: 50>

        >>> PortGroup.classify('GN')
        <PortGroup.CLOCK: 50>

        >>> PortGroup.classify('G_N')
        <PortGroup.CLOCK: 50>

        >>> PortGroup.classify('GATE')
        <PortGroup.CLOCK: 50>

        >>> PortGroup.classify('GATE_N')
        <PortGroup.CLOCK: 50>


        Clock Control Signals
        +++++++++++++++++++++

        >>> PortGroup.classify('CLK_EN')
        <PortGroup.CLOCK_CONTROL: 51>

        >>> PortGroup.classify('CE')
        <PortGroup.CLOCK_CONTROL: 51>

        >>> PortGroup.classify('CEN')
        <PortGroup.CLOCK_CONTROL: 51>

        >>> PortGroup.classify('GATE_EN')
        <PortGroup.CLOCK_CONTROL: 51>

        >>> PortGroup.classify('GEN')
        <PortGroup.CLOCK_CONTROL: 51>

        >>> PortGroup.classify('GE')
        <PortGroup.CLOCK_CONTROL: 51>

        Positive Power Supplies
        +++++++++++++++++++++++

        >>> PortGroup.classify('VPWR')
        <PortGroup.POWER_POSITIVE: 80>

        >>> PortGroup.classify('VPB')
        <PortGroup.POWER_POSITIVE: 80>

        Negative Power Supplies
        +++++++++++++++++++++++

        >>> PortGroup.classify('VGND')
        <PortGroup.POWER_NEGATIVE: 81>

        >>> PortGroup.classify('VNB')
        <PortGroup.POWER_NEGATIVE: 81>

        >>> PortGroup.classify('DEST')
        <PortGroup.POWER_OTHER: 79>

        Power Control Signals
        +++++++++++++++++++++

        >>> PortGroup.classify('SLEEP')
        <PortGroup.POWER_CONTROL: 78>

        >>> PortGroup.classify('SLEEP_B')
        <PortGroup.POWER_CONTROL: 78>

        >>> PortGroup.classify('SLEEP_N')
        <PortGroup.POWER_CONTROL: 78>

        Other Power Suppliers
        +++++++++++++++++++++

        >>> PortGroup.classify('KAPWR')
        <PortGroup.POWER_OTHER: 79>

        >>> PortGroup.classify('KAGND')
        <PortGroup.POWER_OTHER: 79>

        >>> PortGroup.classify('DIODE')
        <PortGroup.POWER_OTHER: 79>

        >>> PortGroup.classify('LOWLVPWRA')
        <PortGroup.POWER_OTHER: 79>

        """
        # Override for csw module
        if modname and 'csw' in modname:
            if name == 'VPB':
                return cls.POWER_POSITIVE
            elif name == 'VNB':
                return cls.POWER_NEGATIVE
            elif name in ('S', 'D', 'GN', 'GP'):
                return cls.POWER_OTHER

        name = name.upper()
        if re.search('^[A-FJKPN][0-9]?(_[NB])?$', name):
            return cls.DATA_IN_CHAR

        if re.search('^[XYZQ][0-9]?(_[NB])?$', name):
            return cls.DATA_OUT_CHAR

        if re.search('^IN[0-9]?_?', name):
            return cls.DATA_IN_WORD
        if re.search('^CI[0-9]?_?', name):
            return cls.DATA_IN_WORD
        if re.search('^CIN[0-9]?_?', name):
            return cls.DATA_IN_WORD
        if re.search('^OUT[0-9]?_?', name):
            return cls.DATA_OUT_WORD
        if re.search('^COUT[0-9]?_?', name):
            return cls.DATA_OUT_WORD
        if re.search('^SUM[0-9]?_?', name):
            return cls.DATA_OUT_WORD
        if name in ('HI', 'LO'):
            return cls.DATA_OUT_WORD
        if name in ('UDP_IN',):
            return cls.DATA_IN_WORD
        if name in ('UDP_OUT',):
            return cls.DATA_OUT_WORD

        if re.search('^[SR][0-9]+$', name):
            return cls.DATA_CONTROL

        if re.search('^((SET)|(RESET)|[SR])(_[NB])?$', name):
            return cls.DATA_CONTROL

        if re.search('^((T)|(TE))(_[NB])?$', name):
            return cls.DATA_CONTROL

        if re.search('^(DE)(_[NB])?$', name):
            return cls.DATA_CONTROL
        if re.search('^(DATA_EN)$', name):
            return cls.DATA_CONTROL
        if re.search('^(SET_ASYNC)$', name):
            return cls.DATA_CONTROL

        if re.search('^((CLK)|(GCLK)|(GATE))_EN$', name):
            return cls.CLOCK_CONTROL
        if re.search('^[CG]EN$', name):
            return cls.CLOCK_CONTROL
        if re.search('^[CG]E$', name):
            return cls.CLOCK_CONTROL
        if re.search('^((CLK)|(GCLK)|(GATE))$', name):
            return cls.CLOCK
        if re.search('^((CLK)|(GCLK)|(GATE))_N$', name):
            return cls.CLOCK
        if re.search('^[G]_?N?$', name):
            return cls.CLOCK
        if re.search('^((CK)|(CP))$', name):
            return cls.CLOCK

        if re.search('^SLEEP(_[NB])?$', name):
            return cls.POWER_CONTROL

        if re.search('^VPWR', name):
            return cls.POWER_POSITIVE
        if re.search('^VPB$', name):
            return cls.POWER_POSITIVE
        if re.search('^VGND', name):
            return cls.POWER_NEGATIVE
        if re.search('^VNB$', name):
            return cls.POWER_NEGATIVE
        if name.startswith('DEST'):
            return cls.POWER_OTHER
        if 'NOT' in name:
            return cls.POWER_OTHER
        if 'DIODE' in name:
            return cls.POWER_OTHER
        if 'PWR' in name:
            return cls.POWER_OTHER
        if 'GND' in name:
            return cls.POWER_OTHER
        if 'SHORT' in name:
            return cls.POWER_OTHER
        if 'WELL' in name:
            return cls.POWER_OTHER

        if 'MET' in name:
            return cls.POWER_OTHER
        if re.search('^[M][0-1]$', name):
            return cls.POWER_OTHER
        if 'SRC' == name:
            return cls.DATA_IN_WORD
        if 'DST' == name:
            return cls.DATA_OUT_WORD
        if 'NETA' == name:
            return cls.DATA_IN_WORD
        if 'NETB' == name:
            return cls.DATA_OUT_WORD

        if name.startswith('SC'):
            return cls.SCAN_CHAIN
        if name.startswith('ASYNC'):
            return cls.SCAN_CHAIN



def seek_backwards(f):
    start_pos = f.tell()
    current_pos = f.tell()-1
    while True:
        f.seek(current_pos)
        d = f.read(1)
        if d not in '\n ,':
            break
        current_pos -= 1
    f.seek(current_pos+1)


def cell_sizes(basename, cellpath):
    sizes = []
    for f in os.listdir(cellpath):
        if not f.endswith('.gds'):
            continue
        f = f.split('.', 1)[0]

        libname, modname = f.split('__', 1)
        size = modname.replace(basename, '')
        if not size:
            continue
        assert size.startswith('_'), size
        sizes.append(size)
    return [parse_size(s) for s in sizes]



LOGICS = [
    ' | ',
    ' & ',
    ' OR ',
    ' AND ',
    ' NOR ',
    ' NAND ',
    '( ',
    ' )',
    ' of ',
    ' input ',
    ' output ',
    'input ',
    'output ',
    'of ',
    ' input',
    ' output',
    ' of',
    '1 ',
    '2 ',
    '3 ',
    '4 ',
    '5 ',
    '6 ',
    '7 ',
    '8 ',
    '9 ',
    '0 ',
]
DONT_BREAK = {}
for l in LOGICS:
    DONT_BREAK[l] = l.replace(' ', '\u00a0')

# Convert whitespace inside equations to non-breaking.
# \u00a0
#
# '2-input AND into first input of 4-input OR ((A1 & A2) | B1 | C1 | D1)'

def whitespace_convert(s):
    for fs, ts in DONT_BREAK.items():
        s = s.replace(fs, ts)
    return s

def whitespace_revert(s):
    for fs, ts in DONT_BREAK.items():
        s = s.replace(ts, fs)
    return s


def wrap(s, i=''):
    s = whitespace_convert(s)

    p = ' * '+i
    m = ' * '+(' '*len(i))

    s = "\n".join(textwrap.wrap(
        s,
        initial_indent=p,
        subsequent_indent=m,
        break_on_hyphens=False,
        expand_tabs=True,
    ))

    return whitespace_revert(s)


warning = """\
WARNING: This file is autogenerated, do not modify directly!
"""


def file_guard(fname):
    fname = re.sub('[^A-Za-z_0-9]', '_', fname)
    return fname.upper()


def write_verilog_header(f, vdesc, define_data):
    assert f.name, f
    guard = file_guard(os.path.basename(f.name))
    f.write(copyright_header)
    f.write('\n')
    f.write(f'`ifndef {guard}\n')
    f.write(f'`define {guard}\n')
    f.write('\n')
    f.write(f"/**\n")

    assert 'description' in define_data, define_data
    desc = define_data['description']
    eq = define_data.get('equation', '')

    if '\n' in desc:
        if eq:
            eq = ' '+eq
        f.write(wrap(eq, i=define_data['name']+":"))
        f.write("\n")
        for l in desc.splitlines():
            f.write(wrap(l.rstrip(), i='  '))
            f.write('\n')
    else:
        f.write(wrap(desc, i=define_data['name']+": "))
        f.write('\n')
        if eq:
            f.write(f" *\n")
            f.write(wrap(eq, i=((len(define_data['name'])+2)*" ")))
            f.write('\n')
    f.write(f" *\n")
    f.write(wrap(vdesc))
    f.write('\n')
    f.write(f" *\n")
    f.write(wrap(warning))
    f.write('\n')
    f.write(f" */\n")
    f.write('\n')
    f.write('`timescale 1ns / 1ps\n')
    f.write('`default_nettype none\n')
    f.write('\n')


def write_verilog_footer(f):
    assert f.name, f
    guard = file_guard(os.path.basename(f.name))
    f.write('\n')
    f.write('`default_nettype wire\n')
    f.write(f'`endif  // {guard}\n')
    f.close()



def write_module_header(f, define_data):
    f.write('(* blackbox *)\n')
    f.write(f"module {define_data['verilog_name']} (")


def write_verilog_parameters(f, define_data):
    maxlen = {}
    maxlen['pname'] = max([0]+[len(p[0]) for p in define_data['parameters']])
    maxlen['ptype'] = max([0]+[len(p[1]) for p in define_data['parameters']])
    if maxlen['pname']:
        f.write('\n    // Parameters\n')
    for pname, ptype in define_data['parameters']:
        pname = pname.ljust(maxlen['pname'])
        if maxlen['ptype']:
            ptype = ptype.ljust(maxlen['ptype'])+ ' '
        else:
            ptype = ''
        f.write(f'    parameter {ptype}{pname};\n')


def write_verilog_supplies(f, define_data):
    maxlen = {}
    maxlen['pname'] = max([0]+[len(p[1]) for p in define_data['ports'] if p[0] == 'power'])
    maxlen['ptype'] = max([0]+[len(p[3]) for p in define_data['ports'] if p[0] == 'power'])
    if maxlen['pname']:
        f.write('\n    // Voltage supply signals\n')
    for pclass, pname, pdir, ptype in define_data['ports']:
        if pclass != 'power':
            continue
        assert ptype, (pclass, pname, pdir, ptype)

        pname = pname.ljust(maxlen['pname'])
        ptype = ptype.ljust(maxlen['ptype'])

        f.write(f'    {ptype} {pname};\n')
    f.write('\n')


def write_verilog_ports(f, ports):
    maxlen = {}
    maxlen['pname'] = max([0]+[len(p[1]) for p in ports])
    maxlen['pdir']  = max([0]+[len(p[2]) for p in ports])
    maxlen['ptype'] = max([0]+[len(p[3]) for p in ports if p[0] != 'power'])

    for pclass, pname, pdir, ptype in ports:
        pname = pname.ljust(maxlen['pname'])
        f.write(f"\n    {pname},")
    seek_backwards(f)
    if ports:
        f.write("\n")
    f.write(");\n")

    for pclass, pname, pdir, ptype in ports:
        pname = pname.ljust(maxlen['pname'])

        if maxlen['pdir']:
            pdir = pdir.ljust(maxlen['pdir'])+' '
        else:
            pdir = ''

        if pclass == 'power':
            ptype = ''

        if maxlen['ptype']:
            ptype = ptype.ljust(maxlen['ptype'])+ ' '
        else:
            ptype = ''

        f.write(f"\n    {pdir}{ptype}{pname};")
    seek_backwards(f)
    if ports:
        f.write("\n")


def write_verilog_symbol_ports(f, pports):
    maxlen = {}
    maxlen['pname'] = max([0]+[len(p[2]) for p in pports if p])
    maxlen['pdir']  = max([0]+[len(p[3]) for p in pports if p])
    maxlen['ptype'] = max([0]+[len(p[4]) for p in pports if p and p[1] != 'power'])

    for i, p in enumerate(pports):
        if not p:
            np = pports[i+1]
            if i > 0:
                f.write('\n')
            f.write('\n    //# {{'+np[0].type+'|'+np[0].desc+'}}')
            continue
        pg, pclass, pname, pdir, ptype = p
        if pclass == 'power':
            ptype = ''

        pname = pname.ljust(maxlen['pname'])

        if maxlen['pdir']:
            pdir = pdir.ljust(maxlen['pdir'])+' '
        else:
            pdir = ''

        if maxlen['ptype']:
            ptype = ptype.ljust(maxlen['ptype'])+ ' '
        else:
            ptype = ''

        f.write(f"\n    {pdir}{ptype}{pname},")
    seek_backwards(f)
    if pports:
        f.write("\n")
    f.write(");\n")


def nonpp_ports(define_data):
    ports = []
    for pclass, pname, pdir, ptype in define_data['ports']:
        if pclass != 'signal':
            continue
        ports.append((pclass, pname, pdir, ptype))
    return ports


def pp_ports(define_data):
    ports = []
    for pclass, pname, pdir, ptype in define_data['ports']:
        if pclass == 'power':
            ptype = ''
        ports.append((pclass, pname, pdir, ptype))
    return ports


def outfile(cellpath, define_data, ftype='', extra='', exists=False):
    fname = define_data['name'].lower().replace('$', '_')
    if ftype:
        ftype = '.'+ftype
    outpath = os.path.join(cellpath, f'{define_data["file_prefix"]}{extra}{ftype}.v')
    if exists is None:
        pass
    elif not exists:
        #assert not os.path.exists(outpath), "Refusing to overwrite existing file:"+outpath
        print("Creating", outpath)
    elif exists:
        assert os.path.exists(outpath), "Missing required:"+outpath
    return outpath


def write_blackbox(cellpath, define_data):
    outpath = outfile(cellpath, define_data, 'blackbox')
    with open(outpath, "w+") as f:
        write_verilog_header(
            f,
            "Verilog stub definition (black box without power pins).",
            define_data)
        write_module_header(f, define_data)
        write_verilog_ports(f, nonpp_ports(define_data))
        write_verilog_parameters(f, define_data)
        write_verilog_supplies(f, define_data)
        f.write('endmodule\n')
        write_verilog_footer(f)


def write_blackbox_pp(cellpath, define_data):
    if define_data['type'] == 'cell':
        ofile = 'pp.blackbox'
    else:
        ofile = 'blackbox'
    outpath = outfile(cellpath, define_data, ofile)
    with open(outpath, "w+") as f:
        write_verilog_header(
            f,
            "Verilog stub definition (black box with power pins).",
            define_data)
        write_module_header(f, define_data)
        write_verilog_ports(f, pp_ports(define_data))
        write_verilog_parameters(f, define_data)
        f.write('endmodule\n')
        write_verilog_footer(f)


def group_ports_for_symbol(define_data, only):
    ports = []
    for pclass, pname, pdir, ptype in define_data['ports']:
        if pclass not in only:
            continue
        pg = PortGroup.classify(pname, define_data['name'])
        ports.append((pg, pclass, pname, pdir, ptype))

    ports.sort()

    pports = [None,]
    while len(ports) > 0:
        assert ports[0][0], ports[0]
        if pports[-1] and pports[-1][0].type != ports[0][0].type:
            pports.append(None)
        pports.append(ports.pop(0))

    if len(pports) == 1:
        return []

    return pports


def write_primitive(cellpath, define_data):
    assert define_data['type'] == 'primitive', define_data
    outpath = outfile(cellpath, define_data)
    table_datafile = outpath.replace('.v', '.table.tsv')
    assert os.path.exists(table_datafile), (table_data, define_data)

    table_data = list(csv.reader(open(table_datafile, 'r', newline=''), delimiter='\t'))

    with open(outpath, "w+") as f:
        write_verilog_header(
            f,
            "Verilog primitive definition.",
            define_data)

        f.write("`ifdef NO_PRIMITIVES\n")
        f.write(f'`include "./{define_data["file_prefix"]}.blackbox.v"\n')
        f.write('`else\n')

        f.write(f"primitive {define_data['verilog_name']} (")
        write_verilog_ports(f, define_data['ports'])

        if table_data[0].count(':') == 2:
            _, pname, _, _ = define_data['ports'][0]
            assert pname == 'Q', (define_data['ports'], table_data[0])
            f.write('\n    reg Q;\n')

        maxlen = [max(len(r[i]) for r in table_data if len(r) > i) for i in range(0, len(table_data[0]))]
        for i in range(0, len(maxlen)):
            if table_data[0][i] == ':':
                continue
            if maxlen[i] == 1:
                maxlen[i] += 2
            if maxlen[i] == 2:
                maxlen[i] += 1

        f.write('\n')
        f.write('    table\n')
        prefix_first = '     // '
        prefix_rest  = '        '
        for i, r in enumerate(table_data):
            if i == 0:
                f.write(prefix_first)
            else:
                f.write(prefix_rest)

            if len(r) != len(maxlen):
                f.write('// ')
                f.write(repr(r))
                continue

            for j, c in enumerate(r[:-1]):
                f.write(c.center(maxlen[j]))
                f.write(' ')

            if i == 0:
                assert r[-1] == 'Comments', (i, r)
                seek_backwards(f)
                f.write('\n')
                continue
            f.write(' ;')
            if r[-1]:
                f.write(' // ')
                f.write(r[-1])
            f.write('\n')
        f.write('    endtable\n')
        f.write('endprimitive\n')
        f.write('`endif // NO_PRIMITIVES\n')
        write_verilog_footer(f)


def write_testbench(cellpath, define_data):
    ports_by_class = defaultdict(lambda: list())
    ports_by_dir = defaultdict(lambda: list())
    for pclass, pname, pdir, ptype in define_data['ports']:
        pg = PortGroup.classify(pname, define_data['name'])
        ports_by_class[pg].append((pclass, pname, pdir, ptype))
        ports_by_dir[pdir].append((pclass, pname, pdir, ptype))

    pprint.pprint(ports_by_class)
    pprint.pprint(ports_by_dir)

    if PortGroup.CLOCK in ports_by_class and len(ports_by_class[PortGroup.CLOCK]) > 1:
        print("WARNING: Can't generate testbench for define with multiple clocks (", end="")
        print(ports_by_class[PortGroup.CLOCK], end="")
        print(")")
        return

    vfile = outfile(cellpath, define_data, exists=True)
    outpath = outfile(cellpath, define_data, 'tb')

    vfile = os.path.relpath(vfile, os.path.dirname(outpath))

    with open(outpath, "w+") as f:
        write_verilog_header(
            f,
            "Autogenerated test bench.",
            define_data)

        f.write('`include "{}"\n'.format(vfile))
        f.write('\n')

        f.write('module top();\n')
        f.write('\n')

        port_args = []


        input_port_names = []
        for pclass, pname, pdir, ptype in ports_by_dir['input']:
            if PortGroup.classify(pname, define_data['name']) == PortGroup.CLOCK:
                continue
            input_port_names.append(pname)
        maxlen = max((len(i) for i in input_port_names), default=0)
        input_port_names = [n.ljust(maxlen) for n in input_port_names]

        f.write('    // Inputs are registered\n')
        for pclass, pname, pdir, ptype in ports_by_dir['input']:
            if PortGroup.classify(pname, define_data['name']) == PortGroup.CLOCK:
                continue
            assert pdir == 'input'
            f.write("    reg {};\n".format(pname))
            port_args.append('.{0}({0})'.format(pname))
        f.write('\n');

        f.write('    // Outputs are wires\n')
        for pclass, pname, pdir, ptype in ports_by_dir['output']:
            assert pdir == 'output'
            f.write("    wire {};\n".format(pname))
            port_args.append('.{0}({0})'.format(pname))
        f.write('\n');

        f.write("""\
    initial
    begin
        // Initial state is x for all inputs.
""")
        indent = "        "
        for n in sorted(input_port_names):
            f.write(indent+"{0} = 1'bX;\n".format(n))

        f.write("\n")

        DELTA = 20
        i = 0

        # Set all the inputs to 0, one at a time
        # x -> 0
        for n in sorted(input_port_names):
            i += DELTA
            f.write(indent+"#{0:<4d} {1} = 1'b0;\n".format(i, n))

        # Set all the inputs to 1, one at a time
        # 0 -> 1
        for n in sorted(input_port_names):
            i += DELTA
            f.write(indent+"#{0:<4d} {1} = 1'b1;\n".format(i, n))

        # Set all the inputs to zero, one at a time
        # 1 -> 0
        for n in sorted(input_port_names):
            i += DELTA
            f.write(indent+"#{0:<4d} {1} = 1'b0;\n".format(i, n))

        # Set all the inputs to input, one at a time
        # 0 -> 1
        for n in reversed(sorted(input_port_names)):
            i += DELTA
            f.write(indent+"#{0:<4d} {1} = 1'b1;\n".format(i, n))

        # Set all the inputs to x, one at a time
        # 1 -> 0
        for n in reversed(sorted(input_port_names)):
            i += DELTA
            f.write(indent+"#{0:<4d} {1} = 1'bx;\n".format(i, n))

        f.write("""\
    end

""")

        if PortGroup.CLOCK in ports_by_class:
            assert len(ports_by_class[PortGroup.CLOCK]) == 1, ports_by_class

            clk_port = ports_by_class[PortGroup.CLOCK][0]
            clk_class, clk_name, clk_dir, clk_type = clk_port
            assert clk_class == 'signal', clk_port
            assert clk_dir == 'input', clk_port
            assert clk_type == '', clk_port
            port_args.append('.{0}({0})'.format(clk_name))

            f.write("""\
    // Create a clock
    reg {0};
    initial
    begin
        {0} = 1'b0;
    end

    always
    begin
        #{1} {0} = ~{0};
    end

""".format(clk_name, DELTA//4))

        f.write("""\
    {} dut ({args});

""".format(define_data['verilog_name'], args=", ".join(port_args)))

        f.write('endmodule\n')
        write_verilog_footer(f)
    pass


def write_symbol(cellpath, define_data):
    outpath = outfile(cellpath, define_data, 'symbol')

    # Group the ports to make a nice symbol
    pports = group_ports_for_symbol(define_data, ['signal'])

    with open(outpath, "w+") as f:
        write_verilog_header(
            f,
            "Verilog stub (without power pins) for graphical symbol definition generation.",
            define_data)
        write_module_header(f, define_data)
        write_verilog_symbol_ports(f, pports)
        write_verilog_parameters(f, define_data)
        write_verilog_supplies(f, define_data)
        f.write('endmodule\n')
        write_verilog_footer(f)


def write_symbol_pp(cellpath, define_data):
    if define_data['type'] == 'cell':
        ofile = 'pp.symbol'
    else:
        ofile = 'symbol'
    outpath = outfile(cellpath, define_data, ofile)

    # Group the ports to make a nice symbol
    pports = group_ports_for_symbol(define_data, ['signal', 'power'])

    with open(outpath, "w+") as f:
        write_verilog_header(
            f,
            "Verilog stub (with power pins) for graphical symbol definition generation.",
            define_data)
        write_module_header(f, define_data)
        write_verilog_symbol_ports(f, pports)
        write_verilog_parameters(f, define_data)
        f.write('endmodule\n')
        write_verilog_footer(f)


def write_verilog_wrapper(f, extra, supplies, ports, define_data):
    f.write('\n')
    f.write('`celldefine\n')
    f.write(f"module {define_data['verilog_name']}{extra} (")
    write_verilog_ports(f, pp_ports(define_data))
    write_verilog_parameters(f, define_data)
    if supplies:
        write_verilog_supplies(f, define_data)

    param_str = ''
    if define_data['parameters']:
        param_str += '#('
        param_str += " ".join('.{0}({0})'.format(p[0]) for p in define_data['parameters'])
        param_str += ') '

    ports_str = ''
    if ports:
        ports_str += ",\n        ".join('.{0}({0})'.format(p[1]) for p in ports);

    f.write(f"    {define_data['verilog_name']} cell ")
    f.write(param_str)
    f.write('(\n        ')
    f.write(ports_str)
    seek_backwards(f)
    if ports:
        f.write("\n    );\n")
    else:
        f.write(");\n")
    f.write('\n')
    f.write('endmodule\n')
    f.write('`endcelldefine\n')
    f.write('\n')


def write_size_wrapper(size, cellpath, define_data):
    outpath = os.path.join(cellpath, f'{define_data["file_prefix"]}{size.suffix}.v')
    #assert not os.path.exists(outpath), outpath
    print("Creating", outpath)

    with open(outpath, "w+") as f:
        write_verilog_header(
            f,
            f"Verilog wrapper for {define_data['name']} {str(size)}.",
            define_data)
        f.write(f'`include "{define_data["file_prefix"]}.v"\n')
        f.write('\n')
        f.write('`ifdef USE_POWER_PINS\n')
        f.write('/*********************************************************/\n')
        write_verilog_wrapper(f, size.suffix, False, pp_ports(define_data), define_data)
        f.write('/*********************************************************/\n')
        f.write('`else // If not USE_POWER_PINS\n')
        f.write('/*********************************************************/\n')
        write_verilog_wrapper(f, size.suffix, True, nonpp_ports(define_data), define_data)
        f.write('/*********************************************************/\n')
        f.write('`endif // USE_POWER_PINS\n')
        write_verilog_footer(f)


def write_verilog_cell_top(cellpath, define_data):
    outpath = outfile(cellpath, define_data, '')

    with open(outpath, "w+") as f:
        write_verilog_header(
            f,
            "Verilog top module.",
            define_data)
        f.write('`ifdef USE_POWER_PINS\n')
        f.write('\n')
        f.write('`ifdef FUNCTIONAL\n')
        f.write(f'`include "{define_data["file_prefix"]}.pp.functional.v"\n')
        f.write('`else  // FUNCTIONAL\n')
        f.write(f'`include "{define_data["file_prefix"]}.pp.behavioral.v"\n')
        f.write('`endif // FUNCTIONAL\n')
        f.write('\n')
        f.write('`else  // USE_POWER_PINS\n')
        f.write('\n')
        f.write('`ifdef FUNCTIONAL\n')
        f.write(f'`include "{define_data["file_prefix"]}.functional.v"\n')
        f.write('`else  // FUNCTIONAL\n')
        f.write(f'`include "{define_data["file_prefix"]}.behavioral.v"\n')
        f.write('`endif // FUNCTIONAL\n')
        f.write('\n')
        f.write('`endif // USE_POWER_PINS\n')
        write_verilog_footer(f)


def process(cellpath):
    print()
    print(cellpath)
    define_json = os.path.join(cellpath, 'definition.json')
    if not os.path.exists(define_json):
        print("No definition.json in", cellpath)
        return
    assert os.path.exists(define_json), define_json
    define_data = json.load(open(define_json))

    if define_data['type'] == 'cell':
        write_blackbox(cellpath, define_data)
    write_blackbox_pp(cellpath, define_data)

    if define_data['type'] == 'cell':
        write_symbol(cellpath, define_data)
    write_symbol_pp(cellpath, define_data)

    if define_data['type'] == 'cell':
        for d in cell_sizes(define_data['name'], cellpath):
            write_size_wrapper(d, cellpath, define_data)

    if define_data['type'] == 'primitive':
        write_primitive(cellpath, define_data)
        write_testbench(cellpath, define_data)

    if define_data['type'] == 'cell':
        write_verilog_cell_top(cellpath, define_data)
        write_testbench(cellpath, define_data)

    return


def main(args):
    for a in args:
        process(a)


if __name__ == "__main__":
    import doctest
    fails, _ = doctest.testmod()
    if fails>0:
        sys.exit()
    sys.exit(main(sys.argv[1:]))
