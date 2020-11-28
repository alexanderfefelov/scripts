#!/usr/bin/env bash

mkdir --parents $HOME/bin
mkdir --parents $HOME/.local/share/applications
mkdir --parents $HOME/.profile.d

sudo cp --force .profile.d.sh /etc/profile.d/profile.d.sh

echo -------------------------------------------
echo You must relogin for changes to take effect
echo -------------------------------------------
