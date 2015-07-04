#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:brasero
#DEP:gsettings-desktop-schemas
#DEP:iso-codes
#DEP:libdiscid
#DEP:libmusicbrainz5


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/sound-juicer/3.14/sound-juicer-3.14.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/sound-juicer/3.14/sound-juicer-3.14.0.tar.xz


TARBALL=sound-juicer-3.14.0.tar.xz
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
 
echo "sound-juicer=>`date`" | sudo tee -a $INSTALLED_LIST