#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.carisma.slowglass.com/~tgr/libnl/files/libnl-3.2.25.tar.gz
wget -nc http://www.carisma.slowglass.com/~tgr/libnl/files/libnl-doc-3.2.25.tar.gz


TARBALL=libnl-3.2.25.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make

cat > 1434987998784.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998784.sh
sudo ./1434987998784.sh
sudo rm -rf 1434987998784.sh

cat > 1434987998784.sh << "ENDOFFILE"
mkdir -vp /usr/share/doc/libnl-3.2.25 &&
tar -xf ../libnl-doc-3.2.25.tar.gz --strip-components=1 --no-same-owner \
        -C /usr/share/doc/libnl-3.2.25
ENDOFFILE
chmod a+x 1434987998784.sh
sudo ./1434987998784.sh
sudo rm -rf 1434987998784.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libnl=>`date`" | sudo tee -a $INSTALLED_LIST