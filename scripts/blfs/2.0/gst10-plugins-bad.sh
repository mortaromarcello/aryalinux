#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst10-plugins-base
#DEP:libdvdread
#DEP:libdvdnav
#DEP:soundtouch


cd $SOURCE_DIR

wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.4.5.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gst-plugins-bad-1.4.5-openjpeg21-1.patch


TARBALL=gst-plugins-bad-1.4.5.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../gst-plugins-bad-1.4.5-openjpeg21-1.patch

./configure --prefix=/usr \
            --with-package-name="GStreamer Bad Plugins 1.4.5 BLFS" \
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
 
echo "gst10-plugins-bad=>`date`" | sudo tee -a $INSTALLED_LIST