#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:zip
#DEP:unzip
#DEP:which
#DEP:dejagnu


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.bz2
wget -nc ftp://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.bz2


TARBALL=gcc-4.9.2.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i 's/\(install.*:\) install-.*recursive/\1/' libffi/Makefile.in         &&
sed -i 's/\(install-data-am:\).*/\1/'             libffi/include/Makefile.in &&

cp ../ecj-latest.jar ./ecj.jar &&

mkdir ../gcc-build &&
cd    ../gcc-build &&

../gcc-4.9.2/configure           \
    --prefix=/usr                \
    --disable-multilib           \
    --with-system-zlib           \
    --disable-bootstrap          \
    --enable-java-home           \
    --with-jvm-root-dir=/opt/gcj \
    --with-antlr-jar=$(pwd)/../antlr-4.2.2-complete.jar \
    --enable-languages=java &&
make

ulimit -s 32768 &&
make -k check

../gcc-4.9.2/contrib/test_summary

cat > 1434987998775.sh << "ENDOFFILE"
make install &&

mkdir -pv /usr/share/gdb/auto-load/usr/lib              &&
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib &&

chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/4.9.2/include{,-fixed} &&

gcj -o ecj ../ecj-latest.jar \
    --main=org.eclipse.jdt.internal.compiler.batch.Main &&
mv ecj /usr/bin &&
ln -sfv ../../../usr/bin/ecj /opt/gcj/bin/javac
ENDOFFILE
chmod a+x 1434987998775.sh
sudo ./1434987998775.sh
sudo rm -rf 1434987998775.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gcc-java=>`date`" | sudo tee -a $INSTALLED_LIST