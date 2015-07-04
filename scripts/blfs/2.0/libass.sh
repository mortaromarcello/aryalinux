#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:freetype2
#DEP:fribidi
#DEP:fontconfig


cd $SOURCE_DIR

wget -nc https://github.com/libass/libass/releases/download/0.12.1/libass-0.12.1.tar.xz


TARBALL=libass-0.12.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998834.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libass=>`date`" | sudo tee -a $INSTALLED_LIST