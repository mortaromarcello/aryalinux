#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz


TARBALL=libffi-3.2.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in &&

sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in        &&

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998760.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998760.sh
sudo ./1434987998760.sh
sudo rm -rf 1434987998760.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libffi=>`date`" | sudo tee -a $INSTALLED_LIST