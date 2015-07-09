#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:itstool
#DEP:desktop-file-utils
#DEP:json-glib
#DEP:libarchive
#DEP:libnotify
#DEP:nautilus


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/file-roller/3.14/file-roller-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/file-roller/3.14/file-roller-3.14.2.tar.xz


TARBALL=file-roller-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr        \
            --disable-packagekit \
            --disable-static &&
make

cat > 1434987998820.sh << "ENDOFFILE"
make install &&
chmod -v 755 /usr/libexec/file-roller/isoinfo.sh
ENDOFFILE
chmod a+x 1434987998820.sh
sudo ./1434987998820.sh
sudo rm -rf 1434987998820.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "file-roller=>`date`" | sudo tee -a $INSTALLED_LIST