#!/usr/bin/env python3

import csv
import os
import pprint
import sys

__dir__ = os.path.dirname(os.path.abspath(__file__))

TSV_FILE = os.path.join(__dir__, "table-f2b-mask.tsv")


def main(arg):
    rows = []
    with open(TSV_FILE, newline='') as csvfile:
        reader = csv.reader(csvfile, delimiter='\t')
        for r in reader:
            rows.append(list(c.strip() for c in r))

    rowlen = max(len(r) for r in rows)
    for r in rows:
        while len(r) < rowlen:
            r.append('')

    clen = [0] * rowlen
    for i, _ in enumerate(clen):
        clen[i] = max(len(r[i]) for r in rows)

    for r in rows:
        for i, m in enumerate(clen):
            r[i] = r[i].ljust(m)

    rows.insert(1, ['-'*m for m in clen])

    for r in rows:
        print("|", " | ".join(r), "|")

    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
