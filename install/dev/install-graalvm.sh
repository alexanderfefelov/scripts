#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=graalvm
readonly VERSION=21.0.0
readonly BASE_8=graalvm-ce-java8
readonly BASE_11=graalvm-ce-java11
readonly STUFF_8=$BASE_8-linux-amd64-$VERSION.tar.gz
readonly STUFF_11=$BASE_11-linux-amd64-$VERSION.tar.gz
readonly INSTALLER_DIR=$(dirname "$(realpath "$0")")
readonly TARGET_DIR=$HOME/dev/$MONIKER

create_desktop_entry() { # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
  echo "[Desktop Entry]
Type=Application
Categories=Development;
Name=VisualVM
Comment=
Icon=$TARGET_DIR/visualvm.ico
Exec=$TARGET_DIR/default-11/bin/jvisualvm
Terminal=false" > $HOME/.local/share/applications/visualvm.desktop
}

if [ -d "$TARGET_DIR" ]; then
  echo Directory exists: $TARGET_DIR >&2
  exit 1
fi

mkdir --parents $TARGET_DIR
readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  for java_version in 8 11; do
    BASE=BASE_$java_version
    STUFF=STUFF_$java_version

    echo -n Downloading GraalVM $java_version...
    wget --quiet https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$VERSION/${!STUFF}
    echo done

    echo -n Extracting GraalVM $java_version...
    tar --extract --gzip --file=${!STUFF}
    echo done

    echo -n Installing GraalVM $java_version...
    mv --force ${!BASE}-$VERSION $TARGET_DIR
    echo done

    echo -n Configuring GraalVM $java_version...
    ln --symbolic $TARGET_DIR/${!BASE}-$VERSION $TARGET_DIR/default-$java_version
    echo done
  done
)
rm --recursive --force $TEMP_DIR

echo -n Installing...
cp --force $INSTALLER_DIR/visualvm.ico $TARGET_DIR
create_desktop_entry
echo done

echo -n Configuring...
echo "export GRAALVM_8_HOME=$TARGET_DIR/default-8
export GRAALVM_11_HOME=$TARGET_DIR/default-11

export JAVA_HOME=\$GRAALVM_11_HOME
export PATH=\$JAVA_HOME/bin:\$PATH" > $HOME/.profile.d/$MONIKER.sh
echo done
