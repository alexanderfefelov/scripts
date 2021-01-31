#!/usr/bin/env python3


import datetime
import hashlib
import re
import sys


REGEX_MIB = re.compile(b'(\S*)[\s]*DEFINITIONS[\s]*::=[\s]*BEGIN([\s\S]*?)END')
TEMPLATE_OUT_FILENAME = '{}.extracted'
TEMPLATE_BEGIN = '''-- Extracted from {} (MD5: {})

{} DEFINITIONS ::= BEGIN
'''
TEMPLATE_END = '''
END

-- {}
'''

if len(sys.argv) != 2:
    print('No input file specified')
    sys.exit(1)

in_filename = sys.argv[1]
with open(in_filename, 'rb') as f:
    raw = f.read()
md5 = hashlib.md5(raw).hexdigest()
for mib in re.findall(REGEX_MIB, raw):
    name = mib[0].decode('utf-8')
    content = mib[1]
    out_filename = TEMPLATE_OUT_FILENAME.format(name)
    with open(out_filename, 'wb') as f:
        f.write(TEMPLATE_BEGIN.format(in_filename, md5, name).encode('utf-8'))
        f.write(content)
        f.write(TEMPLATE_END.format(datetime.datetime.now().astimezone().isoformat()).encode('utf-8'))
