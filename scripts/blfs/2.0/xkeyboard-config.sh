#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libxslt


cd $SOURCE_DIR

wget -nc http://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.14.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/data/xkeyboard-config/xkeyboard-config-2.14.tar.bz2


TARBALL=xkeyboard-config-2.14.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr          \
            --disable-runtime-deps \
            --with-xkb-rules-symlink=xorg &&
make

cat > 1434987998790.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998790.sh
sudo ./1434987998790.sh
sudo rm -rf 1434987998790.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xkeyboard-config=>`date`" | sudo tee -a $INSTALLED_LIST