#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:x7lib
#DEP:xcb-util


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz


TARBALL=startup-notification-0.12.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998796.sh << "ENDOFFILE"
make install &&
install -v -m644 -D doc/startup-notification.txt \
    /usr/share/doc/startup-notification-0.12/startup-notification.txt
ENDOFFILE
chmod a+x 1434987998796.sh
sudo ./1434987998796.sh
sudo rm -rf 1434987998796.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "startup-notification=>`date`" | sudo tee -a $INSTALLED_LIST