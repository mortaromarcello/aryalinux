#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

cd $SOURCE_DIR

URL=downloads.sourceforge.net/net-snmp/net-snmp-5.7.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
wget -c $URL
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "net-snmp=>`date`" | sudo tee -a $INSTALLED_LIST
