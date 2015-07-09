#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:pango


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/paps/paps-0.6.8.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/paps-0.6.8-freetype_fix-1.patch


TARBALL=paps-0.6.8.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../paps-0.6.8-freetype_fix-1.patch &&
./configure --prefix=/usr --mandir=/usr/share/man &&
make

cat > 1434987998843.sh << "ENDOFFILE"
make install &&
install -v -m755 -d                 /usr/share/doc/paps-0.6.8 &&
install -v -m644 doxygen-doc/html/* /usr/share/doc/paps-0.6.8
ENDOFFILE
chmod a+x 1434987998843.sh
sudo ./1434987998843.sh
sudo rm -rf 1434987998843.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "paps=>`date`" | sudo tee -a $INSTALLED_LIST