#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:openexr:2.2.0

cd $SOURCE_DIR

URL="http://download.savannah.nongnu.org/releases/openexr/openexr-2.2.0.tar.gz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR

rm -rf $DIRECTORY

echo "openexr=>`date`" | sudo tee -a $INSTALLED_LIST



