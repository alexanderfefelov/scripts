#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

wget --quiet \
  https://packages.microsoft.com/keys/microsoft.asc \
  --output-document=- \
| sudo apt-key add -
wget --quiet \
  https://packages.microsoft.com/config/ubuntu/20.04/prod.list \
  --output-document=- \
| sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get -qq update
sudo apt-get -qq install mssql-tools
ln --force --symbolic /opt/mssql-tools/bin/* $HOME/bin/
