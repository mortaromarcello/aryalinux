#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/libpng/libpng-1.6.16.tar.xz
wget -nc http://downloads.sourceforge.net/libpng-apng/libpng-1.6.16-apng.patch.gz


TARBALL=libpng-1.6.16.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

gzip -cd ../libpng-1.6.16-apng.patch.gz | patch -p1

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998766.sh << "ENDOFFILE"
make install &&
mkdir -v /usr/share/doc/libpng-1.6.16 &&
cp -v README libpng-manual.txt /usr/share/doc/libpng-1.6.16
ENDOFFILE
chmod a+x 1434987998766.sh
sudo ./1434987998766.sh
sudo rm -rf 1434987998766.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libpng=>`date`" | sudo tee -a $INSTALLED_LIST