#!/usr/bin/env python3

from datetime import datetime
from landscape.lib.process import ProcessInformation


info = ProcessInformation()
for process_info in info.get_all_process_info():
    if process_info['state'] == b'Z':
        print(process_info['pid'], process_info['name'], datetime.fromtimestamp(process_info['start-time']))
