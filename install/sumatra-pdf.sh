#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly VERSION=3.1.2
readonly STUFF=SumatraPDF-$VERSION.zip

readonly TARGET_DIR=$HOME/programs/sumatra-pdf
mkdir --parents $TARGET_DIR
readonly START_SCRIPT=$TARGET_DIR/start-sumatra-pdf.sh

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
  mv --force SumatraPDF.exe $TARGET_DIR
  chmod +x $TARGET_DIR/SumatraPDF.exe
  echo 'wine "$(dirname "$(realpath "$0")")"/SumatraPDF.exe "$@"' > $START_SCRIPT
  chmod +x $START_SCRIPT
  echo done
)
rm --recursive --force $TEMP_DIR

cp --force sumatra-pdf.ico $TARGET_DIR
