#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2
#DEP:libgcrypt
#DEP:gnutls
#DEP:nss


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/pidgin/pidgin-2.10.11.tar.bz2


TARBALL=pidgin-2.10.11.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --disable-avahi     \
            --disable-gtkspell  \
            --disable-gstreamer \
            --disable-meanwhile \
            --disable-idn       \
            --disable-nm        \
            --disable-vv        \
            --disable-tcl &&
make

cat > 1434987998830.sh << "ENDOFFILE"
make install &&
mkdir -pv /usr/share/doc/pidgin-2.10.11 &&
cp -v README doc/gtkrc-2.0 /usr/share/doc/pidgin-2.10.11
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh

cat > 1434987998830.sh << "ENDOFFILE"
gtk-update-icon-cache &&
update-desktop-database
ENDOFFILE
chmod a+x 1434987998830.sh
sudo ./1434987998830.sh
sudo rm -rf 1434987998830.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "pidgin=>`date`" | sudo tee -a $INSTALLED_LIST
