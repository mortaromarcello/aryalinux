#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.nasm.us/pub/nasm/releasebuilds/2.11.06/nasm-2.11.06.tar.xz


TARBALL=nasm-2.11.06.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

tar -xf ../nasm-2.11.06-xdoc.tar.xz --strip-components=1

./configure --prefix=/usr &&
make

cat > 1434987998776.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh

cat > 1434987998776.sh << "ENDOFFILE"
install -dm755           /usr/share/doc/nasm-2.11.06/html  &&
cp -v doc/html/*.html    /usr/share/doc/nasm-2.11.06/html  &&
cp -v doc/*.{txt,ps,pdf} /usr/share/doc/nasm-2.11.06       &&
cp -v doc/info/*         /usr/share/info                   &&
install-info /usr/share/info/nasm.info /usr/share/info/dir
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "nasm=>`date`" | sudo tee -a $INSTALLED_LIST