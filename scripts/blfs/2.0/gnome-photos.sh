#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:desktop-file-utils
#DEP:exempi
#DEP:gegl
#DEP:gfbgraph
#DEP:gnome-desktop
#DEP:grilo
#DEP:lcms2
#DEP:libexif
#DEP:librsvg
#DEP:tracker


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-photos/3.14/gnome-photos-3.14.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-photos/3.14/gnome-photos-3.14.2.tar.xz


TARBALL=gnome-photos-3.14.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --docdir=/usr/share/doc/gnome-photos-3.14.2 &&
make

cat > 1434987998821.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998821.sh
sudo ./1434987998821.sh
sudo rm -rf 1434987998821.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gnome-photos=>`date`" | sudo tee -a $INSTALLED_LIST