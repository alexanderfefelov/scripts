#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

apt-get -qq install \
  apache2-utils `# Bcz htpasswd` \
  emacs \
  figlet \
  git \
  htop \
  httpie \
  jq \
  libtext-lorem-perl \
  mc \
  minicom \
  multitail \
  ncdu \
  nmap \
  nmon \
  openssh-server \
  pdf2djvu \
  pwgen \
  samba-common-bin `# Bcz smbpasswd` \
  snmp \
  snmp-mibs-downloader \
  smitools \
  subversion \
  toilet toilet-fonts \
  tree \
  unrar \
  uuid-runtime `# Bcz uuidgen` \
  whois `# Bcz mkpasswd` \
  \
  influxdb-client \
  mongodb-clients \
  mysql-client \
  postgresql-client \
  redis-tools
