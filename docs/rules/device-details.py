#!/usr/bin/env python3

import re
import os
import sys
from pathlib import Path
from pprint import pformat


RE_IMAGE = re.compile('.. (.*) image:: (.*)')
RE_INCLUDE = re.compile('.. include:: (.*)')

print('Device Details')
print('==============')
print()

def r(m):
    n = m.group(0)
    while len(n) < 10:
        n = '0'+n
    return n

def k(s):
    return re.sub('([0-9.V/]*)', r, str(s))

for fname in sorted(Path('.').rglob('index.rst'), key=k):

    with open(fname) as f:
        data = f.read()

    dirname = os.path.split(fname)[0]

    data = RE_IMAGE.sub(r'.. \1 image:: {}/\2'.format(dirname), data)
    data = RE_INCLUDE.sub(r'.. include:: {}/\1'.format(dirname), data)
    print(data)

