#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:unzip
#DEP:libjpeg


cd $SOURCE_DIR

wget -nc http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/jasper-1.900.1-security_fixes-2.patch


TARBALL=jasper-1.900.1.zip
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

mkdir -pv 1434987998766
chmod -R a+rw 1434987998766
cp jasper-1.900.1.zip 1434987998766
cd 1434987998766
unzip $TARBALL


patch -Np1 -i ../jasper-1.900.1-security_fixes-2.patch &&
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static \
            --mandir=/usr/share/man &&
make

cat > 1434987998766.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998766.sh
sudo ./1434987998766.sh
sudo rm -rf 1434987998766.sh

cat > 1434987998766.sh << "ENDOFFILE"
install -v -m755 -d /usr/share/doc/jasper-1.900.1 &&
install -v -m644 doc/*.pdf /usr/share/doc/jasper-1.900.1
ENDOFFILE
chmod a+x 1434987998766.sh
sudo ./1434987998766.sh
sudo rm -rf 1434987998766.sh


 
cd $SOURCE_DIR
 
echo "jasper=>`date`" | sudo tee -a $INSTALLED_LIST