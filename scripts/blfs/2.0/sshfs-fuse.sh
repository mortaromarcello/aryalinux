#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:fuse
#DEP:glib2
#DEP:openssh


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/fuse/sshfs-fuse-2.5.tar.gz


TARBALL=sshfs-fuse-2.5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998753.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998753.sh
sudo ./1434987998753.sh
sudo rm -rf 1434987998753.sh

sshfs THINGY:~ ~/MOUNTPATH

fusermount -u ~/MOUNTPATH


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "sshfs-fuse=>`date`" | sudo tee -a $INSTALLED_LIST