#!/usr/bin/env bash

readonly OUTPUT_DIR=generated/sample-sections
readonly SECTIONS=(agent aggregators global_tags inputs outputs processors)
readonly PATTERN='# for numbers and booleans they should be plain (ie, ${INT_VAR}, ${BOOL_VAR})'

mkdir --parents $OUTPUT_DIR
telegraf --version > $OUTPUT_DIR/telegraf.version
for x in ${SECTIONS[@]}; do
  telegraf --sample-config --section-filter $x \
    | sed "0,/$PATTERN/d" \
    | tail -n +3 \
    | head -n -1 \
    > $OUTPUT_DIR/$x.conf
done
