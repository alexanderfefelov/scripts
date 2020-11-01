#!/usr/bin/env bash

# Exit immediately if a pipeline, which may consist of a single simple command,
# a list, or a compound command returns a non-zero status
set -e

# Register apt repository
eval $(apt-config shell APT_SOURCE_PARTS Dir::Etc::sourceparts/d)
CODE_SOURCE_PART=${APT_SOURCE_PARTS}vscode.list

eval $(apt-config shell APT_TRUSTED_PARTS Dir::Etc::trustedparts/d)
CODE_TRUSTED_PART=${APT_TRUSTED_PARTS}microsoft.gpg

# Sourced from https://packages.microsoft.com/keys/microsoft.asc
if [ ! -f $CODE_TRUSTED_PART ]; then
  echo "-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v1.4.7 (GNU/Linux)

mQENBFYxWIwBCADAKoZhZlJxGNGWzqV+1OG1xiQeoowKhssGAKvd+buXCGISZJwT
LXZqIcIiLP7pqdcZWtE9bSc7yBY2MalDp9Liu0KekywQ6VVX1T72NPf5Ev6x6DLV
7aVWsCzUAF+eb7DC9fPuFLEdxmOEYoPjzrQ7cCnSV4JQxAqhU4T6OjbvRazGl3ag
OeizPXmRljMtUUttHQZnRhtlzkmwIrUivbfFPD+fEoHJ1+uIdfOzZX8/oKHKLe2j
H632kvsNzJFlROVvGLYAk2WRcLu+RjjggixhwiB+Mu/A8Tf4V6b+YppS44q8EvVr
M+QvY7LNSOffSO6Slsy9oisGTdfE39nC7pVRABEBAAG0N01pY3Jvc29mdCAoUmVs
ZWFzZSBzaWduaW5nKSA8Z3Bnc2VjdXJpdHlAbWljcm9zb2Z0LmNvbT6JATUEEwEC
AB8FAlYxWIwCGwMGCwkIBwMCBBUCCAMDFgIBAh4BAheAAAoJEOs+lK2+EinPGpsH
/32vKy29Hg51H9dfFJMx0/a/F+5vKeCeVqimvyTM04C+XENNuSbYZ3eRPHGHFLqe
MNGxsfb7C7ZxEeW7J/vSzRgHxm7ZvESisUYRFq2sgkJ+HFERNrqfci45bdhmrUsy
7SWw9ybxdFOkuQoyKD3tBmiGfONQMlBaOMWdAsic965rvJsd5zYaZZFI1UwTkFXV
KJt3bp3Ngn1vEYXwijGTa+FXz6GLHueJwF0I7ug34DgUkAFvAs8Hacr2DRYxL5RJ
XdNgj4Jd2/g6T9InmWT0hASljur+dJnzNiNCkbn9KbX7J/qK1IbR8y560yRmFsU+
NdCFTW7wY0Fb1fWJ+/KTsC4=
=J6gs
-----END PGP PUBLIC KEY BLOCK-----
" | gpg --dearmor > microsoft.gpg
  sudo mv microsoft.gpg $CODE_TRUSTED_PART
fi

# Install repository source list
WRITE_SOURCE=0
if [ ! -f $CODE_SOURCE_PART ]; then
  # Write source list if it does not exist
  WRITE_SOURCE=1
elif grep -q "# disabled on upgrade to" /etc/apt/sources.list.d/vscode.list; then
  # Write source list if it was disabled by OS upgrade
  WRITE_SOURCE=1
fi
if [ "$WRITE_SOURCE" -eq "1" ]; then
  echo "### THIS FILE IS AUTOMATICALLY CONFIGURED ###
  # You may comment out this entry, but any other modifications may be lost.
  deb [arch=amd64] http://packages.microsoft.com/repos/vscode stable main" \
  | sudo tee $CODE_SOURCE_PART \
  > /dev/null
fi

sudo apt-get -qq update
sudo apt-get -qq install code

readonly TEMP_DIR=$(mktemp --directory -t delete-me-XXXXXXXXXX)
(
  cd $TEMP_DIR
  git clone https://github.com/alexanderfefelov/my-vscode-ext-pack.git
  cd my-vscode-ext-pack
  ./install.sh
)
rm --recursive --force $TEMP_DIR
