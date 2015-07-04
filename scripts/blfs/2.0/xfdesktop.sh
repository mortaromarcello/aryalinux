#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:exo
#DEP:libwnck2
#DEP:libxfce4ui
#DEP:libnotify
#DEP:startup-notification
#DEP:thunar


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/xfdesktop/4.10/xfdesktop-4.10.3.tar.bz2


TARBALL=xfdesktop-4.10.3.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998824.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998824.sh
sudo ./1434987998824.sh
sudo rm -rf 1434987998824.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xfdesktop=>`date`" | sudo tee -a $INSTALLED_LIST