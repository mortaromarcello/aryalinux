#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libnotify
#DEP:gnutls
#DEP:libgcrypt
#DEP:libsecret
#DEP:networkmanager
#DEP:telepathy-glib


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/vino/3.14/vino-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vino/3.14/vino-3.14.2.tar.xz


TARBALL=vino-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998822.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998822.sh
sudo ./1434987998822.sh
sudo rm -rf 1434987998822.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "vino=>`date`" | sudo tee -a $INSTALLED_LIST