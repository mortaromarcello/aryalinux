#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:atk
#DEP:gdk-pixbuf
#DEP:pango
#DEP:hicolor-icon-theme


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.26.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.26.tar.xz


TARBALL=gtk+-2.24.26.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s#l \(gtk-.*\).sgml#& -o \1#" docs/{faq,tutorial}/Makefile.in &&
./configure --prefix=/usr --sysconfdir=/etc                           &&
make

cat > 1434987998794.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh

cat > 1434987998794.sh << "ENDOFFILE"
gtk-query-immodules-2.0 --update-cache
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh

cat > 1434987998794.sh << "ENDOFFILE"
cat > /etc/gtk-2.0/gtkrc << "EOF"
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
gtk-icon-theme-name = "elementary"
EOF
ENDOFFILE
chmod a+x 1434987998794.sh
sudo ./1434987998794.sh
sudo rm -rf 1434987998794.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gtk2=>`date`" | sudo tee -a $INSTALLED_LIST