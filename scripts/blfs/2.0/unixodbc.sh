#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.unixodbc.org/unixODBC-2.3.2.tar.gz
wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/unixODBC-2.3.2.tar.gz


TARBALL=unixODBC-2.3.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc/unixODBC &&
make

cat > 1434987998770.sh << "ENDOFFILE"
make install &&

find doc -name "Makefile*" -delete              &&
chmod 644 doc/{lst,ProgrammerManual/Tutorial}/* &&

install -v -m755 -d /usr/share/doc/unixODBC-2.3.2 &&
cp      -v -R doc/* /usr/share/doc/unixODBC-2.3.2
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "unixodbc=>`date`" | sudo tee -a $INSTALLED_LIST