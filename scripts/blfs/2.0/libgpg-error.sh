#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.18.tar.bz2


TARBALL=libgpg-error-1.18.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998760.sh << "ENDOFFILE"
make install &&
install -v -m644 -D README /usr/share/doc/libgpg-error-1.18/README
ENDOFFILE
chmod a+x 1434987998760.sh
sudo ./1434987998760.sh
sudo rm -rf 1434987998760.sh

cat > 1434987998760.sh << "ENDOFFILE"
mv -v /usr/lib/libgpg-error.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libgpg-error.so) /usr/lib/libgpg-error.so
ENDOFFILE
chmod a+x 1434987998760.sh
sudo ./1434987998760.sh
sudo rm -rf 1434987998760.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libgpg-error=>`date`" | sudo tee -a $INSTALLED_LIST