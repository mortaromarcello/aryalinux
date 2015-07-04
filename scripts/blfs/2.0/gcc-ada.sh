#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dejagnu


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.bz2
wget -nc ftp://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.bz2


TARBALL=gcc-4.9.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998775.sh << "ENDOFFILE"
make ins-all prefix=/opt/gnat
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh

PATH_HOLD=$PATH &&
export PATH=/opt/gnat/bin:$PATH_HOLD

cat > 1434987998775.sh << "ENDOFFILE"
find /opt/gnat -name ld -exec mv -v {} {}.old \;
find /opt/gnat -name as -exec mv -v {} {}.old \;
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh

mkdir ../gcc-build &&
cd    ../gcc-build &&

../gcc-4.9.2/configure          \
    --prefix=/usr               \
    --disable-multilib          \
    --with-system-zlib          \
    --enable-languages=ada &&
make

ulimit -s 32768 &&
make -k check

../gcc-4.9.2/contrib/test_summary

cat > 1434987998775.sh << "ENDOFFILE"
make install &&

mkdir -pv /usr/share/gdb/auto-load/usr/lib              &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib &&

chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/4.9.2/include{,-fixed} \
    /usr/lib/gcc/*linux-gnu/4.9.2/ada{lib,include}
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh

rm -rf /opt/gnat &&
export PATH=$PATH_HOLD &&
unset PATH_HOLD


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gcc-ada=>`date`" | sudo tee -a $INSTALLED_LIST