#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Elevate privileges
[ $UID -eq 0 ] || exec sudo bash "$0" "$@"

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  wget --quiet https://deb.opera.com/archive.key
  apt-key add archive.key
  echo "deb https://deb.opera.com/opera-stable/ stable non-free" > /etc/apt/sources.list.d/opera-stable.list
  apt-get -qq update
  apt-get -qq install opera-stable

  # https://www.reddit.com/r/operabrowser/wiki/opera/linux_libffmpeg_config
  readonly LIBFFMPEG_VERSION=0.47.2
  readonly LIBFFMPEG_STUFF=$LIBFFMPEG_VERSION-linux-x64.zip
  readonly LIBFFMPEG_TARGET_DIR=/usr/lib/x86_64-linux-gnu/opera/lib_extra
  mkdir --parents $LIBFFMPEG_TARGET_DIR
  wget --quiet https://github.com/iteufel/nwjs-ffmpeg-prebuilt/releases/download/$LIBFFMPEG_VERSION/$LIBFFMPEG_STUFF
  unzip -qq $LIBFFMPEG_STUFF -d $LIBFFMPEG_TARGET_DIR
)
rm --recursive --force $TEMP_DIR
