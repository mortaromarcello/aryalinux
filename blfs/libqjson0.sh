#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="qjson_.orig"
VERSION="0.8.1"

URL=http://archive.ubuntu.com/ubuntu/pool/universe/q/qjson/qjson_0.8.1.orig.tar.bz2

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
