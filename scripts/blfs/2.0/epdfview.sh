#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:poppler
#DEP:gtk2


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/sources/BLFS/conglomeration/epdfview/epdfview-0.1.8.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/epdfview-0.1.8-fixes-1.patch


TARBALL=epdfview-0.1.8.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../epdfview-0.1.8-fixes-1.patch &&
./configure --prefix=/usr &&
make

cat > 1434987998843.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "epdfview=>`date`" | sudo tee -a $INSTALLED_LIST