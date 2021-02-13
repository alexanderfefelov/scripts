#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=soapui
readonly VERSION=5.6.0
readonly STUFF=SoapUI-x64-$VERSION.sh
readonly TARGET_DIR=$HOME/dev/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Development;
Name=DBeaver
Comment=
Icon=$TARGET_DIR/dbeaver.png
Exec=$TARGET_DIR/dbeaver
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
  wget --quiet https://s3.amazonaws.com/downloads.eviware/soapuios/$VERSION/$STUFF
  echo done

  echo -n Installing...
  chmod +x $STUFF
  ./$STUFF -q -dir $TARGET_DIR
  echo done
)
rm --recursive --force $TEMP_DIR
