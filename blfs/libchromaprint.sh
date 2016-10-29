#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="chromaprint_.orig"
VERSION="1.3"

#REQ:ffmpeg

URL=http://archive.ubuntu.com/ubuntu/pool/universe/c/chromaprint/chromaprint_1.3.orig.tar.gz

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
