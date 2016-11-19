#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="adapta-gtk-theme"
DESCRIPTION="Adapta GTK theme"
VERSION="SVN-`date -I`"

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

wget -nc https://github.com/tista500/Adapta/archive/3.22.1.6.tar.gz

tar xf 3.22.1.6.tar.gz
cd Adapta-3.22.1.6

./autogen.sh --prefix=/usr
make -j4
sudo make install

cd $SOURCE_DIR
rm -rf Adapta-3.22.1.6

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
