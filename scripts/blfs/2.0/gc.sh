#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libatomic_ops


cd $SOURCE_DIR

wget -nc http://www.hboehm.info/gc/gc_source/gc-7.4.2.tar.gz


TARBALL=gc-7.4.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's#pkgdata#doc#' doc/doc.am &&
autoreconf -fi  &&
./configure --prefix=/usr      \
            --enable-cplusplus \
            --disable-static   \
            --docdir=/usr/share/doc/gc-7.4.2 &&
make

cat > 1434987998775.sh << "ENDOFFILE"
make install &&
install -v -m644 doc/gc.man /usr/share/man/man3/gc_malloc.3 &&
ln -sfv gc_malloc.3 /usr/share/man/man3/gc.3
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gc=>`date`" | sudo tee -a $INSTALLED_LIST