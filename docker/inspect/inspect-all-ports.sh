#!/usr/bin/env bash

[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

./inspect-ports.sh $(docker ps --format='{{.Names}}')
