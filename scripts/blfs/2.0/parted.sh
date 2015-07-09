#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:lvm2


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/parted-3.2-devmapper-1.patch


TARBALL=parted-3.2.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../parted-3.2-devmapper-1.patch

./configure --prefix=/usr --disable-static &&
make &&

make -C doc html                                       &&
makeinfo --html      -o doc/html       doc/parted.texi &&
makeinfo --plaintext -o doc/parted.txt doc/parted.texi

sed -i '/t0251-gpt-unicode.sh/d' tests/Makefile

cat > 1434987998753.sh << "ENDOFFILE"
make install &&
install -v -dm755 /usr/share/doc/parted-3.2/html &&
install -v -m644  doc/html/* \
                  /usr/share/doc/parted-3.2/html &&
install -v -m644  doc/{FAT,API,parted.{txt,html}} \
                  /usr/share/doc/parted-3.2
ENDOFFILE
chmod a+x 1434987998753.sh
sudo ./1434987998753.sh
sudo rm -rf 1434987998753.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "parted=>`date`" | sudo tee -a $INSTALLED_LIST