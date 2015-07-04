#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst-plugins-base
#DEP:gst10-plugins-base
#DEP:libxfce4ui
#DEP:libnotify
#DEP:taglib


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/apps/parole/0.5/parole-0.5.4.tar.bz2


TARBALL=parole-0.5.4.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998825.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998825.sh
sudo ./1434987998825.sh
sudo rm -rf 1434987998825.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "parole=>`date`" | sudo tee -a $INSTALLED_LIST