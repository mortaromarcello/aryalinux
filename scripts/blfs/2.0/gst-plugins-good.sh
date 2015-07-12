#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst-plugins-base
#DEP:cairo
#DEP:flac
#DEP:libjpeg
#DEP:libpng
#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gst-plugins-good/0.10/gst-plugins-good-0.10.31.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gst-plugins-good/0.10/gst-plugins-good-0.10.31.tar.xz


TARBALL=gst-plugins-good-0.10.31.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i -e "/input:/d" sys/v4l2/gstv4l2bufferpool.c &&
sed -i -e "/case V4L2_CID_HCENTER/d" -e "/case V4L2_CID_VCENTER/d" sys/v4l2/v4l2_calls.c &&
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --with-gtk=3.0 \
            --with-package-name="GStreamer Good Plugins 0.10.31 BLFS" \
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
 
echo "gst-plugins-good=>`date`" | sudo tee -a $INSTALLED_LIST