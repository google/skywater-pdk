#!/usr/bin/env python
import re
import sys

text = sys.stdin.read()

def fix(text, pg_pin, pg_type):
    find    = r'(pg_pin \(\"' + pg_pin + r'\"\) \{\s*\n(\s+)pg_type : \")primary_\w+(\";)\n'
    replace = r'\1' + pg_type + r'\3' + '\n' + r'\2physical_connection : device_layer;\n'
    return re.sub(find, replace, text)

def fix2(text):
    find = r'(pin \(\"M0\"\) \{\n\s+direction : \"internal\";\n\s+internal_node : \"M0\";\n\s+related_ground_pin : ")VNB(";)\n'
    replace = r'\1VGND\2\n'
    return re.sub(find, replace, text)

def fix3(text, pg_pin, pg_type):
    find    = r'(pg_pin \(\"' + pg_pin + r'\"\) \{\s*\n(\s+)pg_type : \")backup_\w+(\";)\n'
    replace = r'\1' + pg_type + r'\3' + '\n' + r'\2physical_connection : device_layer;\n'
    return re.sub(find, replace, text)

def fix4(text, cell_name , pg_pin, pg_type):
    find    = r'(cell \(\"' + cell_name + r'.*\"\) \{\s*\n)'
    replace = r'\1\t\tpg_pin ("' + pg_pin + r'") {\n\t\t\tpg_type : "' + pg_type + r'";\n\t\t\tphysical_connection : "device_layer";\n\t\t\tvoltage_name : "'+ pg_pin+r'";\n\t\t}\n'
    return re.sub(find, replace, text)

text = fix(text, 'VNB', 'nwell')
text = fix(text, 'VPB', 'pwell')
text = fix2(text)
text = fix3(text, 'VNB', 'nwell')
text = fix3(text, 'VPB', 'pwell')
text = fix4(text, 'sky130_fd_sc_hd__lpflow_lsbuf_lh_hl_isowell_tap' ,'VNB', 'nwell')
text = fix4(text, 'sky130_fd_sc_hd__lpflow_lsbuf_lh_isowell_tap' ,'VNB', 'nwell')

print(text)
