#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/cdparanoia-III-10.2-gcc_fixes-1.patch


TARBALL=cdparanoia-III-10.2.src.tgz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../cdparanoia-III-10.2-gcc_fixes-1.patch &&
./configure --prefix=/usr --mandir=/usr/share/man &&
make -j1

cat > 1434987998838.sh << "ENDOFFILE"
make install &&
chmod -v 755 /usr/lib/libcdda_*.so.0.10.2
ENDOFFILE
chmod a+x 1434987998838.sh
sudo ./1434987998838.sh
sudo rm -rf 1434987998838.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "cdparanoia=>`date`" | sudo tee -a $INSTALLED_LIST