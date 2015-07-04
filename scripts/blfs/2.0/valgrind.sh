#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://valgrind.org/downloads/valgrind-3.10.1.tar.bz2


TARBALL=valgrind-3.10.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

sed -i "s:-mt::g" configure                  &&
sed -i "s:2.20:2.21:g" configure             &&
sed -i "s:/doc/valgrind::g" docs/Makefile.in &&

./configure --prefix=/usr --datadir=/usr/share/doc/valgrind-3.10.1 &&
make

cat > 1434987998779.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998779.sh
sudo ./1434987998779.sh
sudo rm -rf 1434987998779.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "valgrind=>`date`" | sudo tee -a $INSTALLED_LIST