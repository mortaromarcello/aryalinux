#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/sources/BLFS/svn/t/tidy-cvs_20101110.tar.bz2


TARBALL=tidy-cvs_20101110.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

cat > 1434987998770.sh << "ENDOFFILE"
make install &&

install -v -Dm644 htmldoc/tidy.1 \
                  /usr/share/man/man1/tidy.1 &&
install -v -dm755 /usr/share/doc/tidy-cvs_20101110 &&
install -v -m644  htmldoc/*.{html,gif,css} \
                  /usr/share/doc/tidy-cvs_20101110
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "tidy=>`date`" | sudo tee -a $INSTALLED_LIST