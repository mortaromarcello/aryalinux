#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="node-v"
VERSION="4.2.2"

cd $SOURCE_DIR

URL=https://nodejs.org/dist/v4.2.2/node-v4.2.2.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
