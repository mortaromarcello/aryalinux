#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://lynx.isc.org/current/lynx2.8.8rel.2.tar.bz2
wget -nc ftp://lynx.isc.org/current/lynx2.8.8rel.2.tar.bz2


TARBALL=lynx2.8.8rel.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr          \
            --sysconfdir=/etc/lynx \
            --datadir=/usr/share/doc/lynx-2.8.8rel.2 \
            --with-zlib            \
            --with-bzlib           \
            --with-screen=ncursesw \
            --enable-locale-charset &&
make

cat > 1434987998785.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2

make install-full &&
chgrp -v -R root /usr/share/doc/lynx-2.8.8rel.2/lynx_doc

ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh

cat > 1434987998785.sh << "ENDOFFILE"
sed -i 's/#\(LOCALE_CHARSET\):FALSE/\1:TRUE/' /etc/lynx/lynx.cfg
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh

cat > 1434987998785.sh << "ENDOFFILE"
sed -i 's/#\(DEFAULT_EDITOR\):/\1:vi/' /etc/lynx/lynx.cfg
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh

cat > 1434987998785.sh << "ENDOFFILE"
sed -i 's/#\(PERSISTENT_COOKIES\):FALSE/\1:TRUE/' /etc/lynx/lynx.cfg
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lynx=>`date`" | sudo tee -a $INSTALLED_LIST
