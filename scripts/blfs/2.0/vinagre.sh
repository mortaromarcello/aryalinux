#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk-vnc
#DEP:itstool
#DEP:libsecret
#DEP:appstream-glib
#DEP:telepathy-glib
#DEP:vala
#DEP:vte


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/vinagre/3.14/vinagre-3.14.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vinagre/3.14/vinagre-3.14.3.tar.xz


TARBALL=vinagre-3.14.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998822.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998822.sh
sudo ./1434987998822.sh
sudo rm -rf 1434987998822.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "vinagre=>`date`" | sudo tee -a $INSTALLED_LIST