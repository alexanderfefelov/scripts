#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=archi
readonly VERSION=4.8.1
readonly STUFF=Archi-Linux64-$VERSION.tgz
readonly TARGET_DIR=$HOME/dev/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Development;
Name=Archi
Comment=
Icon=$TARGET_DIR/icon.xpm
Exec=$TARGET_DIR/Archi
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
  wget --quiet --post-data="dl=$STUFF" https://www.archimatetool.com/downloads/archi/ --output-document=$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force Archi/* $TARGET_DIR
  create_desktop_entry
  echo done
)
rm --recursive --force $TEMP_DIR
