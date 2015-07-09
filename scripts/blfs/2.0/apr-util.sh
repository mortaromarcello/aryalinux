#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:apr
#DEP:openssl


cd $SOURCE_DIR

wget -nc http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.bz2
wget -nc ftp://ftp.mirrorservice.org/sites/ftp.apache.org/apr/apr-util-1.5.4.tar.bz2


TARBALL=apr-util-1.5.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr       \
            --with-apr=/usr     \
            --with-gdbm=/usr    \
            --with-openssl=/usr \
            --with-crypto &&
make

cat > 1434987998755.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "apr-util=>`date`" | sudo tee -a $INSTALLED_LIST