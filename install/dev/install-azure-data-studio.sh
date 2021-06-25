#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=azure-data-studio
readonly VERSION=1.30.0
readonly STUFF=azuredatastudio-linux-$VERSION.tar.gz
readonly TARGET_DIR=$HOME/dev/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Development;
Name=Azure Data Studio
Comment=
Icon=$TARGET_DIR/resources/app/resources/linux/code.png
Exec=$TARGET_DIR/azuredatastudio
Terminal=false" > $HOME/.local/share/applications/azure-data-studio.desktop
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
  wget --quiet https://sqlopsbuilds.azureedge.net/stable/59c4b8e90cf2d3a24bed72623197f10f8d090fdc/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force azuredatastudio-linux-x64/* $TARGET_DIR
  create_desktop_entry
  echo done
)
rm --recursive --force $TEMP_DIR
