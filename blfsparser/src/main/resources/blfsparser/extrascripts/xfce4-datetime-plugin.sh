#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#REQ:libxfcegui4

KDE_PREFIX=/usr
cd $SOURCE_DIR

URL=http://archive.xfce.org/src/panel-plugins/xfce4-datetime-plugin/0.6/xfce4-datetime-plugin-0.6.1.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "xfce4-datetime-plugin=>`date`" | sudo tee -a $INSTALLED_LIST

