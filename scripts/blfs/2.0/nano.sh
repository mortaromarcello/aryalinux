#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/nano/nano-2.3.6.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/nano/nano-2.3.6.tar.gz


TARBALL=nano-2.3.6.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-2.3.6 &&
make

cat > 1434987998754.sh << "ENDOFFILE"
make install &&
install -v -m644 doc/nanorc.sample /etc &&
install -v -m644 doc/texinfo/nano.html /usr/share/doc/nano-2.3.6
ENDOFFILE
chmod a+x 1434987998754.sh
sudo ./1434987998754.sh
sudo rm -rf 1434987998754.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "nano=>`date`" | sudo tee -a $INSTALLED_LIST