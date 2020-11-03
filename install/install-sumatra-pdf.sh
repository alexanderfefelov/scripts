#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=sumatra-pdf
readonly VERSION=3.1.2
readonly STUFF=SumatraPDF-$VERSION.zip
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/programs/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh
readonly EXE=SumatraPDF.exe

create_config_file() {
  echo '# https://www.sumatrapdfreader.org/settings/settings3.2.html

UiLanguage = en
EbookUI [
  # If true, the UI used for PDF documents will be used for ebooks as well (enables printing
  # and searching, disables automatic reflow)
  UseFixedPageUI = true
]' > $TARGET_DIR/SumatraPDF-settings.txt
}

create_start_script() {
  echo wine $TARGET_DIR/$EXE '"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
}

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Office;
Name=Sumatra PDF
Comment=
Icon=$TARGET_DIR/$MONIKER.ico
Exec=$START_SCRIPT %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

register_mime_types() {
  local -r MIME_TYPES="
    application/epub+zip
    application/pdf
    application/x-fictionbook+xml
    application/x-mobipocket-ebook
    image/vnd.djvu
    image/vnd.djvu+multipage
  "
  for x in $MIME_TYPES; do
    xdg-mime default $MONIKER.desktop $x
  done
}

mkdir --parents $TARGET_DIR
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet https://www.sumatrapdfreader.org/dl/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF
  echo done

  echo -n Installing...
  mv --force $EXE $TARGET_DIR
  cp --force $INSTALLER_DIR/$MONIKER.ico $TARGET_DIR
  create_config_file
  create_start_script
  create_desktop_entry
  register_mime_types
  echo done
)
rm --recursive --force $TEMP_DIR
