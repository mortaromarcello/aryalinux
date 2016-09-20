#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/galculator/galculator-2.1.3.tar.bz2/a7a333cc4c321507434fe3f8e48fcd0a/galculator-2.1.3.tar.bz2
wget -nc $URL
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


