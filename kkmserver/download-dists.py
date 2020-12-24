#!/usr/bin/env python3


import hashlib
import pathlib
import re
import urllib.request


URL_DOWNLOAD_PAGE = 'https://kkmserver.ru/KkmServer'
REGEXP_VERSION = r'<a href="/Donload/{}">.*ver (\d.\d.\d\d.\d\d).*(\d\d.\d\d.\d\d\d\d)'
URL_TEMPLATE_DIST = 'https://kkmserver.ru/Donload/{}'

DIST_FILENAME_WINDOWS = 'Setup_KkmServer.exe'
OUT_FILENAME_TEMPLATE_WINDOWS = 'Setup_KkmServer_{}_{}.exe'

DIST_FILENAME_DEB = 'KkmServer.deb'
OUT_FILENAME_TEMPLATE_DEB = 'KkmServer_{}_{}.deb'


def main():
    download_page = download(URL_DOWNLOAD_PAGE).decode('utf-8')
    just_do_it(download_page, DIST_FILENAME_WINDOWS, OUT_FILENAME_TEMPLATE_WINDOWS)
    just_do_it(download_page, DIST_FILENAME_DEB, OUT_FILENAME_TEMPLATE_DEB)


def just_do_it(download_page, dist_filename, out_filename_template):
    regexp_version = REGEXP_VERSION.format(dist_filename)
    version_full = re.findall(regexp_version, download_page)[0]
    version_number = version_full[0]
    version_date = version_full[1]
    print('Found', dist_filename, version_number, version_date, flush=True)

    url_dist = URL_TEMPLATE_DIST.format(dist_filename)
    dist = download(url_dist)

    out_filename = out_filename_template.format(version_number, version_date)
    print('Writing', out_filename, end='...', flush=True)
    with open(out_filename, 'wb') as f:
        f.write(dist)
    print('done', flush=True)

    print('Calculating hash', end='...', flush=True)
    hash = hashlib.sha256(dist).hexdigest()
    print('done', flush=True)

    hash_filename = '{}.sha256'.format(out_filename)
    print('Writing', hash_filename, end='...', flush=True)
    pathlib.Path(hash_filename).write_text('{} *{}'.format(hash, out_filename))
    print('done', flush=True)


def download(url):
    print('Downloading', url, end='...', flush=True)
    data = urllib.request.urlopen(url).read()
    print('done', flush=True)
    return data


if __name__ == '__main__':
    main()
