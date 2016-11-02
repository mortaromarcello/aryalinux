#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="breeze-gtk-theme"
DESCRIPTION="A gtk+ theme similar to the breeze KDE theme"
VERSION="SVN-`date -I`"

#REQ:git
#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

git clone https://github.com/dirruk1/gnome-breeze.git
cd gnome-breeze
find Breeze* -type f -exec sudo install -Dm644 '{}' "/usr/share/themes/{}" \;

cd $SOURCE_DIR
rm -rf gnome-breeze

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
