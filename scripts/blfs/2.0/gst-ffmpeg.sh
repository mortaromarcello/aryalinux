#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst-plugins-base
#DEP:yasm


cd $SOURCE_DIR

wget -nc http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gst-ffmpeg-0.10.13-gcc-4.7-1.patch


TARBALL=gst-ffmpeg-0.10.13.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../gst-ffmpeg-0.10.13-gcc-4.7-1.patch &&
./configure --prefix=/usr \
            --with-package-name="GStreamer FFMpeg Plugins 0.10.13 BLFS" \
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
 
echo "gst-ffmpeg=>`date`" | sudo tee -a $INSTALLED_LIST