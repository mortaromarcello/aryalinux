#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:gtk2


cd $SOURCE_DIR

wget -nc https://dl.hexchat.net/hexchat/hexchat-2.10.2.tar.xz


TARBALL=hexchat-2.10.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998829.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "hexchat=>`date`" | sudo tee -a $INSTALLED_LIST