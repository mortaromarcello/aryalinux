#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libogg
#DEP:libvorbis


cd $SOURCE_DIR

wget -nc http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz


TARBALL=libtheora-1.1.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c &&
./configure --prefix=/usr --disable-static &&
make

cat > 1434987998836.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh

cat > 1434987998836.sh << "ENDOFFILE"
cd examples/.libs &&
for E in *; do
  install -v -m755 $E /usr/bin/theora_${E}
done
ENDOFFILE
chmod a+x 1434987998836.sh
sudo ./1434987998836.sh
sudo rm -rf 1434987998836.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libtheora=>`date`" | sudo tee -a $INSTALLED_LIST