#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

NAME="numix-gtk-theme"
URL="https://github.com/numixproject/numix-gtk-theme/archive/2.6.4.tar.gz"
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`

wget -nc $URL
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL

cd $DIRECTORY
./autogen.sh --prefix=/usr
make -j4
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
