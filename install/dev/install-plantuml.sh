#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=plantuml
readonly VERSION=1.2021.5
readonly STUFF=plantuml.$VERSION.jar
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/dev/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh

create_start_script() {
  echo java -jar $TARGET_DIR/$STUFF '"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
}

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Development;
Name=PlantUML
Comment=
Icon=$TARGET_DIR/plantuml.png
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
  wget --quiet https://downloads.sourceforge.net/project/plantuml/$VERSION/$STUFF
  echo done

  echo -n Installing...
  mv --force $STUFF $TARGET_DIR
  cp --force $INSTALLER_DIR/plantuml.png $TARGET_DIR
  create_start_script
  create_desktop_entry
  echo done
)
rm --recursive --force $TEMP_DIR
