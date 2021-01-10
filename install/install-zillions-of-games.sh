#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=zillions-of-games
readonly VERSION=201p
readonly STUFF=Zill$VERSION.exe
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/programs/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh

create_start_script() {
  echo wine $TARGET_DIR/Zillions.exe '"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Game;
Name=Zillions of Games
Comment=
Icon=$TARGET_DIR/zillions-of-games.png
Exec=$START_SCRIPT %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

mkdir --parents $TARGET_DIR
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://www.zillions-of-games.com/demo/download/$STUFF
  echo done

  echo -n Installing...
  wine Zill201p.exe /S /v"/qn INSTALLDIR=z:$TARGET_DIR"
  rm --force "$HOME/.local/share/applications/wine/Programs/Zillions of Games.desktop"
  cp --force $INSTALLER_DIR/zillions-of-games.png $TARGET_DIR
  create_start_script
  create_desktop_entry
  echo done
)
rm --recursive --force $TEMP_DIR
