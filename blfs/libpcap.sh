#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libpcap:1.7.4

#OPT:bluez
#OPT:libnl
#OPT:libusb


cd $SOURCE_DIR

URL=http://www.tcpdump.org/release/libpcap-1.7.4.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpcap/libpcap-1.7.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpcap/libpcap-1.7.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpcap/libpcap-1.7.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpcap/libpcap-1.7.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpcap/libpcap-1.7.4.tar.gz || wget -nc http://www.tcpdump.org/release/libpcap-1.7.4.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/7.10/libpcap-1.7.4-enable_bluetooth-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/libpcap/libpcap-1.7.4-enable_bluetooth-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../libpcap-1.7.4-enable_bluetooth-1.patch &&
./configure --prefix=/usr &&
make "-j`nproc`"


sed -i '/INSTALL_DATA.*libpcap.a\|RANLIB.*libpcap.a/ s/^/#/' Makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libpcap=>`date`" | sudo tee -a $INSTALLED_LIST

