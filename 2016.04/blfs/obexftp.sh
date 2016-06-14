#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:obexftp--Source:0.24.2

cd $SOURCE_DIR

URL="http://heanet.dl.sourceforge.net/project/openobex/obexftp/0.24.2/obexftp-0.24.2-Source.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

cmake -DCMAKE_INSTALL_PREFIX=/usr &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "obexftp=>`date`" | sudo tee -a $INSTALLED_LIST
