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
  echo "deb [arch=amd64] https://packages.erlang-solutions.com/ubuntu focal contrib" > /etc/apt/sources.list.d/erlang-solutions.list
  apt-get -qq update
  apt-get -qq install esl-erlang
)
rm --recursive --force $TEMP_DIR