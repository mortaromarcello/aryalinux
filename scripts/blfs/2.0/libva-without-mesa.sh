#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libdrm
#DEP:wayland
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/vaapi/releases/libva/libva-1.5.0.tar.bz2


TARBALL=libva-1.5.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998844.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998844.sh
sudo ./1434987998844.sh
sudo rm -rf 1434987998844.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libva-without-mesa=>`date`" | sudo tee -a $INSTALLED_LIST