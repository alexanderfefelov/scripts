#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=keystore-explorer
readonly VERSION=5.4.4
readonly BASE=kse-544
readonly STUFF=$BASE.zip
readonly TARGET_DIR=$HOME/programs/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh

create_start_script() {
  echo java -jar $TARGET_DIR/kse.jar '"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
}

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Utility;
Name=KeyStore Explorer
Comment=
Icon=$TARGET_DIR/icons/kse_48.png
Exec=$START_SCRIPT %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://github.com/kaikramer/keystore-explorer/releases/download/v$VERSION/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF
  echo done

  echo -n Installing...
  mv --force $BASE/* $TARGET_DIR
  create_start_script
  create_desktop_entry
  echo done
)
rm --recursive --force $TEMP_DIR
