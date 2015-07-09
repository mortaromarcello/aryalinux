#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl


cd $SOURCE_DIR

wget -nc http://sourceforge.net/projects/re-alpine/files/re-alpine-2.03.tar.bz2


TARBALL=re-alpine-2.03.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --without-ldap      \
            --without-krb5      \
            --with-ssl-dir=/usr \
            --with-passfile=.pine-passfile &&
make

cat > 1434987998786.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "re-alpine=>`date`" | sudo tee -a $INSTALLED_LIST