#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gstreamer
#DEP:pango
#DEP:alsa-lib
#DEP:libogg
#DEP:libtheora
#DEP:libvorbis
#DEP:systemd
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gst-plugins-base/0.10/gst-plugins-base-0.10.36.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gst-plugins-base/0.10/gst-plugins-base-0.10.36.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gst-plugins-base-0.10.36-gcc_4_9_0_i686-1.patch


TARBALL=gst-plugins-base-0.10.36.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../gst-plugins-base-0.10.36-gcc_4_9_0_i686-1.patch

./configure --prefix=/usr    \
            --disable-static \
            --with-package-name="GStreamer Base Plugins 0.10.36 BLFS" \
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
 
echo "gst-plugins-base=>`date`" | sudo tee -a $INSTALLED_LIST