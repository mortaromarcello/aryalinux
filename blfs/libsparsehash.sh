#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="sparsehash_.orig"
VERSION="2.0.2"

URL=http://archive.ubuntu.com/ubuntu/pool/universe/s/sparsehash/sparsehash_2.0.2.orig.tar.gz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
