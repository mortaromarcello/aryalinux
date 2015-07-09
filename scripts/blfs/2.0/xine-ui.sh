#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:xine-lib
#DEP:shared-mime-info


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/xine/xine-ui-0.99.9.tar.xz


TARBALL=xine-ui-0.99.9.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998839.sh << "ENDOFFILE"
make docsdir=/usr/share/doc/xine-ui-0.99.9 install
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh

cat > 1434987998839.sh << "ENDOFFILE"
gtk-update-icon-cache &&
update-desktop-database
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xine-ui=>`date`" | sudo tee -a $INSTALLED_LIST