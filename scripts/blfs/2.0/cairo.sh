#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libpng
#DEP:glib2
#DEP:pixman
#DEP:fontconfig
#DEP:mesalib
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://cairographics.org/releases/cairo-1.14.0.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/cairo-1.14.0-upstream_fixes-2.patch


TARBALL=cairo-1.14.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../cairo-1.14.0-upstream_fixes-2.patch &&
./configure --prefix=/usr    \
            --enable-gl      \
            --enable-tee     \
            --disable-static &&
make

cat > 1434987998793.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cairo=>`date`" | sudo tee -a $INSTALLED_LIST