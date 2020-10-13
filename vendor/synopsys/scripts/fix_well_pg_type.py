#!/usr/bin/env python
import re
import sys

text = sys.stdin.read()

def fix(text, pg_pin, pg_type):
    find    = r'(pg_pin \(\"' + pg_pin + r'\"\) \{\s*\n(\s+)pg_type : \")primary_\w+(\";)\n'
    replace = r'\1' + pg_type + r'\3' + '\n' + r'\2physical_connection : device_layer;\n'
#    for m in re.findall(find, text):
#        print(m)
    return re.sub(find, replace, text)

def fix2(text):
    find = r'(pin \(\"M0\"\) \{\n\s+direction : \"internal\";\n\s+internal_node : \"M0\";\n\s+related_ground_pin : ")VNB(";)\n'
    replace = r'\1VGND\2\n'
    return re.sub(find, replace, text)


text = fix(text, 'VNB', 'nwell')
text = fix(text, 'VPB', 'pwell')
text = fix2(text)

print(text)
