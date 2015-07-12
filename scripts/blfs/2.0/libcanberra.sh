#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libvorbis
#DEP:alsa-lib
#DEP:gstreamer10
#DEP:gtk3


cd $SOURCE_DIR

wget -nc http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz


TARBALL=libcanberra-0.30.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-oss &&
make

cat > 1434987998834.sh << "ENDOFFILE"
make docdir=/usr/share/doc/libcanberra-0.30 install
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh

cat > 1434987998834.sh << "ENDOFFILE"
systemctl enable canberra-system-bootup
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libcanberra=>`date`" | sudo tee -a $INSTALLED_LIST