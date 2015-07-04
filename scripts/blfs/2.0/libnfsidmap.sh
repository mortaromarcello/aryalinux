#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://fedorapeople.org/~steved/libnfsidmap/0.26/libnfsidmap-0.26.tar.bz2


TARBALL=libnfsidmap-0.26.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make

cat > 1434987998762.sh << "ENDOFFILE"
make install                         &&
mv -v /usr/lib/libnfsidmap.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libnfsidmap.so) /usr/lib/libnfsidmap.so
ENDOFFILE
chmod a+x 1434987998762.sh
sudo ./1434987998762.sh
sudo rm -rf 1434987998762.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libnfsidmap=>`date`" | sudo tee -a $INSTALLED_LIST