#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://daniel-baumann.ch/files/software/dosfstools/dosfstools-3.0.26.tar.xz
wget -nc $URL || wget -nc http://pkgs.fedoraproject.org/lookaside/pkgs/dosfstools/dosfstools-3.0.26.tar.xz/45012f5f56f2aae3afcd62120b9e5a08/dosfstools-3.0.26.tar.xz
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


