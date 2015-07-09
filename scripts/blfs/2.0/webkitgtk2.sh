#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gst10-plugins-base
#DEP:gtk3
#DEP:gtk2
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
#DEP:hicolor-icon-theme


cd $SOURCE_DIR

wget -nc http://webkitgtk.org/releases/webkitgtk-2.4.8.tar.xz


TARBALL=webkitgtk-2.4.8.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/generate-gtkdoc --rebase/s:^:# :' GNUmakefile.in

sed -i "/TARGET_WAYLAND_TRUE/d" GNUmakefile.in &&
mkdir build3 &&
pushd build3 &&
../configure --prefix=/usr --enable-introspection &&
make &&
popd

mkdir build2 &&
pushd build2 &&
../configure --prefix=/usr --with-gtk=2.0 --disable-webkit2 &&
make &&
popd

cat > 1434987998796.sh << "ENDOFFILE"
make -C build3 install                             &&
rm -rf /usr/share/gtk-doc/html/webkit{,dom}gtk-3.0 &&
if [ -e /usr/share/gtk-doc/html/webkitdomgtk ]; then
  mv -v /usr/share/gtk-doc/html/webkitdomgtk{,-3.0}
fi
if [ -e /usr/share/gtk-doc/html/webkitgtk ]; then
  mv -v /usr/share/gtk-doc/html/webkitgtk{,-3.0}
fi
ENDOFFILE
chmod a+x 1434987998796.sh
sudo ./1434987998796.sh
sudo rm -rf 1434987998796.sh

cat > 1434987998796.sh << "ENDOFFILE"
make -C build2 install                             &&
rm -rf /usr/share/gtk-doc/html/webkit{,dom}gtk-1.0 &&
if [ -e /usr/share/gtk-doc/html/webkitdomgtk ]; then
  mv -v /usr/share/gtk-doc/html/webkitdomgtk{,-1.0}
fi
if [ -e /usr/share/gtk-doc/html/webkitgtk ]; then
  mv -v /usr/share/gtk-doc/html/webkitgtk{,-1.0}
fi
ENDOFFILE
chmod a+x 1434987998796.sh
sudo ./1434987998796.sh
sudo rm -rf 1434987998796.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "webkitgtk2=>`date`" | sudo tee -a $INSTALLED_LIST