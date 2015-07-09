#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-lib
#DEP:ffmpeg
#DEP:liba52
#DEP:libgcrypt
#DEP:libmad
#DEP:lua
#@DEP:installing


cd $SOURCE_DIR

wget -nc http://download.videolan.org/vlc/2.1.5/vlc-2.1.5.tar.xz


TARBALL=vlc-2.1.5.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed "s:< 56:< 57:g" -i configure &&
./configure --prefix=/usr        &&
make

cat > 1434987998839.sh << "ENDOFFILE"
make docdir=/usr/share/doc/vlc-2.1.5 install
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh

cat > 1434987998839.sh << "ENDOFFILE"
gtk-update-icon-cache &&
update-desktop-database
ENDOFFILE
chmod a+x 1434987998839.sh
sudo ./1434987998839.sh
sudo rm -rf 1434987998839.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "vlc=>`date`" | sudo tee -a $INSTALLED_LIST
