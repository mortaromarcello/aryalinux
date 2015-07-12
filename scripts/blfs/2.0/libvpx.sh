#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:yasm
#DEP:nasm
#DEP:which


cd $SOURCE_DIR

wget -nc https://webm.googlecode.com/files/libvpx-v1.3.0.tar.bz2


TARBALL=libvpx-v1.3.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir -v ../libvpx-build &&
cd ../libvpx-build       &&

../libvpx-v1.3.0/configure --prefix=/usr \
                           --enable-shared \
                           --disable-static &&
make

cat > 1434987998836.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libvpx=>`date`" | sudo tee -a $INSTALLED_LIST