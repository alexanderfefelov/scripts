#!/usr/bin/env bash

[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

docker inspect --format '{{range $key, $value := .NetworkSettings.Ports }}{{if $value}}{{printf "%s:%s" (index $value 0).HostIp (index $value 0).HostPort}}{{else}}∅{{end}}{{printf " -> %s\n" $key}}{{end}}' "$1"
