#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl


cd $SOURCE_DIR

wget -nc http://links.twibright.com/download/links-2.9.tar.bz2
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/links-2.9.tar.bz2


TARBALL=links-2.9.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --mandir=/usr/share/man &&
make

cat > 1434987998785.sh << "ENDOFFILE"
make install &&
install -v -d -m755 /usr/share/doc/links-2.9 &&
install -v -m644 doc/links_cal/* KEYS BRAILLE_HOWTO \
    /usr/share/doc/links-2.9
ENDOFFILE
chmod a+x 1434987998785.sh
sudo ./1434987998785.sh
sudo rm -rf 1434987998785.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "links=>`date`" | sudo tee -a $INSTALLED_LIST