#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libvorbis


cd $SOURCE_DIR

wget -nc http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz


TARBALL=vorbis-tools-1.4.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --enable-vcut \
            --without-curl &&
make

cat > 1434987998838.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "vorbistools=>`date`" | sudo tee -a $INSTALLED_LIST