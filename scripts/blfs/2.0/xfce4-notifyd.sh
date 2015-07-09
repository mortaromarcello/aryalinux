#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libnotify
#DEP:libxfce4ui


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/apps/xfce4-notifyd/0.2/xfce4-notifyd-0.2.4.tar.bz2


TARBALL=xfce4-notifyd-0.2.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998826.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998826.sh
sudo ./1434987998826.sh
sudo rm -rf 1434987998826.sh

notify-send -i info Information "Hi ${USER}, This is a Test"


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xfce4-notifyd=>`date`" | sudo tee -a $INSTALLED_LIST