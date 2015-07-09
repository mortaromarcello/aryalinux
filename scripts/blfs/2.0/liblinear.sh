#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.csie.ntu.edu.tw/~cjlin/liblinear/oldfiles/liblinear-1.96.tar.gz


TARBALL=liblinear-1.96.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make lib

cat > 1434987998761.sh << "ENDOFFILE"
install -vm644 linear.h /usr/include &&
install -vm755 liblinear.so.2 /usr/lib &&
ln -sfv liblinear.so.2 /usr/lib/liblinear.so
ENDOFFILE
chmod a+x 1434987998761.sh
sudo ./1434987998761.sh
sudo rm -rf 1434987998761.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "liblinear=>`date`" | sudo tee -a $INSTALLED_LIST