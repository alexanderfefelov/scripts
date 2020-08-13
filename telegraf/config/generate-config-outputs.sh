#!/usr/bin/env bash

readonly OUTPUT_DIR=generated/outputs
readonly PATTERN1="#                            OUTPUT PLUGINS                                   #"
readonly PATTERN2="#                            PROCESSOR PLUGINS                                #"

mkdir --parents $OUTPUT_DIR
telegraf --version > $OUTPUT_DIR/telegraf.version
for x in $(telegraf --output-list | tail --lines=+2); do
  telegraf --output-filter $x config \
    | sed "0,/$PATTERN1/d" \
    | sed "/$PATTERN2/Q" \
    | tail --lines=+4 \
    | head --lines=-3 \
    > $OUTPUT_DIR/outputs.$x.conf
done
