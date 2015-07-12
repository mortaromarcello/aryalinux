#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxfce4ui
#DEP:vte2


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/apps/xfce4-terminal/0.6/xfce4-terminal-0.6.3.tar.bz2


TARBALL=xfce4-terminal-0.6.3.tar.bz2
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
 
echo "xfce4-terminal=>`date`" | sudo tee -a $INSTALLED_LIST