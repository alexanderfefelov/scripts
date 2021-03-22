#!/usr/bin/env python3


import re
import requests
from requests.auth import HTTPDigestAuth
import sys


REGEXP_VLANS = r'<b>VLAN List</b><br><table.*?>(.*?)</table>'
REGEXP_PORT_STATISTICS = r'<b>Port Statistics</b><table.*?>(.*?)</table>'
REGEXP_POE_STATUS = r'<b>PoE Status</b><table.*?>(.*?)</table>'
REGEXP_TR = r'<tr.*?>(.*?)</tr>'
REGEXP_TD = r'<td.*?>(.*?)</td>'


def process_vlans(host, username, password, regexp):
   url = 'http://%s/vlan/VLAN_8021q.shtml' % host
   response = requests.post(url, auth=HTTPDigestAuth(username, password))
   html = response.text
   table_body = re.findall(regexp, html)[0]
   _process_table_body_vlans(table_body[1:])


def process_port_info(host, username, password, port, regexp):
   url = 'http://%s/info/port_info.shtml?port=%d' % (host, port)
   response = requests.post(url, auth=HTTPDigestAuth(username, password))
   html = response.text
   table_body = re.findall(regexp, html)[0]
   _process_table_body_port_info(table_body[1:])


def _process_table_body_vlans(table_body):
    for r in re.findall(REGEXP_TR, table_body):
        d = re.findall(REGEXP_TD, r)
        print(d[0], d[1], d[2], d[3], d[4])


def _process_table_body_port_info(table_body):
    for r in re.findall(REGEXP_TR, table_body):
        d = re.findall(REGEXP_TD, r)
        print(d[0], d[1], d[2])


def abort(message):
    print(message, file=sys.stderr)
    sys.exit(1)


if __name__ == '__main__':
    command = sys.argv[1]
    host = sys.argv[2]
    username = sys.argv[3]
    password = sys.argv[4]
    if command == 'show-vlans':
        process_vlans(host, username, password, REGEXP_VLANS)
    elif command == 'show-port-statistics':
        port = int(sys.argv[5])
        process_port_info(host, username, password, port, REGEXP_PORT_STATISTICS)
    elif command == 'show-poe-status':
        port = int(sys.argv[5])
        process_port_info(host, username, password, port, REGEXP_POE_STATUS)
    else:
        abort('Unknown command')
