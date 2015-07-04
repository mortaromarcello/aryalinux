#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/libdv/libdv-1.0.0.tar.gz


TARBALL=libdv-1.0.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --disable-xv \
            --disable-static &&
make

cat > 1434987998835.sh << "ENDOFFILE"
make install &&
install -v -m755 -d      /usr/share/doc/libdv-1.0.0 &&
install -v -m644 README* /usr/share/doc/libdv-1.0.0
ENDOFFILE
chmod a+x 1434987998835.sh
sudo ./1434987998835.sh
sudo rm -rf 1434987998835.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libdv=>`date`" | sudo tee -a $INSTALLED_LIST