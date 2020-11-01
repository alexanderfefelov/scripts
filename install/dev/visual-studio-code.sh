#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  wget --quiet https://packages.microsoft.com/keys/microsoft.asc
  sudo apt-key add microsoft.asc
  sudo add-apt-repository "deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main"
  sudo apt-get -qq update
  sudo apt-get -qq install code

  git clone https://github.com/alexanderfefelov/my-vscode-ext-pack.git
  cd my-vscode-ext-pack
  ./install.sh
)
rm --recursive --force $TEMP_DIR
