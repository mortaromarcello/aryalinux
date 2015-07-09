#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/libidn/libidn-1.29.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/libidn/libidn-1.29.tar.gz


TARBALL=libidn-1.29.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998761.sh << "ENDOFFILE"
make install &&

find doc -name "Makefile*" -delete          &&
rm -rfv doc/{gdoc,idn.1,stamp-vti,man,texi} &&
mkdir -pv     /usr/share/doc/libidn-1.29    &&
cp -rfv doc/* /usr/share/doc/libidn-1.29
ENDOFFILE
chmod a+x 1434987998761.sh
sudo ./1434987998761.sh
sudo rm -rf 1434987998761.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libidn=>`date`" | sudo tee -a $INSTALLED_LIST