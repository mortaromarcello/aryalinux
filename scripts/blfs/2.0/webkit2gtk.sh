#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:gst10-plugins-base
#DEP:gtk3
#DEP:icu
#DEP:libsecret
#DEP:libsoup
#DEP:libwebp
#DEP:mesalib
#DEP:ruby
#DEP:sqlite
#DEP:systemd
#DEP:which
#DEP:enchant
#DEP:geoclue2
#DEP:geoclue
#DEP:gobject-introspection
#DEP:gtk2


cd $SOURCE_DIR

wget -nc http://webkitgtk.org/releases/webkitgtk-2.6.5.tar.xz


TARBALL=webkitgtk-2.6.5.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON       \
      -DPORT=GTK                  \
      -DLIB_INSTALL_DIR=/usr/lib  \
      -Wno-dev ..
make

cat > 1434987998796.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998796.sh
sudo ./1434987998796.sh
sudo rm -rf 1434987998796.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "webkit2gtk=>`date`" | sudo tee -a $INSTALLED_LIST