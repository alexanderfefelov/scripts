#!/usr/bin/env bash

[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

dangling_volumes=$(docker volume ls --quiet --filter dangling=true)
if [ -z "$dangling_volumes" ]; then
  echo No dangling volumes found
else
  docker volume rm $dangling_volumes
fi
