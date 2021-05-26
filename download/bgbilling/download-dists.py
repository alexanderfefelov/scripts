#!/usr/bin/env python3


import hashlib
import pathlib
import re
import sys
import urllib.request


VERSION = '8.2104'
BASE_URL_TEMPLATE = 'https://bgbilling.ru/download/{}'
COMPONENT_REGEX = re.compile(r'^name:(\S*)\s*zipName:(\S*)\s*checkSum:(\S*)\s*size:(\d*)$')


def main():
    current_url = '{}/current'.format(BASE_URL_TEMPLATE.format(VERSION))
    current = download(current_url).decode('utf-8')
    set_url = '{}/sets/{}'.format(BASE_URL_TEMPLATE.format(VERSION), current)

    component_list_url = '{}/files.dat'.format(set_url)
    components = download(component_list_url).decode('utf-8')
    for component in components.splitlines():
        match = COMPONENT_REGEX.search(component)
        if match:
            name = match.group(1)
            zip_name = match.group(2)
            check_sum = match.group(3)
            size = match.group(4)

            url = '{}/{}'.format(set_url, zip_name)
            dist = download(url)
            save(dist, zip_name)
        else:
            print('Invalid component descriptor:', component, file=sys.stderr)
            continue


def download(url):
    print('Downloading', url, end='...', flush=True)
    data = urllib.request.urlopen(url).read()
    print('done', flush=True)
    return data


def save(data, filename):
    print('Writing', filename, end='...', flush=True)
    with open(filename, 'wb') as f:
        f.write(data)
    print('done', flush=True)


if __name__ == '__main__':
    main()
