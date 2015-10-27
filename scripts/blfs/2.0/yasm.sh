#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz


TARBALL=yasm-1.3.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's#) ytasm.*#)#' Makefile.in &&
./configure --prefix=/usr &&
make

cat > 1434987998779.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998779.sh
sudo ./1434987998779.sh
sudo rm -rf 1434987998779.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "yasm=>`date`" | sudo tee -a $INSTALLED_LIST