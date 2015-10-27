#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libwnck2
#DEP:libxfce4ui
#DEP:libxfce4util
#DEP:startup-notification


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/xfwm4/4.10/xfwm4-4.10.1.tar.bz2


TARBALL=xfwm4-4.10.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998824.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998824.sh
sudo ./1434987998824.sh
sudo rm -rf 1434987998824.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xfwm4=>`date`" | sudo tee -a $INSTALLED_LIST