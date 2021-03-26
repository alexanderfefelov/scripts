#!/usr/bin/env python3

from TP_Link_tplink_products_mib import MIB


for node in MIB['nodes']:
    print(node, MIB['nodes'][node]['oid'])
