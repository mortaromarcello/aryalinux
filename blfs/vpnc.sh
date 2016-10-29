#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="vpnc"
VERSION="0.5.3r550"

URL=http://archive.ubuntu.com/ubuntu/pool/universe/v/vpnc/vpnc_0.5.3r550.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

sed -i "s@PREFIX=/usr/local@PREFIX=/usr@g" Makefile
make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
