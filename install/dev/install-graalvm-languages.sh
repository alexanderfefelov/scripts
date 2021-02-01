#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

sudo apt-get -qq update
sudo apt-get -qq install \
  libgomp1 `# Required by R`

gu install -c org.graalvm.python
gu install -c org.graalvm.R
gu install -c org.graalvm.ruby
