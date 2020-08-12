#!/usr/bin/env bash

sse_support=$(cat /proc/cpuinfo | grep flags | grep --only-matching --word-regexp 'sse\S*' | sort | uniq | paste --delimiter=' ' --serial -)
if [ -z "$sse_support" ]; then
  echo No SSE support detected
else
  echo Detected SSE support for $sse_support
fi
