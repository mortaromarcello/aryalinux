#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/mad/libmad-0.15.1b.tar.gz
wget -nc ftp://ftp.mars.org/pub/mpeg/libmad-0.15.1b.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libmad-0.15.1b-fixes-1.patch


TARBALL=libmad-0.15.1b.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../libmad-0.15.1b-fixes-1.patch                &&
sed "s@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@g" -i configure.ac &&
touch NEWS AUTHORS ChangeLog                                 &&
autoreconf -fi                                               &&

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998835.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998835.sh
sudo ./1434987998835.sh
sudo rm -rf 1434987998835.sh

cat > 1434987998835.sh << "ENDOFFILE"
cat > /usr/lib/pkgconfig/mad.pc << "EOF"
prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: mad
Description: MPEG audio decoder
Requires:
Version: 0.15.1b
Libs: -L${libdir} -lmad
Cflags: -I${includedir}
EOF
ENDOFFILE
chmod a+x 1434987998835.sh
sudo ./1434987998835.sh
sudo rm -rf 1434987998835.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "libmad=>`date`" | sudo tee -a $INSTALLED_LIST