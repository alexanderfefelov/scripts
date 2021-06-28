#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=android-studio
readonly VERSION=4.2.1.0
readonly BUILD=202.7351085
readonly STUFF=android-studio-ide-$BUILD-linux.tar.gz
readonly TARGET_DIR=$HOME/dev/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Development;
Name=Android Studio
Comment=
Icon=$TARGET_DIR/bin/studio.png
Exec=$TARGET_DIR/bin/studio.sh
Terminal=false" > $HOME/.local/share/applications/android-studio.desktop
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
  wget --quiet https://redirector.gvt1.com/edgedl/android/studio/ide-zips/$VERSION/$STUFF
  echo done

  echo -n Extracting...
  tar --extract --gzip --file=$STUFF
  echo done

  echo -n Installing...
  mv --force android-studio/* $TARGET_DIR
  create_desktop_entry
  echo done
)
rm --recursive --force $TEMP_DIR
