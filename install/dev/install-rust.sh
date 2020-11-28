#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

readonly MONIKER=rust

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR

  echo -n Downloading...
  wget --quiet --output-document rustup-init.sh https://sh.rustup.rs
  echo done

  echo -n Installing...
  bash rustup-init.sh -y --no-modify-path
  echo done
)
rm --recursive --force $TEMP_DIR

echo -n Configuring...
echo "export PATH=\$HOME/.cargo/bin:\$PATH" > $HOME/.profile.d/$MONIKER.sh
echo done
