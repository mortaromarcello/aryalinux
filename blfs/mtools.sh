#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf

#VER:mtools:4.0.18

cd $SOURCE_DIR

URL=ftp://ftp.gnu.org/gnu/mtools/mtools-4.0.18.tar.bz2
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

echo "mtools=>`date`" | sudo tee -a $INSTALLED_LIST


