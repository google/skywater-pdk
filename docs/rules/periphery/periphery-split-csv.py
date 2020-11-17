#!/usr/bin/env python3

from __future__ import print_function


import csv
import os
import re
import textwrap

from tabulate import tabulate
import enum
from typing import List, Tuple
from dataclasses import dataclass, field, asdict


def filesafe_template(s):
    s = s.replace('(', '')
    s = s.replace(')', '')
    s = s.replace(' ', '_')
    s = s.replace('/', '')
    s = s.replace('.-', '_dotdash')
    return s


class RuleFlags(enum.Enum):
    """

    Note: some rules contain correction factors to compensate possible mask
    defect and unpredicted process biases)
    """

    P   = u'Rule applies to periphery only (outside :drc_tag:`areaid.ce`). A corresponding core rule may or may not exist.'
    NE  = u'Rule not checked for esd_nwell_tap. There are no corresponding rule for esd_nwell_tap.'
    NC  = u'Rule not checked by DRC. It should be used as a guideline only.'
    TC  = u'Rule not checked for cell name "*_tech_CD_top*"'
    A   = u'Rule documents a functionality implemented in CL algorithms and may not be checked by DRC.'
    AD  = u'Rule documents a functionality implemented in CL algorithms and checked by DRC.'
    DE  = u'Rule not checked for source of Drain Extended device'
    LVS = u'Rule handled by LVS'
    F   = u'Rule intended for Frame only, not checked inside Die'
    DNF = u'Drawn Not equal Final. The drawn rule does not reflect the final dimension on silicon. See table J for details.'
    RC  = u'Recommended rule at the chip level, required rule at the IP level.'
    RR  = u'Recommended rule at any IP level'
    AL  = u'Rules applicable only to Al BE flows'
    CU  = u'Rules applicable only to Cu BE flows'
    IR  = u'IR drop check compering Al database and slotted Cu database for the same product (2 gds files) must be clean'

    EXEMPT = u'Rule is an exception?'


@dataclass
class Rule:
    name: str = ''
    description: str = ''
    flags: Tuple[RuleFlags] = field(default_factory=tuple)
    value: str = ''
    unit: str = ''

@dataclass
class RuleTable:
    fname: str = ''
    order: int = -1
    template: str = ''
    name: str = ''
    description: str = ''
    image: str = ''
    rules: List[Rule] = field(default_factory=list, repr=False)
    enabled: bool = True
    notes: str = ''

    @property
    def csv_fname(self):
        return 'p{:03d}-{}.csv'.format(self.order, self.fname)


data = [[]]
for l in open('periphery.csv', encoding='utf8'):
    if '.-)' in l:
        data.append([])

    only_comma = True
    for i in l:
        if i not in ' ,\n':
            only_comma = False
            break
    if only_comma:
        continue
    data[-1].append(l)

no_pics = [
    'p024-hvtr_dotdash.svg',
    'p033-licon_dotdash.svg',
    'p042-via3_dotdash.svg',
    'p043-nsm_dotdash.svg',
    'p044-m5_dotdash.svg',
    'p044-via4_dotdash.svg',
    'p045-pad_dotdash.svg',
    'p045-rdl_dotdash.svg',
    'p053-hv_dotdash_dotdash.svg',
    'p055-uhvi_dotdash_dotdash.svg',
    'p055-ulvt-_dotdash.svg',
    'p055-vhvi_dotdash_dotdash.svg',
]

image_files = {}
image_location = {}
image_re = re.compile('p([0-9][0-9][0-9])-([^.]*)\.svg')
for i in sorted(os.listdir('.')+no_pics):
    if not i.endswith('.svg'):
        continue
    page, name = image_re.match(i).groups()
    page = int(page, 10)
    if name in image_files:
        assert page-1 == image_location[name], (name, i, image_files[name], page, image_location[name])
    if i not in no_pics:
        image_files[name] = i
    image_location[name] = page


rule_tables = []
for d in data[1:]:
    rows = list(csv.reader(d))

    rule_template, rule_name, a, process = rows.pop(0)
    rule_template = rule_template.strip()
    rule_name = rule_name.strip()
    a = a.strip()
    process = process.strip()
    assert a == '', (d[0], a)
    assert process in ('sky130', ''), process

    image_name = filesafe_template(rule_template)

    if 'High Voltage' in rule_name and not 'hv' in rule_template:
        rule_template = rule_template.replace('(', '(hv')

    # Extract the function line (if it exists)
    func = 'Function: Defines '+rule_name+' (FIXME)'
    if rows[0][1].startswith('Function:'):
        a, func, b, c = rows.pop(0)
        assert a == '', a
        assert b == '', b
        assert c == '', c

    # Strip off the notes
    notes = []
    for i, r in enumerate(rows):
        if r[0] not in ('Note', ''):
            break
        if r[1] == '':
            assert r[2] == '', (r[2], rule_name, i, r)
            assert r[3] == 'NA', (r[3], rule_name, i, r)
            continue
        assert r[1] != '', (r[1], rule_name, i, r)
        assert r[2] == '', (r[2], rule_name, i, r)
        assert r[3] == '', (r[3], rule_name, i, r)
        notes.append(r[1])
    rows = rows[i:]

    # Strip off the flags table
    should_strip_flags = False
    for i, r in enumerate(rows):
        if r[0] == 'Use' and r[1] == 'Explanation':
            should_strip_flags = True
            break
    if should_strip_flags:
        rows = rows[:i]

    # Remove rows with Section in the first column
    rows = [r for r in rows if not r[0].startswith('Section ')]

    # Join together description which span multiple rows.
    continued_index = []
    for i, row in enumerate(rows):
        if row[0] == '':
            continued_index.append(i)
    for i in reversed(continued_index):
        previous_row = rows[i-1]
        l = rows[i]
        a, extra, b, c = rows.pop(i)
        assert a.strip() == '', (a, l)
        assert b.strip() in ('', previous_row[2]), (b, l, previous_row)
        assert c.strip() in ('', 'NA', 'N/A', previous_row[3]), (c, l, previous_row)
        if extra.strip() == '':
            continue
        previous_row[1] += '\n'+extra

    # Calculate the actual rule name.
    pr = None
    values = []
    for r in rows:
        values.append(r[-1])

        if r[0].startswith('.'):
            r[0] = rule_template.replace('.-.-', r[0])
        elif r[0].strip() == '':
            r[0] = pr[0]
        else:
            r[0] = rule_template.replace('.-', '.'+r[0], 1)
        pr = r

    rt = RuleTable()
    rt.template = rule_template
    rt.fname = filesafe_template(rule_template)
    rt.name = rule_name
    rt.description = func

    if notes:
        rt.notes = "\n\n".join(notes)

    if rt.fname in image_files:
        rt.image = image_files[rt.fname]
    if rt.fname in image_location:
        rt.order = image_location[rt.fname]

    # Check for all the rules having Not Applicable values
    if len(values) == len([v for v in values if v in ('NA', 'N/A')]):
        rt.enabled = False

    for r in rows:
        assert len(r) == 5, r

        if r[0] == 'Use' and r[1] == 'Explanation':
            break

        rc = Rule()
        rc.name = r[0]
        rc.description = r[1].strip()
        flags = [getattr(RuleFlags, f.upper().replace(',', '')) for f in r[2].strip().split()]
        if r[3] == 'NC':
            flags.append(RuleFlags.NC)
            r[3] = ''
        rc.flags = tuple(flags)
        rc.value = r[3]
        rc.unit  = r[4].strip()
        rt.rules.append(rc)

    if rule_tables:
        assert rt.order >= rule_tables[-1].order, "{} >= {}\n{}\n{}\n".format(rt.order, rule_tables[-1].order, rt, rule_tables[-1])
    rule_tables.append(rt)
    continue


PERIPHERY_RULES_FILE = os.path.join('..', 'periphery-rules.rst')

rst = open(PERIPHERY_RULES_FILE, 'w', encoding='utf8')

rst.write("""\
.. Do **not** modify this file it is generated from the periphery.csv file
   found in the periphery directory using the
   ./periphery/periphery-split-csv.py script. Instead run `make
   rules/periphery-rules.rst` in the ./docs directory.

.. list-table::
   :header-rows: 1
   :stub-columns: 1
   :widths: 10 75

   * - Use
     - Explanation
""")
for e in RuleFlags:
    rst.write("""\
   * -
       .. _{e.name}:

       :drc_flag:`{e.name}`

     - {e.value}
""".format(e=e))


for rt in rule_tables:

    rst.write("""\

:drc_rule:`{rt.template}`
{hd}

""".format(rt=rt, hd='-'*(len(rt.template)+len(':drc_rule:``'))))

    if rt.notes:
        rst.write("""\
.. note::

{}


""".format(textwrap.indent(rt.notes, prefix='    ')))

    headers = ('Name', 'Description', 'Flags', 'Value', 'Unit')
    headers_fmt = (':drc_rule:`Name`', 'Description', ':drc_flag:`Flags`', 'Value', 'Unit')

    rst.write("""\
.. list-table:: {rt.description}
   :header-rows: 1
   :stub-columns: 1
   :widths: 9 73 6 6 6

   * - {h}
""".format(rt=rt,h='\n     - '.join(headers_fmt)))


    for r in rt.rules:
        f = ' '.join(':drc_flag:`{}`'.format(f.name) for f in r.flags)
        if '\\n- ' in r.description: # bullet list description
            r.description = r.description.replace('\\n- ','\n  - ')
        elif '\\n' in r.description: # multi line description
            r.description = '\n'.join( [ '| '+l for l in r.description.split('\\n') ] )
        else:
            r.description = r.description.lstrip(' -') # one item bullet list to text
        d = textwrap.indent(r.description, prefix='       ').strip()
        rst.write("""\
   * - :drc_rule:`{r.name}`
     - {d}
     - {f}
     - {r.value}
     - {r.unit}
""".format(r=r, d=d, f=f))

    rst.write('\n\n')

    with open(rt.csv_fname, 'w', newline='', encoding='utf8') as f:
        w = csv.DictWriter(f, headers, lineterminator='\n')
        w.writeheader()
        for r in rt.rules:
            d = {f: getattr(r, f.lower()) for f in headers}
            d['Flags'] = ' '.join(f.name for f in d['Flags'])
            w.writerow(d)

    if rt.image:
        rst.write("""\
.. figure:: {image_file}
    :width: 100%
    :align: center


""".format(image_file=os.path.join('periphery', rt.image)))

rst.close()

with open(PERIPHERY_RULES_FILE, encoding='utf8') as f:
    print(f.read())

