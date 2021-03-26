#!/usr/bin/env python3


from mibs.Extreme_EXTREME_BASE_MIB_mib import MIB


product_oid = MIB['nodes']['extremeProduct']['oid']
products = [x for x in MIB['nodes'] if MIB['nodes'][x]['oid'].startswith(product_oid + '.')]
for node in products:
    print(node, MIB['nodes'][node]['oid'])
