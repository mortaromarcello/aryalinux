#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://tuxera.com/opensource/ntfs-3g_ntfsprogs-2014.2.15.tgz


TARBALL=ntfs-3g_ntfsprogs-2014.2.15.tgz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998752.sh << "ENDOFFILE"
make install &&
ln -sfv ../bin/ntfs-3g /sbin/mount.ntfs &&
ln -sfv /usr/share/man/man8/{ntfs-3g,mount.ntfs}.8
ENDOFFILE
chmod a+x 1434987998752.sh
sudo ./1434987998752.sh
sudo rm -rf 1434987998752.sh

cat > 1434987998752.sh << "ENDOFFILE"
chmod -v 4755 /sbin/mount.ntfs
ENDOFFILE
chmod a+x 1434987998752.sh
sudo ./1434987998752.sh
sudo rm -rf 1434987998752.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ntfs-3g=>`date`" | sudo tee -a $INSTALLED_LIST