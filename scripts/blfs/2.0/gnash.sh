#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:agg
#DEP:boost
#DEP:curl
#DEP:gst-ffmpeg
#DEP:npapi-sdk
#DEP:giflib


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/pub/gnu/gnash/0.8.10/gnash-0.8.10.tar.bz2
wget -nc ftp://ftp.gnu.org/pub/gnu/gnash/0.8.10/gnash-0.8.10.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gnash-0.8.10-CVE-2012-1175-1.patch


TARBALL=gnash-0.8.10.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../gnash-0.8.10-CVE-2012-1175-1.patch &&
sed -i '/^LIBS/s/\(.*\)/\1 -lboost_system/' \
    gui/Makefile.in utilities/Makefile.in   &&
sed -e '/DGifOpen/s:Data:&, NULL:'          \
    -e '/DGifCloseFile/s:_gif:&, NULL:'     \
    -i libbase/GnashImageGif.cpp            &&
sed -i '/#include <csignal>/a\#include <unistd.h>' plugin/klash4/klash_part.cpp &&

./configure --prefix=/usr --sysconfdir=/etc               \
  --with-npapi-incl=/usr/include/npapi-sdk --enable-media=gst \
  --with-npapi-plugindir=/usr/lib/mozilla/plugins         \
  --without-gconf &&
make

cat > 1434987998829.sh << "ENDOFFILE"
make install &&
make install-plugin
ENDOFFILE
chmod a+x 1434987998829.sh
sudo ./1434987998829.sh
sudo rm -rf 1434987998829.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnash=>`date`" | sudo tee -a $INSTALLED_LIST