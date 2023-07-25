#!/usr/bin/env python3

from pathlib import Path
from json import dumps, loads

ROOT = Path(__file__).resolve().parent / 'libraries'

def printSize(key, origSize, dumpSize):
    _GB = (1024 * 1024 * 1024)
    print(
        f'{key}:',
        origSize / _GB, 'GB',
        '->',
        dumpSize / _GB, 'GB',
        f"[{100*dumpSize/origSize}%]" if origSize != 0 else ""
    )

origSize = {}
dumpSize = {}

# For each library
for _dir in ROOT.iterdir():
    _dname = _dir.name

    # Check latest version only
    _verdir = _dir / 'latest'

    # Initialize size counters
    origSize[_dname] = 0
    dumpSize[_dname] = 0

    # For each '*.lib.json' file (recursively)
    for item in _verdir.glob('**/*.lib.json'):
        # Get and accumulate size
        origSize[_dname] += item.stat().st_size
        # Read and dump
        _dump = Path(str(item) + '.dump')
        _dump.write_text(dumps(loads(item.read_bytes())))
        # Get and accumulate dump size
        dumpSize[_dname] += _dump.stat().st_size
        # Remove dump
        _dump.unlink()

# Print summary
_GB = (1024 * 1024 * 1024)
origTotal = 0
dumpTotal = 0
for key, val in origSize.items():
    _dump = dumpSize[key]
    printSize(key, val, _dump)
    origTotal += val
    dumpTotal += _dump

printSize('Total', origTotal, dumpTotal)
