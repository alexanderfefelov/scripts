#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

wget --quiet \
  http://binaries.erlang-solutions.com/ubuntu/erlang_solutions.asc \
  --output-document=- \
| apt-key add -
echo "deb [arch=amd64] https://packages.erlang-solutions.com/ubuntu focal contrib" > /etc/apt/sources.list.d/erlang-solutions.list
apt-get -qq update
apt-get -qq install elixir
