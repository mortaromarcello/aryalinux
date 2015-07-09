#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.ivmaisoft.com/_bin/atomic_ops//libatomic_ops-7.4.2.tar.gz


TARBALL=libatomic_ops-7.4.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's#pkgdata#doc#' doc/Makefile.am Makefile.am &&
autoreconf -fi &&
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static \
            --docdir=/usr/share/doc/libatomic_ops-7.4.2 &&
make

cat > 1434987998759.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998759.sh
sudo ./1434987998759.sh
sudo rm -rf 1434987998759.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libatomic_ops=>`date`" | sudo tee -a $INSTALLED_LIST