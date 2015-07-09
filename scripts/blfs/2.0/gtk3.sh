#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:at-spi2-atk
#DEP:gdk-pixbuf
#DEP:pango
#DEP:libxkbcommon
#DEP:wayland


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/3.14/gtk+-3.14.8.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/3.14/gtk+-3.14.8.tar.xz


TARBALL=gtk+-3.14.8.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr             \
            --sysconfdir=/etc         \
            --enable-broadway-backend \
            --enable-wayland-backend  \
            --enable-x11-backend      &&
make

cat > 1434987998794.sh << "ENDOFFILE"
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh

cat > 1434987998794.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh

cat > 1434987998794.sh << "ENDOFFILE"
gtk-query-immodules-3.0 --update-cache
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh

cat > 1434987998794.sh << "ENDOFFILE"
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh

cat > 1434987998794.sh << "ENDOFFILE"
cat > /etc/gtk-3.0/settings.ini << "EOF"
[Settings]
gtk-theme-name = Adwaita
gtk-fallback-icon-theme = elementary
EOF
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gtk3=>`date`" | sudo tee -a $INSTALLED_LIST