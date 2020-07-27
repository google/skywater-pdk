#!/usr/bin/env python3

import re
import os
from pathlib import Path


RE_IMAGE = re.compile('.. (.*) image:: (.*)')
RE_INCLUDE = re.compile('.. include:: (.*)')

print('Device Details')
print('==============')
print()
for fname in sorted(Path('.').rglob('index.rst')):

    with open(fname) as f:
        data = f.read()

    dirname = os.path.split(fname)[0]

    data = RE_IMAGE.sub(r'.. \1 image:: {}/\2'.format(dirname), data)
    data = RE_INCLUDE.sub(r'.. include:: {}/\1'.format(dirname), data)
    print(data)

