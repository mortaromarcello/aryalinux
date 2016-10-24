#!/bin/bash

set -e

. /etc/alps/alps.conf

#VER:gst-ffmpeg:0.10.13
. /var/lib/alps/functions

cd $SOURCE_DIR

#REQ:gst-plugins-base
#REQ:yasm


cd $SOURCE_DIR

URL=http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gst-ffmpeg-0.10.13-gcc-4.7-1.patch
wget -nc http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../gst-ffmpeg-0.10.13-gcc-4.7-1.patch &&
./configure --prefix=/usr \
            --with-package-name="GStreamer FFMpeg Plugins 0.10.13 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/systemd/" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gst-ffmpeg=>`date`" | sudo tee -a $INSTALLED_LIST

