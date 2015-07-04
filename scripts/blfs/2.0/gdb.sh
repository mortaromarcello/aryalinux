#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/gdb/gdb-7.8.2.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/gdb/gdb-7.8.2.tar.xz


TARBALL=gdb-7.8.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --with-system-readline &&
make

cat > 1434987998775.sh << "ENDOFFILE"
make -C gdb install
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gdb=>`date`" | sudo tee -a $INSTALLED_LIST