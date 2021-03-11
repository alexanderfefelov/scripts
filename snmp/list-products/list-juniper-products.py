#!/usr/bin/env python3

from Juniper_mib_jnx_chas_defines_txt import MIB


for node in MIB['nodes']:
    print(node, MIB['nodes'][node]['oid'])
