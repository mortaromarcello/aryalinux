#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:xorg-server


cd $SOURCE_DIR

wget -nc http://xorg.freedesktop.org/archive/individual/driver/xf86-video-nouveau-1.0.11.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/driver/xf86-video-nouveau-1.0.11.tar.bz2


TARBALL=xf86-video-nouveau-1.0.11.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure $XORG_CONFIG &&
make

cat > 1434987998791.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998791.sh
sudo ./1434987998791.sh
sudo rm -rf 1434987998791.sh

cat > 1434987998791.sh << "ENDOFFILE"
cat >> /etc/X11/xorg.conf.d/nvidia.conf << "EOF"
Section "Device"
 Identifier "nvidia"
 Driver "nouveau"
 Option "AccelMethod" "glamor"
EndSection
EOF
ENDOFFILE
chmod a+x 1434987998791.sh
sudo ./1434987998791.sh
sudo rm -rf 1434987998791.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "x7driver#xorg-nouveau-driver=>`date`" | sudo tee -a $INSTALLED_LIST