#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libdvdread


cd $SOURCE_DIR

wget -nc http://download.videolan.org/videolan/libdvdnav/5.0.3/libdvdnav-5.0.3.tar.bz2


TARBALL=libdvdnav-5.0.3.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/libdvdnav-5.0.3 &&
make

cat > 1434987998835.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998835.sh
sudo ./1434987998835.sh
sudo rm -rf 1434987998835.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libdvdnav=>`date`" | sudo tee -a $INSTALLED_LIST