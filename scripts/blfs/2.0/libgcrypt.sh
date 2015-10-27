#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libgpg-error


cd $SOURCE_DIR

wget -nc ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.2.tar.bz2


TARBALL=libgcrypt-1.6.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998760.sh << "ENDOFFILE"
make install &&
install -v -dm755   /usr/share/doc/libgcrypt-1.6.2 &&
install -v -m644    README doc/{README.apichanges,fips*,libgcrypt*} \
                    /usr/share/doc/libgcrypt-1.6.2
ENDOFFILE
chmod a+x 1434987998760.sh
sudo ./1434987998760.sh
sudo rm -rf 1434987998760.sh

cat > 1434987998760.sh << "ENDOFFILE"
mv -v /usr/lib/libgcrypt.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libgcrypt.so) /usr/lib/libgcrypt.so
ENDOFFILE
chmod a+x 1434987998760.sh
sudo ./1434987998760.sh
sudo rm -rf 1434987998760.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libgcrypt=>`date`" | sudo tee -a $INSTALLED_LIST