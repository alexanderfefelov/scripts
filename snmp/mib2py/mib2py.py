#!/usr/bin/env python3


import os
import re
import sys
from pathlib import Path


VENDORS = [
    'D-Link',
    'MikroTik',
    'TFortis'
]
SOURCE_ROOT_DIR = 'mibs'
TARGET_ROOT_DIR = 'out/py'
LOG_ROOT_DIR = 'out/log'
CMD_TEMPLATE = re.sub('\s*\|', '', '''
    |smidump \
    |  --preload=BRIDGE-MIB \
    |  --preload=IANA-ADDRESS-FAMILY-NUMBERS-MIB \
    |  --preload=IF-MIB \
    |  --preload=INET-ADDRESS-MIB \
    |  --preload=Q-BRIDGE-MIB \
    |  --preload=SNMP-FRAMEWORK-MIB \
    |  --preload=SNMPv2-SMI \
    |  --preload=SNMPv2-TC \
    |  --format=python \
    |  --keep-going \
    |  --level=5 \
    |  {}
    |  > {}
    |  2> {}
''')


if not os.path.exists(SOURCE_ROOT_DIR):
    for vendor in VENDORS:
        vendor_dir = '{}/{}'.format(SOURCE_ROOT_DIR, vendor)
        Path(vendor_dir).mkdir(parents=True, exist_ok=True)
    sys.exit(0)


Path(TARGET_ROOT_DIR).mkdir(parents=True, exist_ok=True)
Path(LOG_ROOT_DIR).mkdir(parents=True, exist_ok=True)
for vendor in VENDORS:
    vendor_dir = '{}/{}'.format(SOURCE_ROOT_DIR, vendor)
    for dir_path, _, filenames in os.walk(vendor_dir):
        for filename in filenames:
            if filename.lower().endswith('.mib'):
                source = filename
                source_full = '{}/{}'.format(dir_path, source)
                target_base = '{}_{}'.format(dir_path.split('/')[1], filename)
                target_full = '{}/{}.py'.format(TARGET_ROOT_DIR, target_base)
                log_base = target_base
                log_full = '{}/{}.log'.format(LOG_ROOT_DIR, log_base)
                print('{} ---> {}'.format(source_full, target_full))
                cmd = CMD_TEMPLATE.format(source_full, target_full, log_full)
                os.system(cmd)
