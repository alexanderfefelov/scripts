#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=xmind
readonly VERSION=8-update9
readonly STUFF=xmind-$VERSION-linux.zip
readonly TARGET_DIR=$HOME/programs/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh
readonly WORKSPACE=$TARGET_DIR/workspace
readonly MIME_TYPE=application/xmind

create_start_script() {
  echo $TARGET_DIR/XMind_amd64/XMind \
-configuration $TARGET_DIR/XMind_amd64/configuration \
-data $WORKSPACE \
'"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
}

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Office;
Name=XMind
Comment=
Icon=$TARGET_DIR/XMind_amd64/configuration/org.eclipse.osgi/983/0/.cp/icons/xmind.48.png
Exec=$START_SCRIPT %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

install_mime_type() { # https://www.iana.org/assignments/media-types/application/vnd.balsamiq.bmpr
  echo '<?xml version="1.0"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="'$MIME_TYPE'">
    <comment>XMind workbook</comment>
    <glob pattern="*.xmind"/>
    <sub-class-of type="application/xml"/>
    <generic-icon name="application-xml"/>
  </mime-type>
</mime-info>' > $MONIKER-mime.xml
  xdg-mime install $MONIKER-mime.xml
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
  wget --quiet https://www.xmind.net/xmind/downloads/$STUFF
  echo done

  echo -n Extracting...
  unzip -qq $STUFF -d dist
  echo done

  echo -n Installing...
  mv --force dist/* $TARGET_DIR
  create_start_script
  create_desktop_entry
  install_mime_type
  register_mime_handler
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "-Duser.language=en" >> $TARGET_DIR/XMind_amd64/XMind.ini
echo done
