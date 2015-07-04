#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libva
#DEP:libvdpau


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/libva-intel-driver-1.5.0.tar.bz2
wget -nc http://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/libva-vdpau-driver-0.7.4.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libva-vdpau-driver-0.7.4-build_fixes-1.patch


TARBALL=libva-intel-driver-1.5.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998836.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh

patch -Np1 -i ../libva-vdpau-driver-0.7.4-build_fixes-1.patch &&
./configure --prefix=/usr &&
make

cat > 1434987998836.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libva-drivers=>`date`" | sudo tee -a $INSTALLED_LIST