#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:xarchiver:0.5.4

cd $SOURCE_DIR

URL=http://liquidtelecom.dl.sourceforge.net/project/xarchiver/xarchiver-0.5.4.tar.bz2
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "xarchiver=>`date`" | sudo tee -a $INSTALLED_LIST


