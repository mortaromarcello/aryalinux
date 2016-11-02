#!/bin/bash
set -e
set +h

#REQ:git
#REQ:numix-icons

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="numix-icons-circle"
DESCRIPTION="A beautiful flat icon theme with circular artifacts."
VERSION="SVN-`date -I`"

cd $SOURCE_DIR

git clone https://github.com/numixproject/numix-icon-theme-circle.git
DIRECTORY="numix-icon-theme-circle"
cd $DIRECTORY

sudo cp -r Numix-Circle /usr/share/icons
sudo cp -r Numix-Circle-Light /usr/share/icons

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
