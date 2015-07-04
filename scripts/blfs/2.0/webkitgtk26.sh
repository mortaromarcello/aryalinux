#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:gst10-plugins-base
#DEP:gtk2
#DEP:gtk3
#DEP:icu
#DEP:libsecret
#DEP:libsoup
#DEP:libwebp
#DEP:mesalib
#DEP:ruby
#DEP:sqlite
#DEP:udev-extras
#DEP:which
#DEP:enchant
#DEP:geoclue
#DEP:gobject-introspection
#DEP:hicolor-icon-theme


cd $SOURCE_DIR

TARBALL=webkitgtk-2.6.5.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

wget -nc http://webkitgtk.org/releases/webkitgtk-2.6.5.tar.xz


tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/�€/\"/g' Source/WebCore/xml/XMLViewer.{css,js} &&

mkdir -vp build &&
cd build        &&

cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_SKIP_RPATH=ON       \
      -DPORT=GTK                  \
      -DLIB_INSTALL_DIR=/usr/lib  \
      -Wno-dev .. &&
make

cat > 1434309266769.sh << ENDOFFILE
make install &&

install -vdm755 /usr/share/gtk-doc/html/webkit{2,dom}gtk-4.0 &&
install -vm644  ../Documentation/webkit2gtk/html/* \
                /usr/share/gtk-doc/html/webkit2gtk-4.0 &&
install -vm644  ../Documentation/webkitdomgtk/html/* \
                /usr/share/gtk-doc/html/webkitdomgtk-4.0
ENDOFFILE
chmod a+x 1434309266769.sh
sudo ./1434309266769.sh
sudo rm -rf 1434309266769.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "webkitgtk26=>`date`" | sudo tee -a $INSTALLED_LIST