#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

wget --quiet \
  https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein \
  --output-document=$HOME/bin/lein
chmod +x $HOME/bin/lein
