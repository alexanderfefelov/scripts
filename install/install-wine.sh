#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

sudo apt-get -qq update
sudo apt-get -qq install wine

readonly TARGET_DIR=$HOME/.cache/wine
mkdir --parents $TARGET_DIR

echo -n Downloading gecko...
readonly GECKO_VERSION=2.47.1
readonly GECKO_STUFF_1=wine-gecko-$GECKO_VERSION-x86.msi
readonly GECKO_STUFF_2=wine-gecko-$GECKO_VERSION-x86_64.msi
wget --quiet --directory-prefix=$TARGET_DIR http://dl.winehq.org/wine/wine-gecko/$GECKO_VERSION/$GECKO_STUFF_1
wget --quiet --directory-prefix=$TARGET_DIR http://dl.winehq.org/wine/wine-gecko/$GECKO_VERSION/$GECKO_STUFF_2
echo done

echo -n Downloading mono...
readonly MONO_VERSION=5.1.1
readonly MONO_STUFF=wine-mono-$MONO_VERSION-x86.msi
wget --quiet --directory-prefix=$TARGET_DIR https://dl.winehq.org/wine/wine-mono/$MONO_VERSION/$MONO_STUFF
echo done

wineboot --update
