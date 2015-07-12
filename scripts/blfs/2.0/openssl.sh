#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.openssl.org/source/openssl-1.0.2.tar.gz
wget -nc ftp://ftp.openssl.org/source/openssl-1.0.2.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/openssl-1.0.2-fix_parallel_build-1.patch


TARBALL=openssl-1.0.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../openssl-1.0.2-fix_parallel_build-1.patch &&

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic &&
make

sed -i 's# libcrypto.a##;s# libssl.a##' Makefile

cat > 1434987998749.sh << "ENDOFFILE"
make MANDIR=/usr/share/man MANSUFFIX=ssl install &&
install -dv -m755 /usr/share/doc/openssl-1.0.2  &&
cp -vfr doc/*     /usr/share/doc/openssl-1.0.2
ENDOFFILE
chmod a+x 1434987998749.sh
sudo ./1434987998749.sh
sudo rm -rf 1434987998749.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "openssl=>`date`" | sudo tee -a $INSTALLED_LIST