#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:x7lib
#DEP:ffmpeg
#DEP:alsa
#DEP:pulseaudio
#DEP:
#DEP:libdvdnav


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/xine/xine-lib-1.2.6.tar.xz
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/xine-lib-1.2.6.tar.xz


TARBALL=xine-lib-1.2.6.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr          \
            --disable-vcd          \
            --with-external-dvdnav \
            --docdir=/usr/share/doc/xine-lib-1.2.6 &&
make

cat > 1434987998837.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998837.sh
sudo ./1434987998837.sh
sudo rm -rf 1434987998837.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xine-lib=>`date`" | sudo tee -a $INSTALLED_LIST