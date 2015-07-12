#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libogg


cd $SOURCE_DIR

wget -nc http://downloads.us.xiph.org/releases/speex/speex-1.2rc2.tar.gz
wget -nc http://downloads.us.xiph.org/releases/speex/speexdsp-1.2rc3.tar.gz


TARBALL=speex-1.2rc2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speex-1.2rc2 &&
make

cat > 1434987998837.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998837.sh
sudo ./1434987998837.sh
sudo rm -rf 1434987998837.sh

cd ..                          &&
tar -xf speexdsp-1.2rc3.tar.gz &&
cd speexdsp-1.2rc3             &&

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/speexdsp-1.2rc3 &&
make

cat > 1434987998837.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998837.sh
sudo ./1434987998837.sh
sudo rm -rf 1434987998837.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "speex=>`date`" | sudo tee -a $INSTALLED_LIST