#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:xfce4-taskmanager:1.1.0

#REQ:libwnck

KDE_PREFIX=/usr
cd $SOURCE_DIR

URL=http://archive.xfce.org/src/apps/xfce4-taskmanager/1.1/xfce4-taskmanager-1.1.0.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --enable-gtk3 &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "xfce4-taskmanager=>`date`" | sudo tee -a $INSTALLED_LIST

