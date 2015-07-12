#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst-plugins-base
#DEP:faac
#DEP:libpng
#DEP:libvpx
#DEP:openssl
#DEP:xvid


cd $SOURCE_DIR

wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.xz


TARBALL=gst-plugins-bad-0.10.23.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr      \
            --with-gtk=3.0     \
            --disable-examples \
            --disable-static   \
            --with-package-name="GStreamer Bad Plugins 0.10.23 BLFS" \
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
 
echo "gst-plugins-bad=>`date`" | sudo tee -a $INSTALLED_LIST