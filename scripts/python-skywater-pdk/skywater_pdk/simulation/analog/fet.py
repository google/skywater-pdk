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


"""Module for creating FET characteristics plots from bins.csv files.

This module allows simulating FET cells and creating:

* Id/W vs gm/Id
* fT vs gm/Id
* gm/gds vs gm/Id
* gm/Id vs Vgg

plots based on different FET length and width values from bins.csv file.
"""

import PySpice.Logging.Logging as Logging
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_V
import matplotlib.pyplot as plt
from pathlib import Path
import csv
from collections import defaultdict
import os
import sys

sys.path.insert(0, os.path.abspath(__file__ + '/../../../../'))

from skywater_pdk.base import Cell

logger = Logging.setup_logging()


def create_test_circuit(fet_type, fet_L, fet_W, corner_path):
    """
    Creates a simple test circuit that contains only given FET.

    Parameters
    ----------
    fet_type: name of the FET model
    fet_L: FET length
    fet_W: FET width
    corner_path:
        path to the spice corner file with model definitions and parameters
    """
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
    """
    Runs simulation for a given circuit with FET cell.

    Parameters
    ----------
    c: circuit to simulate
    iparam:
        template string for creating internal parameter names (gm, id, gds,
        cgg) for a given FET
    fet_W: FET width
    """
    sim = c.simulator()
    sim.save_internal_parameters(
        iparam % 'gm', iparam % 'id', iparam % 'gds', iparam % 'cgg'
    )

    try:
        # run the dc simulation
        an = sim.dc(Vgg=slice(0, 1.8, 0.01))

        # calculate needed values..need as_ndarray() since most of these have
        # None as the unit and that causes an error
        gm_id = (an.internal_parameters[iparam % 'gm'].as_ndarray() /
                 an.internal_parameters[iparam % 'id'].as_ndarray())
        ft = (an.internal_parameters[iparam % 'gm'].as_ndarray() /
              an.internal_parameters[iparam % 'cgg'].as_ndarray())
        id_W = (an.internal_parameters[iparam % 'id'].as_ndarray() / fet_W)
        gm_gds = (an.internal_parameters[iparam % 'gm'].as_ndarray() /
                  an.internal_parameters[iparam % 'gds'].as_ndarray())
    except Exception:
        sim.ngspice.destroy('all')
        sim.ngspice.reset()
        raise

    sim.ngspice.destroy('all')
    sim.ngspice.reset()

    return gm_id, ft, id_W, gm_gds, an.nodes['v-sweep']


def init_plots(fet_name, W):
    """
    Initializes plots for FET bins simulation.

    Parameters
    ----------
    fet_name: name of the current FET cell
    W: FET width
    """
    figs = [plt.figure(), plt.figure(), plt.figure(), plt.figure()]
    plots = [f.subplots() for f in figs]
    figs[0].suptitle(f'{fet_name} Id/W vs gm/Id (W = {W})')
    plots[0].set_xlabel("gm/Id")
    plots[0].set_ylabel("Id/W")
    plots[0].grid(True)
    figs[1].suptitle(f'{fet_name} fT vs gm/Id (W = {W})')
    plots[1].set_xlabel("gm/Id")
    plots[1].set_ylabel("f_T")
    plots[1].grid(True)
    figs[2].suptitle(f'{fet_name} gm/gds vs gm/Id (W = {W})')
    plots[2].set_xlabel("gm/Id")
    plots[2].set_ylabel("gm/gds")
    plots[2].grid(True)
    figs[3].suptitle(f'{fet_name} gm/Id vs Vgg (W = {W})')
    plots[3].set_xlabel("Vgg")
    plots[3].set_ylabel("gm/Id")
    plots[3].grid(True)
    return figs, plots


def gen_plots(gm_id, id_W, ft, gm_gds, vsweep, fet_W, fet_L, plots):
    """
    Generates plot lines for FET bins simulation parameters.

    Parameters
    ----------
    gm_id: gm/Id values
    id_W: Id/W values
    ft: f_T values
    gm_gds: gm/gds values
    vsweep: v-sweep values
    fet_W: FET width
    fet_L: FET length
    plots: plots on which plot lines should be drawn
    """
    # plot some interesting things
    plots[0].plot(gm_id, id_W, label=f'W {fet_W} x L {fet_L}')
    plots[1].plot(gm_id, ft, label=f'W {fet_W} x L {fet_L}')
    plots[2].plot(gm_id, gm_gds, label=f'W {fet_W} x L {fet_L}')
    plots[3].plot(vsweep, gm_id, label=f'W {fet_W} x L {fet_L}')


def close_plots(figures):
    """
    Closes plots.
    """
    for figure in figures:
        plt.close(figure)


def generate_fet_plots(
        corner_path,
        bins_csv,
        outdir,
        outprefix,
        only_W=None,
        ext='svg'):
    """
    Generates FET bins plots.

    Parameters
    ----------
    corner_path: Path to FET model definitions and parameters
    bins_csv: Path to the CSV file with bin parameters and FET model names
    outdir: Directory where outputs should be stored
    outprefix: Prefix for the output plot images
    only_W: List of FET widths for which the plots should be generated
    ext: extension for plot files
    """
    print(f'[generate_fet_plots] {corner_path} {bins_csv}' +
          f'{outdir} {outprefix} {only_W}')

    bins = Cell.parse_bins(bins_csv)

    bins_by_W = defaultdict(list)
    # group bins by W
    for fetbin in bins:
        bins_by_W[(fetbin.device, fetbin.w)].append(fetbin)

    Ws = [key for key in bins_by_W.keys()
          if only_W is None or key[1] in only_W]

    for fet_type, W in Ws:
        if outprefix is None:
            outprefix = fet_type
        print(f'======> {fet_type}:  {W}')
        iparam = f'@m.xm1.m{fet_type}[%s]'
        # fet_W and fet_L values here are only for initialization, they are
        # later changed in the for loop
        c = create_test_circuit(fet_type, 0.15, 1, corner_path)

        figures, plots = init_plots(fet_type, W)
        try:
            for fetbin in bins_by_W[(fet_type, W)]:
                if only_W is not None and fetbin.w not in only_W:
                    continue
                c.element('XM1').parameters['W'] = fetbin.w
                c.element('XM1').parameters['L'] = fetbin.l
                gm_id, ft, id_W, gm_gds, vsweep = run_sim(c, iparam, fetbin.w)
                gen_plots(gm_id, id_W, ft, gm_gds, vsweep, fetbin.w, fetbin.l, plots)
        except Exception:
            close_plots(figures)
            raise

        figtitles = ['Id_w', 'fT', 'gm_gds', 'gm_id']
        for figure, name in zip(figures, figtitles):
            lg = figure.legend(
                bbox_to_anchor=(1.05, 1),
                loc='upper left'
            )
            figure.tight_layout()
            figure.savefig(
                Path(outdir) / (
                    outprefix +
                    f'_{fet_type}_{name}_W{str(W).replace(".", "_")}.{ext}'),
                bbox_extra_artists=(lg,),
                bbox_inches='tight'
            )
        close_plots(figures)


def main(argv):
    import argparse

    parser = argparse.ArgumentParser(
        prog=argv[0],
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
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
