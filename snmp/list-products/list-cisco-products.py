#!/usr/bin/env python3

from Cisco_CISCO_PRODUCTS_MIB_mib import MIB


for node in MIB['nodes']:
    print(node, MIB['nodes'][node]['oid'])
