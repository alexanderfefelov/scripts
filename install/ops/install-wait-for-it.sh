#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

wget --quiet \
  https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
  --directory-prefix=$HOME/bin
chmod +x $HOME/bin/wait-for-it.sh
