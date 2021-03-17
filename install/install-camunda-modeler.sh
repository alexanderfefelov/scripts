#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=camunda-modeler
readonly VERSION=4.6.0
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
  echo '<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/bpmn">
    <comment>BPMN model</comment>
    <acronym>BPMN</acronym>
    <expanded-acronym>Business Process Model and Notation</expanded-acronym>
    <glob pattern="*.bpmn"/>
    <glob pattern="*.bpmn20.xml"/>
    <sub-class-of type="application/xml"/>
    <icon name="'$MONIKER'"/>
    <root-XML namespaceURI="http://www.omg.org/spec/BPMN/20100524/MODEL" localName="definitions"/>
  </mime-type>
  <mime-type type="application/cmmn">
    <comment>CMMN model</comment>
    <acronym>CMMN</acronym>
    <expanded-acronym>Case Management Model and Notation</expanded-acronym>
    <glob pattern="*.cmmn"/>
    <sub-class-of type="application/xml"/>
    <icon name="'$MONIKER'"/>
    <root-XML namespaceURI="http://www.omg.org/spec/CMMN/20151109/MODEL" localName="definitions"/>
  </mime-type>
  <mime-type type="application/dmn">
    <comment>DMN model</comment>
    <acronym>DMN</acronym>
    <expanded-acronym>Decision Model and Notation</expanded-acronym>
    <glob pattern="*.dmn"/>
    <sub-class-of type="application/xml"/>
    <icon name="'$MONIKER'"/>
    <root-XML namespaceURI="http://www.omg.org/spec/DMN/20151101/dmn11.xsd" localName="definitions"/>
    <root-XML namespaceURI="http://www.omg.org/spec/DMN/20151101/dmn.xsd" localName="definitions"/>
  </mime-type>
</mime-info>'> $MONIKER-mime.xml
  xdg-mime install $MONIKER-mime.xml
}

install_mime_icon() {
  xdg-icon-resource install --context mimetypes --size 48 $TARGET_DIR/support/icon_48.png $MONIKER
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
  install_mime_icon
  register_mime_handlers
  echo done
)
rm --recursive --force $TEMP_DIR
