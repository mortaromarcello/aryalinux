#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.surina.net/soundtouch/soundtouch-1.8.0.tar.gz


TARBALL=soundtouch-1.8.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed "s@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@g" -i configure.ac &&
./bootstrap &&

./configure --prefix=/usr &&
make

cat > 1434987998837.sh << "ENDOFFILE"
make pkgdocdir=/usr/share/doc/soundtouch-1.8.0 install
ENDOFFILE
chmod a+x 1434987998837.sh
sudo ./1434987998837.sh
sudo rm -rf 1434987998837.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "soundtouch=>`date`" | sudo tee -a $INSTALLED_LIST