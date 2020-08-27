#!/usr/bin/env bash

[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

for c in "$@"; do
  echo $c
  docker inspect --format '{{range $data := .Mounts }}{{printf "%s %s -> %s rw=%t\n" $data.Type $data.Source $data.Destination $data.RW}}{{end}}' $c
done
