#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#REQ:lightdm


cd $SOURCE_DIR

wget -nc https://launchpad.net/lightdm-gtk-greeter/2.0/2.0.1/+download/lightdm-gtk-greeter-2.0.1.tar.gz


TARBALL=lightdm-gtk-greeter-2.0.1.tar.gz
DIRECTORY=lightdm-gtk-greeter-2.0.1

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --disable-liblightdm-qt &&
make "-j`nproc`"

cat > 1434987998845.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lightdm-gtk-greeter=>`date`" | sudo tee -a $INSTALLED_LIST
