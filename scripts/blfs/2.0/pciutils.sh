#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.3.0.tar.xz
wget -nc ftp://ftp.kernel.org/pub/software/utils/pciutils/pciutils-3.3.0.tar.xz


TARBALL=pciutils-3.3.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

make PREFIX=/usr              \
     SHAREDIR=/usr/share/misc \
     SHARED=yes

cat > 1434987998772.sh << "ENDOFFILE"
make PREFIX=/usr              \
     SHAREDIR=/usr/share/misc \
     SHARED=yes               \
     install install-lib      &&

chmod -v 755 /usr/lib/libpci.so
ENDOFFILE
chmod a+x 1434987998772.sh
sudo ./1434987998772.sh
sudo rm -rf 1434987998772.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "pciutils=>`date`" | sudo tee -a $INSTALLED_LIST