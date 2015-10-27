#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libogg


cd $SOURCE_DIR

wget -nc http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.xz


TARBALL=libvorbis-1.3.4.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998836.sh << "ENDOFFILE"
make install &&
install -v -m644 doc/Vorbis* /usr/share/doc/libvorbis-1.3.4
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libvorbis=>`date`" | sudo tee -a $INSTALLED_LIST