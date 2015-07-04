#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -Wno-dev .. &&
make

cat > 1434987998800.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998800.sh
sudo ./1434987998800.sh
sudo rm -rf 1434987998800.sh


 
cd $SOURCE_DIR
 
echo "add-pkgs=>`date`" | sudo tee -a $INSTALLED_LIST