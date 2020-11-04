#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=camunda-modeler
readonly VERSION=4.3.0
readonly STUFF=camunda-modeler-$VERSION-linux-x64.tar.gz
readonly TARGET_DIR=$HOME/programs/$MONIKER
readonly MIME_TYPES="
  application/bpmn
  application/cmmn
  application/dmn
"

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Office;
Name=Camunda Modeler
Comment=
Icon=$TARGET_DIR/support/icon_48.png
Exec=$TARGET_DIR/camunda-modeler %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

install_mime_types() {
  xdg-mime install $TARGET_DIR/support/mime-types.xml
}

register_mime_handlers() {
  for x in $MIME_TYPES; do
    xdg-mime default $MONIKER.desktop $x
  done
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
  wget --quiet https://downloads.camunda.cloud/release/camunda-modeler/$VERSION/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force camunda-modeler-$VERSION-linux-x64/* $TARGET_DIR
  create_desktop_entry
  install_mime_types
  register_mime_handlers
  echo done
)
rm --recursive --force $TEMP_DIR
