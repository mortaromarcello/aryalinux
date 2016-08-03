#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:net-snmp:5.7.3

cd $SOURCE_DIR

URL=downloads.sourceforge.net/net-snmp/net-snmp-5.7.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
wget -nc $URL
wget -nc aryalinux.org/releases/2016.08/net-snmp-5.7.3-fixes.patch

DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../net-snmp-5.7.3-fixes.patch &&
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "net-snmp=>`date`" | sudo tee -a $INSTALLED_LIST
