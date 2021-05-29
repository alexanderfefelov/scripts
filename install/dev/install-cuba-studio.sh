#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=cuba-studio
readonly VERSION_1=15.4-202
readonly VERSION_2=2020.2-15.4
readonly STUFF=cuba-studio-$VERSION_2.tar.gz
readonly TARGET_DIR=$HOME/dev/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Development;
Name=CUBA Studio
Comment=
Icon=$TARGET_DIR/bin/cuba-studio.png
Exec=$TARGET_DIR/bin/cuba-studio.sh
Terminal=false" > $HOME/.local/share/applications/cuba-studio.desktop
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
  wget --quiet https://cdn.cuba-platform.com/cuba-studio/$VERSION_1/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force cuba-studio-*/* $TARGET_DIR
  create_desktop_entry
  echo done
)
rm --recursive --force $TEMP_DIR
