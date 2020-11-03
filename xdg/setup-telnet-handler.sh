#!/usr/bin/env bash

echo -n telnet...
if [ -z $(which telnet) ]; then
  echo not found
  exit 1
else
  echo found
fi

readonly MIME_TYPE=x-scheme-handler/telnet

readonly HANDLER_DIR=$HOME/.local/bin
readonly HANDLER_FILE=$HANDLER_DIR/.telnet-handler.sh
mkdir --parents $HANDLER_DIR
echo '#!/usr/bin/env bash
gnome-terminal -- telnet ${1#telnet://}' > $HANDLER_FILE
chmod +x $HANDLER_FILE

readonly DESKTOP_DIR=$HOME/.local/share/applications
readonly DESKTOP_FILE=$DESKTOP_DIR/.telnet-handler.desktop
echo "[Desktop Entry]
Type=Application
Exec=$HANDLER_FILE %u
NoDisplay=true" > $DESKTOP_FILE

xdg-mime default $(basename $DESKTOP_FILE) $MIME_TYPE
