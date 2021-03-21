#!/usr/bin/env python3


import re
import requests
from requests.auth import HTTPDigestAuth
import sys


REGEXP_PORT_STATISTICS = r'<b>Port Statistics</b><table.*?>(.*?)</table>'
REGEXP_POE_STATUS = r'<b>PoE Status</b><table.*?>(.*?)</table>'
REGEXP_TR = r'<tr.*?>(.*?)</tr>'
REGEXP_TD = r'<td.*?>(.*?)</td>'


def process_port_info(host, username, password, port, regexp):
   url = 'http://%s/info/port_info.shtml?port=%d' % (host, port)
   response = requests.post(url, auth=HTTPDigestAuth(username, password))
   html = response.text
   table_body = re.findall(regexp, html)[0]
   process_table_body(table_body)


def process_table_body(table_body):
    for r in re.findall(REGEXP_TR, table_body):
        d = re.findall(REGEXP_TD, r)
        if not d[0]:
            column1_name = d[1]
            column2_name = d[2]
            continue
        print(d[0], column1_name, d[1])
        print(d[0], column2_name, d[2])


def abort(message):
    print(message, file=sys.stderr)
    sys.exit(1)


if __name__ == '__main__':
    command = sys.argv[1]
    host = sys.argv[2]
    username = sys.argv[3]
    password = sys.argv[4]
    if command == 'show-port-statistics':
        port = int(sys.argv[5])
        process_port_info(host, username, password, port, REGEXP_PORT_STATISTICS)
    elif command == 'show-poe-status':
        port = int(sys.argv[5])
        process_port_info(host, username, password, port, REGEXP_POE_STATUS)
    else:
        abort('Unknown command')
