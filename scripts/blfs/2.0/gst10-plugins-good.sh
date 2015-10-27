#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst10-plugins-base
#DEP:cairo
#DEP:flac
#DEP:gdk-pixbuf
#DEP:libjpeg
#DEP:libpng
#DEP:libsoup
#DEP:libvpx
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.4.5.tar.xz


TARBALL=gst-plugins-good-1.4.5.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --with-package-name="GStreamer Good Plugins 1.4.5 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/systemd/" &&
make

cat > 1434987998833.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998833.sh
sudo ./1434987998833.sh
sudo rm -rf 1434987998833.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gst10-plugins-good=>`date`" | sudo tee -a $INSTALLED_LIST