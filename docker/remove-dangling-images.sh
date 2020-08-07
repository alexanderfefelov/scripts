#!/usr/bin/env bash

[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

dangling_images=$(docker image ls --quiet --filter dangling=true)
if [ -z "$dangling_images" ]; then
  echo No dangling images found
else
  docker image rm $dangling_images
fi
