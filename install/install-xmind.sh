#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=xmind
readonly VERSION=8-update9
readonly STUFF=xmind-$VERSION-linux.zip
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/programs/$MONIKER
readonly START_SCRIPT=$TARGET_DIR/start-$MONIKER.sh
readonly WORKSPACE=$TARGET_DIR/workspace
readonly MIME_TYPE=application/xmind

create_start_script() {
  echo PATH=\$GRAALVM_8_HOME/bin:\$PATH $TARGET_DIR/XMind_amd64/XMind '"$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
}

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Office;
Name=XMind
Comment=
Icon=$TARGET_DIR/$MONIKER.png
Exec=$START_SCRIPT %u
Terminal=false" > $HOME/.local/share/applications/$MONIKER.desktop
}

install_mime_type() { # https://www.iana.org/assignments/media-types/application/vnd.balsamiq.bmpr
  echo '<?xml version="1.0"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="'$MIME_TYPE'">
    <comment>XMind workbook</comment>
    <glob pattern="*.xmind"/>
    <icon name="'$MONIKER'"/>
    <sub-class-of type="application/xml"/>
  </mime-type>
</mime-info>' > $MONIKER-mime.xml
  xdg-mime install $MONIKER-mime.xml
}

install_mime_icon() {
  xdg-icon-resource install --context mimetypes --size 48 $TARGET_DIR/$MONIKER.png $MONIKER
}

register_mime_handler() {
  xdg-mime default $MONIKER.desktop $MIME_TYPE
}

create_config_file() {
  echo "-configuration
$TARGET_DIR/XMind_amd64/configuration
-data
$WORKSPACE
-startup
$TARGET_DIR/plugins/org.eclipse.equinox.launcher_1.3.200.v20160318-1642.jar
--launcher.library
$TARGET_DIR/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.1.400.v20160518-1444
--launcher.defaultAction
openFile
--launcher.GTK_version
2
-eclipse.keyring
@user.home/.xmind/secure_storage_linux
-vmargs
-Dfile.encoding=UTF-8
-Duser.language=en" > $TARGET_DIR/XMind_amd64/XMind.ini
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
  cp --force $INSTALLER_DIR/$MONIKER.png $TARGET_DIR
  create_start_script
  create_desktop_entry
  install_mime_type
  install_mime_icon
  register_mime_handler
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
create_config_file
echo done
