#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:which


cd $SOURCE_DIR

wget -nc http://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz


TARBALL=aspell-0.60.6.1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998756.sh << "ENDOFFILE"
make install &&
install -v -m755 -d /usr/share/doc/aspell-0.60.6.1/aspell{,-dev}.html &&

install -v -m644 manual/aspell.html/* \
    /usr/share/doc/aspell-0.60.6.1/aspell.html &&

install -v -m644 manual/aspell-dev.html/* \
    /usr/share/doc/aspell-0.60.6.1/aspell-dev.html
ENDOFFILE
chmod a+x 1434987998756.sh
sudo ./1434987998756.sh
sudo rm -rf 1434987998756.sh

cat > 1434987998756.sh << "ENDOFFILE"
install -v -m 755 scripts/ispell /usr/bin/
ENDOFFILE
chmod a+x 1434987998756.sh
sudo ./1434987998756.sh
sudo rm -rf 1434987998756.sh

cat > 1434987998756.sh << "ENDOFFILE"
install -v -m 755 scripts/spell /usr/bin/
ENDOFFILE
chmod a+x 1434987998756.sh
sudo ./1434987998756.sh
sudo rm -rf 1434987998756.sh

./configure &&
make

cat > 1434987998756.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998756.sh
sudo ./1434987998756.sh
sudo rm -rf 1434987998756.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "aspell=>`date`" | sudo tee -a $INSTALLED_LIST