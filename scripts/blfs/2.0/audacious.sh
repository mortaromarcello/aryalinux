#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:libxml2
#DEP:xorg7#xorg-env
#DEP:installing


cd $SOURCE_DIR

wget -nc http://distfiles.audacious-media-player.org/audacious-3.5.2.tar.bz2
wget -nc http://distfiles.audacious-media-player.org/audacious-plugins-3.5.2.tar.bz2


TARBALL=audacious-3.5.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

TPUT=/bin/true ./configure --prefix=/usr --with-buildstamp="BLFS" &&
make

cat > 1434987998838.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh

TPUT=/bin/true ./configure --prefix=/usr &&
make

cat > 1434987998838.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh

cat > 1434987998838.sh << "ENDOFFILE"
gtk-update-icon-cache &&
update-desktop-database
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "audacious=>`date`" | sudo tee -a $INSTALLED_LIST