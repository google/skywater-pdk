#!/usr/bin/env python3

import re
import os

RE_IMAGE = re.compile('.. (.*) image:: (.*)')
RE_INCLUDE = re.compile('.. include:: (.*)')

device_list = [
    # 1.8V MOS
    "nfet_01v8",
    "nfet_01v8_lvt",
    "pfet_01v8",
    "pfet_01v8_lvt",
    "pfet_01v8_hvt",
    "cap_var",

    # 3.3V MOS
    "nfet_03v3_nvt",

    # 5V MOS
    "nfet_05v0_nvt",
    "nfet_g5v0d10v5",
    "pfet_g5v0d10v5",
    "pfet_g5v0d16v0",

    # 11V MOS
    "nfet_g11v0d16v0",

    # 20V MOS
    "nfet_20v0",
    "nfet_20v0_nvt",
    "nfet_20v0_zvt",
    "nfet_20v0_iso",
    "pfet_20v0",

    # ESD MOS
    "esd_nfet",

    # Diodes/Bipolar
    "diodes",
    "npn_05v0",
    "pnp_05v0",

    # Special active devices
    "special_sram",
    "special_sonosfet",

    # Well/Diffusion/Poly/Metal Resistors
    "res_generic",
    "res_high",
    "res_xhigh",

    # Metal Capacitors
    "cap_mim",
    "cap_vpp",
]

print('Device Details')
print('==============')
print()

for device_name in device_list:
    fname = os.path.join("device-details", device_name, "index.rst")

    with open(fname) as f:
        data = f.read()

    dirname = os.path.split(fname)[0]

    data = RE_IMAGE.sub(r'.. \1 image:: {}/\2'.format(dirname), data)
    data = RE_INCLUDE.sub(r'.. include:: {}/\1'.format(dirname), data)
    print(data)
