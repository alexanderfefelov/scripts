#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly CONFIG_DIR=$HOME/.config/opera

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  wget --quiet https://deb.opera.com/archive.key
  sudo apt-key add archive.key
  echo "deb https://deb.opera.com/opera-stable/ stable non-free" | sudo tee /etc/apt/sources.list.d/opera-stable.list > /dev/null
  sudo apt-get -qq update
  sudo apt-get -qq install opera-stable

  # https://www.reddit.com/r/operabrowser/wiki/opera/linux_libffmpeg_config
  echo -n Installing libffmpeg...
  readonly LIBFFMPEG_VERSION=0.47.2
  readonly LIBFFMPEG_STUFF=$LIBFFMPEG_VERSION-linux-x64.zip
  readonly LIBFFMPEG_TARGET_DIR=/usr/lib/x86_64-linux-gnu/opera/lib_extra
  sudo mkdir --parents $LIBFFMPEG_TARGET_DIR
  wget --quiet https://github.com/iteufel/nwjs-ffmpeg-prebuilt/releases/download/$LIBFFMPEG_VERSION/$LIBFFMPEG_STUFF
  sudo unzip -qq -uo $LIBFFMPEG_STUFF -d $LIBFFMPEG_TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR

if [ ! -d "$CONFIG_DIR" ]; then
  echo -n Configuring...
  mkdir --parents $CONFIG_DIR
  cp opera-preferences.json $CONFIG_DIR/Preferences
  cp opera-local-state.json $CONFIG_DIR/"Local State"
  echo "{}" > $CONFIG_DIR/Bookmarks
  echo done
fi
