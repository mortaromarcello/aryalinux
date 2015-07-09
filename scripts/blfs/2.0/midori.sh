#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:libnotify
#DEP:webkitgtk2
#DEP:vala
#DEP:librsvg


cd $SOURCE_DIR

wget -nc http://www.midori-browser.org/downloads/midori_0.5.9_all_.tar.bz2


TARBALL=midori_0.5.9_all_.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir -v build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DUSE_ZEITGEIST=OFF         \
      -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/midori-0.5.9 \
      ..  &&
make

cat > 1434987998824.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998824.sh
sudo ./1434987998824.sh
sudo rm -rf 1434987998824.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "midori=>`date`" | sudo tee -a $INSTALLED_LIST