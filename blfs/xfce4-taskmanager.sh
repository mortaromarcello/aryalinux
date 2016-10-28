#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:xfce4-taskmanager:1.0.0

URL="http://archive.xfce.org/src/apps/xfce4-taskmanager/1.0/xfce4-taskmanager-1.0.0.tar.bz2"

cd $SOURCE_DIR
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

rm -r $DIRECTORY
echo "xfce4-taskmanager=>`date`" | sudo tee -a $INSTALLED_LIST
