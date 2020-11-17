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

import PySpice.Logging.Logging as Logging
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_V
import matplotlib.pyplot as plt
from pathlib import Path
import csv
from collections import defaultdict
import sys

logger = Logging.setup_logging()


def create_test_circuit(fet_type, iparam, fet_L, fet_W, corner_path):
    c = Circuit('gm_id')
    c.include(corner_path)

    # create the circuit
    c.V('gg', 1, c.gnd, 0@u_V)
    c.V('dd', 2, c.gnd, 1.8@u_V)
    c.X(
        'M1', fet_type, 2, 1, c.gnd, c.gnd, L=fet_L, W=fet_W, ad="'W*0.29'",
        pd="'2*(W+0.29)'", as_="'W*0.29'", ps="'2*(W+0.29)'", nrd="'0.29/W'",
        nrs="'0.29/W'", sa=0, sb=0, sd=0, nf=1, mult=1
    )
    return c


def run_sim(c, iparam, fet_W):
    sim = c.simulator()
    sim.save_internal_parameters(
        iparam % 'gm', iparam % 'id', iparam % 'gds', iparam % 'cgg'
    )

    # run the dc simulation
    an = sim.dc(Vgg=slice(0, 1.8, 0.01))

    # calculate needed values..need as_ndarray() since most of these have None
    # as the unit and that causes an error
    gm_id = (an.internal_parameters[iparam % 'gm'].as_ndarray() /
             an.internal_parameters[iparam % 'id'].as_ndarray())
    ft = (an.internal_parameters[iparam % 'gm'].as_ndarray() /
          an.internal_parameters[iparam % 'cgg'].as_ndarray())
    id_W = (an.internal_parameters[iparam % 'id'].as_ndarray() / fet_W)
    gm_gds = (an.internal_parameters[iparam % 'gm'].as_ndarray() /
              an.internal_parameters[iparam % 'gds'].as_ndarray())

    return gm_id, ft, id_W, gm_gds, an.nodes['v-sweep']


def init_plots(fet_name, W):
    figs = [plt.figure(), plt.figure(), plt.figure(), plt.figure()]
    plts = [f.subplots() for f in figs]
    figs[0].suptitle(f'{fet_name} Id/W vs gm/Id (W = {W})')
    plts[0].set_xlabel("gm/Id")
    plts[0].set_ylabel("Id/W")
    plts[0].grid(True)
    figs[1].suptitle(f'{fet_name} fT vs gm/Id (W = {W})')
    plts[1].set_xlabel("gm/Id")
    plts[1].set_ylabel("f_T")
    plts[1].grid(True)
    figs[2].suptitle(f'{fet_name} gm/gds vs gm/Id (W = {W})')
    plts[2].set_xlabel("gm/Id")
    plts[2].set_ylabel("gm/gds")
    plts[2].grid(True)
    figs[3].suptitle(f'{fet_name} gm/Id vs Vgg (W = {W})')
    plts[3].set_xlabel("Vgg")
    plts[3].set_ylabel("gm/Id")
    plts[3].grid(True)
    return figs, plts


def gen_plots(gm_id, id_W, ft, gm_gds, vsweep, fet_W, fet_L, plts):
    # plot some interesting things
    plts[0].plot(gm_id, id_W, label=f'W {fet_W} x L {fet_L}')
    plts[1].plot(gm_id, ft, label=f'W {fet_W} x L {fet_L}')
    plts[2].plot(gm_id, gm_gds, label=f'W {fet_W} x L {fet_L}')
    plts[3].plot(vsweep, gm_id, label=f'W {fet_W} x L {fet_L}')


def read_bins(fname):
    with open(fname, 'r') as f:
        r = csv.reader(f)
        # drop CSV header
        next(r)
        res = []
        for line in r:
            res.append(line)
        return res


def generate_fet_plots(
        corner_path,
        bins_csv,
        outdir,
        outprefix,
        only_W=None,
        ext='svg'):
    print(f'[generate_fet_plots] {corner_path} {bins_csv}' +
          f'{outdir} {outprefix} {only_W}')

    bins = read_bins(bins_csv)

    bins_by_W = defaultdict(list)
    # group bins by W
    for line in bins:
        bins_by_W[(line[0], float(line[2]))].append(line)

    Ws = [key for key in bins_by_W.keys() if only_W is None or key[1] in only_W]

    for fet_type, W in Ws:
        if outprefix is None:
            outprefix = fet_type
        print(f'======> {fet_type}:  {W}')
        iparam = f'@m.xm1.m{fet_type}[%s]'
        # fet_W and fet_L values here are only for initialization, they are
        # later changed in the for loop
        c = create_test_circuit(fet_type, iparam, 0.15, 1, corner_path)

        figs, plts = init_plots(fet_type, W)
        for dev, bin, fet_W, fet_L in bins_by_W[(fet_type, W)]:
            fet_W, fet_L = float(fet_W), float(fet_L)
            if only_W is not None and fet_W not in only_W:
                continue
            c.element('XM1').parameters['W'] = fet_W
            c.element('XM1').parameters['L'] = fet_L
            gm_id, ft, id_W, gm_gds, vsweep = run_sim(c, iparam, fet_W)
            gen_plots(gm_id, id_W, ft, gm_gds, vsweep, fet_W, fet_L, plts)

        figtitles = ['Id_w', 'fT', 'gm_gds', 'gm_id']
        for fg, name in zip(figs, figtitles):
            lg = fg.legend(
                bbox_to_anchor=(1.05, 1),
                loc='upper left'
            )
            fg.tight_layout()
            fg.savefig(
                Path(outdir) / (
                    outprefix + f'_{fet_type}_{name}_W{str(W).replace(".", "_")}.{ext}'),
                bbox_extra_artists=(lg,),
                bbox_inches='tight'
            )
        plt.close('all')


def main(argv):
    import argparse

    parser = argparse.ArgumentParser(prog=argv[0])
    parser.add_argument(
        'corner_path',
        help='Path to corner SPICE file containing FET definition',
        type=Path
    )
    parser.add_argument(
        'bins_csv',
        help='Path to CSV file with fet_type, bin, fet_W and fet_L parameters',
        type=Path
    )
    parser.add_argument(
        'outdir',
        help='Path to the directory to save the plots to',
        type=Path
    )
    parser.add_argument(
        '--outprefix',
        help='The prefix to add to plot file names'
    )
    parser.add_argument(
        '--only-w',
        help='Simulate the FET only for a given fet_W values',
        nargs='+',
        type=float
    )
    parser.add_argument(
        '--ext',
        help='The image extension to use for figures',
        default='svg'
    )
    args = parser.parse_args(argv[1:])

    generate_fet_plots(
        args.corner_path,
        args.bins_csv,
        args.outdir,
        args.outprefix,
        args.only_w,
        args.ext)

    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
