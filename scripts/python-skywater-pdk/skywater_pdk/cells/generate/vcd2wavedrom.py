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

''' VCD waveform to wawedrom script/SVG conversion script.
'''

from __future__ import print_function
import os
import sys
import argparse
import pathlib
import wavedrom
import re
from contextlib import contextmanager


wavedrom_template ="""\
{{ signal: [
{signals}
]}}"""

signal_template = "   {{ name: \"{name}\", {fill}wave: '{wave}' }}"

def eprint(*args, **kwargs):
    ''' Print to stderr '''
    print(*args, file=sys.stderr, **kwargs)

@contextmanager
def file_or_stdout(file):
    ''' Open file or stdout if file is None
    '''
    if file is None:
        yield sys.stdout
    else:
        with file.open('w') as out_file:
            yield out_file


def readVCD (file):
    ''' Parses VCD file.

    Args:
        file - path to a VCD file [pathlib.Path]

    Returns:
        vcd  - dictionary containing vcd sections [dict]
    '''
    eprint()
    eprint(file.name)
    assert file.is_file(), file

    vcd = {}
    with file.open('r') as f:
        currtag = 'body'
        for line in f:
            # regular line
            if not line.startswith('$'):
                vcd[currtag] = vcd.setdefault(currtag, '') + line
                continue
            # tag, other than end
            if not line.startswith('$end'):
                currtag = line.partition(' ')[0].lstrip('$').rstrip()
                vcd[currtag] = vcd.setdefault(currtag, '') + line.partition(' ')[2].rpartition('$')[0]
            # line ends with end tag
                if not vcd[currtag].endswith('\n'):
                     vcd[currtag] += '\n'
            if line.split()[-1]=='$end':
                currtag = 'body'
                vcd[currtag] = ''

    if 'var' not in vcd:
      raise SyntaxError("No variables recorded in VCD file")
    if 'dumpvars' not in vcd:
      print ("Warning: intial variable states undefined")
      var['dumpvars'] = ''

    return vcd


def reduce_clock_sequences (wave) :
    ''' Remove clock seqnces longer than 2 cycles
        not accompanied by other signals changes

    Parameters:
        wave - dictionary 'signal'->['list of states'] [dict]
    '''
    for v in wave:
        sig   = wave[v] # analized signal
        other = [wave[i] for i in wave if i!=v] # list of other signals
        other = [''.join(s) for s in zip(*other)]  # list of concatenated states
        other = [len(s.replace('.','')) for s in other] # list of state changes count
        sig   = [s if o==0 else ' ' for s,o in zip(sig,other)] # keep only when no changes in other
        sig   = "".join(sig)
        cuts  = []
        for m in re.finditer("(10){2,}",sig):
            cuts.append( (m.start()+1, m.end()-1) ) # area to be reduced, leave 1..0
        cuts.reverse()
        for cut in cuts:
            for v,w in wave.items():              # reduce cuts from all signals
                wave[v] = w[ :cut[0]] + w[cut[1]: ]

    return wave


def parsetowavedrom (file, savetofile = False, reduce_clock = False):
    ''' Reads and simplifies VCD waveform
        Generates wavedrom notation.

    Args:
        file - path to a VCD file [pathlib.Path]

    '''
    varsubst = {} # var substitution
    reg    = []   # list of signals
    wire   = []   # list of signals (wire class)
    wave   = {}   # waveform
    event  = []   # event timings

    vcd = readVCD (file)

    # parse vars
    for line in vcd['var'].split('\n'):
        line = line.strip().split()
        if len(line)<4:
            if len(line):
                print (f"Warning: malformed var definition {' '.join(line)}")
            continue
        if line[1]!='1':
            print (f"Warning: bus in vars (unsupported)  {' '.join(line)}")
        if line[0]=='reg':
            reg.append(line[3])
            varsubst[line[2]] = line[3]
        if line[0]=='wire':
            wire.append(line[3])
            varsubst[line[2]] = line[3]

    # set initial states
    event.append(0)
    #default
    for v in reg+wire:
        wave[v] = ['x']
    #defined
    for line in vcd['dumpvars'].split('\n'):
        if len(line)>=2:
            wave[ varsubst[line[1]] ] = [line[0]]

    # parse wave body
    for line in vcd['body'].split('\n'):
        #timestamp line
        if line.startswith('#'):
            line = line.strip().lstrip('#')
            if not line.isnumeric():
                raise SyntaxError("Invalid VCD timestamp")
            event.append(int(line))
            for v in wave.keys():
                wave[v].append('.')
        # state change line
        else :
            if len(line)>=2:
                wave [ varsubst[line[1]] ][-1] = line[0]

    if reduce_clock:
        wave = reduce_clock_sequences(wave)

    signals  = []
    for v in wave.keys():
        fill    = ' ' * (max( [len(s) for s in wave.keys()] ) - len(v))
        wavestr = ''.join(wave[v])
        signals.append( signal_template.format( name = v, wave = wavestr, fill = fill ) )
    signals = ',\n'.join(signals)

    wavedrom = wavedrom_template.format ( signals = signals )

    outfile = file.with_suffix(".wdr.json") if savetofile else None
    with file_or_stdout(outfile) as f:
        f.write(wavedrom)

    return wavedrom

def quoted_strings_wavedrom (wdr) :
    ''' Convert wavedrom script to more restrictive
        version of JSON with quoted keywords

    Parameters:
        wdr - wavedrom script [str]
    '''
    wdr = wdr.replace(' signal:',' "signal":')
    wdr = wdr.replace(' name:',' "name":')
    wdr = wdr.replace(' wave:',' "wave":')
    wdr = wdr.replace("'",'"')
    return wdr

def main():
    ''' Converts VCD waveform to wavedrom format'''
    output_txt = 'output:\n  stdout or [vcdname].wdr.json file and/or [vcdname].svg file'
    allcellpath = '../../../libraries/*/latest/cells/*/*.vcd'

    parser = argparse.ArgumentParser(
            description = main.__doc__,
            epilog = output_txt,
            formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
            "--all_libs",
            help="process all in "+allcellpath,
            action="store_true")
    parser.add_argument(
            "-w",
            "--wavedrom",
            help="generate wavedrom .wdr.json file",
            action="store_true")
    parser.add_argument(
            "-s",
            "--savesvg",
            help="generate .svg image",
            action="store_true")
    parser.add_argument(
            "-r",
            "--reduceclk",
            help="reduce clock sequences",
            action="store_true")
    parser.add_argument(
            "infile",
            help="VCD waveform file",
            type=pathlib.Path,
            nargs="*")

    args = parser.parse_args()

    if args.all_libs:
        path = pathlib.Path(allcellpath).expanduser()
        parts = path.parts[1:] if path.is_absolute() else path.parts
        paths = pathlib.Path(path.root).glob(str(pathlib.Path("").joinpath(*parts)))
        args.infile = list(paths)

    infile = [d.resolve() for d in args.infile if d.is_file()]

    errors = 0
    for f in infile:
        try:
            wdr = parsetowavedrom(f, args.wavedrom, args.reduceclk)
            if args.savesvg:
                svg = wavedrom.render( quoted_strings_wavedrom(wdr) )
                outfile = f.with_suffix(".svg")
                svg.saveas(outfile)
        except KeyboardInterrupt:
            sys.exit(1)
        except (SyntaxError, AssertionError, FileNotFoundError, ChildProcessError) as ex:
            eprint (f'{type(ex).__name__}: {", ".join(ex.args)}')
            errors +=1
    eprint (f'\n{len(infile)} files processed, {errors} errors.')
    return 0 if errors else 1

if __name__ == "__main__":
    sys.exit(main())

