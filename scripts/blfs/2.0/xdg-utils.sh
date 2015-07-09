#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:xmlto
#DEP:lynx
#DEP:w3m
#DEP:links
#DEP:fop
#DEP:x7app


cd $SOURCE_DIR

wget -nc http://people.freedesktop.org/~rdieter/xdg-utils/xdg-utils-1.1.0-rc3.tar.gz


TARBALL=xdg-utils-1.1.0-rc3.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998831.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998831.sh
sudo ./1434987998831.sh
sudo rm -rf 1434987998831.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xdg-utils=>`date`" | sudo tee -a $INSTALLED_LIST