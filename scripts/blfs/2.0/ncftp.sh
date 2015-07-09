#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.ncftp.com/ncftp/ncftp-3.2.5-src.tar.bz2


TARBALL=ncftp-3.2.5-src.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make -C libncftp shared &&
make

cat > 1434987998781.sh << "ENDOFFILE"
make -C libncftp soinstall &&
make install
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998781.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ncftp=>`date`" | sudo tee -a $INSTALLED_LIST