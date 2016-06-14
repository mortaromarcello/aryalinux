#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:dosfstools:3.0.26

cd $SOURCE_DIR

URL=http://daniel-baumann.ch/files/software/dosfstools/dosfstools-3.0.26.tar.xz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s@PREFIX = /usr/local@PREFIX = /usr@g" Makefile
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "dosfstools=>`date`" | sudo tee -a $INSTALLED_LIST


