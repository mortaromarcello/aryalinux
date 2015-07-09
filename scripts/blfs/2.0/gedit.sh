#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gsettings-desktop-schemas
#DEP:gtksourceview
#DEP:itstool
#DEP:libpeas
#DEP:enchant
#DEP:iso-codes
#DEP:libsoup
#DEP:python-modules#pygobject3
#DEP:vala
#DEP:gvfs


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gedit/3.14/gedit-3.14.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gedit/3.14/gedit-3.14.3.tar.xz


TARBALL=gedit-3.14.3.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998820.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998820.sh
sudo ./1434987998820.sh
sudo rm -rf 1434987998820.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gedit=>`date`" | sudo tee -a $INSTALLED_LIST