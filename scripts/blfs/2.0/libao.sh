#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz


TARBALL=libao-1.2.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998834.sh << "ENDOFFILE"
make install &&
install -v -m644 README /usr/share/doc/libao-1.2.0
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libao=>`date`" | sudo tee -a $INSTALLED_LIST