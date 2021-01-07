#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  wget --quiet \
    https://packages.microsoft.com/keys/microsoft.asc \
    --output-document=- \
  | apt-key add -
  sudo bash -c 'echo "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt-get -qq update
  sudo apt-get -qq install code

  git clone https://github.com/alexanderfefelov/my-vscode-ext-pack.git
  cd my-vscode-ext-pack
  ./install.sh
)
rm --recursive --force $TEMP_DIR
