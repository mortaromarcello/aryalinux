#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libpcap
#DEP:lua
#DEP:pcre
#DEP:liblinear


cd $SOURCE_DIR

wget -nc http://nmap.org/dist/nmap-6.47.tar.bz2


TARBALL=nmap-6.47.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make -j1

sed -i 's/lib./lib/' zenmap/test/run_tests.py

cat > 1434987998783.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998783.sh
sudo ./1434987998783.sh
sudo rm -rf 1434987998783.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "nmap=>`date`" | sudo tee -a $INSTALLED_LIST