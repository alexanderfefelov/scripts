#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=yed
readonly VERSION=3.20.1
readonly STUFF=yEd-$VERSION.zip
readonly TARGET_DIR=$HOME/programs/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh
readonly MIME_TYPE=application/graphml

create_start_script() {
  echo java -jar $TARGET_DIR/yed.jar '"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
}

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Office;
Name=yEd
Comment=
Icon=$TARGET_DIR/icons/yed48.png
Exec=$START_SCRIPT %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

install_mime_type() { # https://www.iana.org/assignments/media-types/application/vnd.balsamiq.bmpr
  echo '<?xml version="1.0"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="'$MIME_TYPE'">
    <comment>GraphML</comment>
    <glob pattern="*.graphml"/>
    <sub-class-of type="application/xml"/>
    <icon name="'$MONIKER'"/>
  </mime-type>
</mime-info>' > $MONIKER-mime.xml
  xdg-mime install $MONIKER-mime.xml
}

install_mime_icon() {
  xdg-icon-resource install --context mimetypes --size 48 $TARGET_DIR/icons/yed48.png $MONIKER
}

register_mime_handler() {
  xdg-mime default $MONIKER.desktop $MIME_TYPE
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
  wget --quiet https://yworks.com/resources/yed/demo/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF
  echo done

  echo -n Installing...
  mv --force yed-$VERSION/* $TARGET_DIR
  create_start_script
  create_desktop_entry
  install_mime_type
  install_mime_icon
  register_mime_handler
  echo done
)
rm --recursive --force $TEMP_DIR
