#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:pcre
#DEP:slang


cd $SOURCE_DIR

wget -nc http://ftp.midnight-commander.org/mc-4.8.13.tar.xz
wget -nc ftp://ftp.osuosl.org/pub/midnightcommander/mc-4.8.13.tar.xz


TARBALL=mc-4.8.13.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --enable-charset &&
make

cat > 1434987998772.sh << "ENDOFFILE"
make install &&
cp -v doc/keybind-migration.txt /usr/share/mc
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "mc=>`date`" | sudo tee -a $INSTALLED_LIST