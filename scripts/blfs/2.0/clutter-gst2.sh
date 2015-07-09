#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:clutter
#DEP:gst10-plugins-base
#DEP:gobject-introspection
#DEP:gst10-plugins-bad


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.14.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.14.tar.xz


TARBALL=clutter-gst-2.0.14.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998793.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998793.sh
sudo ./1434987998793.sh
sudo rm -rf 1434987998793.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "clutter-gst2=>`date`" | sudo tee -a $INSTALLED_LIST