#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#VER:net-snmp:5.7.3

cd $SOURCE_DIR

URL=downloads.sourceforge.net/net-snmp/net-snmp-5.7.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
wget -c $URL || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/net-snmp/net-snmp-5.7.3.tar.gz/d4a3459e1577d0efa8d96ca70a885e53/net-snmp-5.7.3.tar.gz || wget -nc http://sourceforge.mirrorservice.org/n/ne/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz || wget -nc http://ftp.ntua.gr/mirror/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz 
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "net-snmp=>`date`" | sudo tee -a $INSTALLED_LIST
