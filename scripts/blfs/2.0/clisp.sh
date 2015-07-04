#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libsigsegv


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/pub/gnu/clisp/latest/clisp-2.49.tar.bz2
wget -nc ftp://ftp.gnu.org/pub/gnu/clisp/latest/clisp-2.49.tar.bz2


TARBALL=clisp-2.49.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i '/socket/d' tests/tests.lisp

mkdir build &&
cd    build &&

../configure --srcdir=../                       \
             --prefix=/usr                      \
             --docdir=/usr/share/doc/clisp-2.49 \
             --with-libsigsegv-prefix=/usr &&

ulimit -s 16384 &&
make -j1

cat > 1434987998774.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998774.sh
sudo ./1434987998774.sh
sudo rm -rf 1434987998774.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "clisp=>`date`" | sudo tee -a $INSTALLED_LIST