#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/sources/BLFS/svn/n/net-tools-CVS_20101030.tar.gz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/svn/n/net-tools-CVS_20101030.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/net-tools-CVS_20101030-remove_dups-1.patch


TARBALL=net-tools-CVS_20101030.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../net-tools-CVS_20101030-remove_dups-1.patch &&

yes "" | make config &&
make

cat > 1434987998781.sh << "ENDOFFILE"
make update
ENDOFFILE
chmod a+x 1434987998781.sh
sudo ./1434987998781.sh
sudo rm -rf 1434987998781.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "net-tools=>`date`" | sudo tee -a $INSTALLED_LIST