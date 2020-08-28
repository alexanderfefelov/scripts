#!/usr/bin/env bash

[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

./inspect-mounts.sh $(docker ps --format='{{.Names}}')
