#!/usr/bin/env python3
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


import os.path
import sys
import tempfile
from collections import defaultdict


def count_chars(l):
    o = defaultdict(lambda: 0)
    for i in l:
        o[i] += 1
    if '\n' in o:
        del o['\n']
    return dict(o)


def main(argv):
    assert len(argv) == 1, argv

    fname = argv[0]
    assert fname.endswith('.rst'), fname
    assert os.path.exists(fname), fname

    output = ['',]
    with open(fname) as f:
        for l in f:
            output.append(l)
            c = count_chars(l)
            if len(c) != 1:
                continue

            header = list(c.keys())[0]
            if header not in ['-', '=', '+', '~']:
                print("Possible header?", repr(l))
                continue

            lastline = output[-2]

            if len(lastline) <= 4:
                continue

            oheader = (header * (len(lastline)-1))+'\n'
            output[-1] = oheader

    with open(fname, 'w') as f:
        f.write("".join(output[1:]))

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
