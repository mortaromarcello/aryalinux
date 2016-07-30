#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:pillow_.orig:3.2.0

URL=http://archive.ubuntu.com/ubuntu/pool/main/p/pillow/pillow_3.2.0.orig.tar.xz

cd $SOURCE_DIR

wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar -xf $TARBALL
cd $DIRECTORY

python setup.py build &&
sudo python setup.py install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "pillow=>`date`" | sudo tee -a $INSTALLED_LIST
