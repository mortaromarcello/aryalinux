#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/infozip/zip30.tar.gz
wget -nc ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz


TARBALL=zip30.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make -f unix/Makefile generic_gcc

cat > 1434987998774.sh << "ENDOFFILE"
make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "zip=>`date`" | sudo tee -a $INSTALLED_LIST