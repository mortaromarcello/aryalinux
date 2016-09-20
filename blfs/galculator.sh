#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://sourceforge.net/projects/galculator/files/galculator/2.1.3/galculator-2.1.3.tar.bz2/download
wget -c $URL -O galculator-2.1.3.tar.bz2
TARBALL=galculator-2.1.3.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR
rm -rf $DIRECTORY

echo "galculator=>`date`" | sudo tee -a $INSTALLED_LIST


