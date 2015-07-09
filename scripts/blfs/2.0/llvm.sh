#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libffi
#DEP:python2


cd $SOURCE_DIR

wget -nc http://llvm.org/releases/3.5.1/llvm-3.5.1.src.tar.xz


TARBALL=llvm-3.5.1.src.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -e "s:/docs/llvm:/share/doc/llvm-3.5.1:" \
    -i Makefile.config.in &&

CC=gcc CXX=g++                   \
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --enable-libffi      \
            --enable-optimized   \
            --enable-shared      \
            --disable-assertions &&
make

cat > 1434987998776.sh << "ENDOFFILE"
make install &&

for file in /usr/lib/lib{clang,LLVM,LTO}*.a
do
  test -f $file && chmod -v 644 $file
done
ENDOFFILE
chmod a+x 1434987998776.sh
sudo ./1434987998776.sh
sudo rm -rf 1434987998776.sh


 
cd $SOURCE_DIR
#sudo rm -rf $DIRECTORY
 
echo "llvm=>`date`" | sudo tee -a $INSTALLED_LIST
