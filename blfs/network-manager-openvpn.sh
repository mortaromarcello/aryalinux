#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="NetworkManager-openvpn"
VERSION="1.0.8"

#REQ:openvpn

URL=http://ftp.gnome.org/pub/gnome/sources/NetworkManager-openvpn/1.0/NetworkManager-openvpn-1.0.8.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-gnome &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
