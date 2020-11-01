#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  wget --quiet http://binaries.erlang-solutions.com/ubuntu/erlang_solutions.asc
  apt-key add erlang_solutions.asc
  add-apt-repository "deb [arch=amd64] https://packages.erlang-solutions.com/ubuntu focal contrib"
  apt-get -qq update
  apt-get -qq install elixir
)
rm --recursive --force $TEMP_DIR
