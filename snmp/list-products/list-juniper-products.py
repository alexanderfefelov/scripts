#!/usr/bin/env python3


from mibs.Juniper_mib_jnx_chas_defines_txt import MIB


product_oid = MIB['nodes']['jnxProductName']['oid']
products = [x for x in MIB['nodes'] if MIB['nodes'][x]['oid'].startswith(product_oid + '.')]
for node in products:
    print(node, MIB['nodes'][node]['oid'])
