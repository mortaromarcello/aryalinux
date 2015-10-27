#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst-plugins-base
#DEP:lame
#DEP:libdvdnav
#DEP:libdvdread


cd $SOURCE_DIR

wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-0.10.19.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gst-plugins-ugly-0.10.19-libcdio_fixes-1.patch


TARBALL=gst-plugins-ugly-0.10.19.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../gst-plugins-ugly-0.10.19-libcdio_fixes-1.patch &&
./configure --prefix=/usr \
            --with-package-name="GStreamer Ugly Plugins 0.10.19 BLFS" \
            --with-package-origin="http://www.linuxfromscratch.org/blfs/view/systemd/" &&
make

cat > 1434987998833.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998833.sh
sudo ./1434987998833.sh
sudo rm -rf 1434987998833.sh

cat > 1434987998833.sh << "ENDOFFILE"
make -C docs/plugins install-data
ENDOFFILE
chmod a+x 1434987998833.sh
sudo ./1434987998833.sh
sudo rm -rf 1434987998833.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gst-plugins-ugly=>`date`" | sudo tee -a $INSTALLED_LIST