#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://launchpad.net/libindicator/12.10/12.10.1/+download/libindicator-12.10.1.tar.gz
wget -nc http://patches.osdyson.org/patch/series/dl/libindicator/0.5.0-2+dyson1/gtk_icon_info_free-deprecated.patch


TARBALL=libindicator-12.10.1.tar.gz
DIRECTORY=libindicator-12.10.1

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../gtk_icon_info_free-deprecated.patch &&
./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998846.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998846.sh
sudo ./1434987998846.sh
sudo rm -rf 1434987998846.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libindicator=>`date`" | sudo tee -a $INSTALLED_LIST