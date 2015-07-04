#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libgpg-error


cd $SOURCE_DIR

wget -nc ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.2.0.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libassuan-2.2.0-fix_doc_build-1.patch


TARBALL=libassuan-2.2.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../libassuan-2.2.0-fix_doc_build-1.patch

./configure --prefix=/usr &&
make

cat > 1434987998759.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998759.sh
sudo ./1434987998759.sh
sudo rm -rf 1434987998759.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libassuan=>`date`" | sudo tee -a $INSTALLED_LIST