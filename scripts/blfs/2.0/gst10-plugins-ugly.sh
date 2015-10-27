#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst10-plugins-base
#DEP:lame
#DEP:libdvdread
#DEP:x264


cd $SOURCE_DIR

wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-1.4.5.tar.xz


TARBALL=gst-plugins-ugly-1.4.5.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --with-package-name="GStreamer Ugly Plugins 1.4.5 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/systemd/" &&
make

cat > 1434987998834.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998834.sh
sudo ./1434987998834.sh
sudo rm -rf 1434987998834.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gst10-plugins-ugly=>`date`" | sudo tee -a $INSTALLED_LIST