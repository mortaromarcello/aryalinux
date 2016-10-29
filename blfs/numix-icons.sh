#!/bin/bash
set -e
set +h

#REQ:git

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

git clone https://github.com/numixproject/numix-icon-theme.git
DIRECTORY="numix-icon-theme"
cd $DIRECTORY

sudo cp -r Numix /usr/share/icons
sudo cp -r Numix-Light /usr/share/icons

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
