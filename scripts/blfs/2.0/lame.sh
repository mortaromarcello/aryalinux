#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/lame/lame-3.99.5.tar.gz


TARBALL=lame-3.99.5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

case $(uname -m) in
   i?86) sed -i -e '/xmmintrin\.h/d' configure ;;
esac

./configure --prefix=/usr --enable-mp3rtp --disable-static &&
make

cat > 1434987998838.sh << "ENDOFFILE"
make pkghtmldir=/usr/share/doc/lame-3.99.5 install
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lame=>`date`" | sudo tee -a $INSTALLED_LIST