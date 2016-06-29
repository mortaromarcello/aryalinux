#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:dhcpcd:6.11.0

#OPT:llvm


cd $SOURCE_DIR

URL=http://roy.marples.name/downloads/dhcpcd/dhcpcd-6.11.0.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/dhcpcd/dhcpcd-6.11.0.tar.xz || wget -nc http://roy.marples.name/downloads/dhcpcd/dhcpcd-6.11.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/dhcpcd/dhcpcd-6.11.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/dhcpcd/dhcpcd-6.11.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/dhcpcd/dhcpcd-6.11.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/dhcpcd/dhcpcd-6.11.0.tar.xz || wget -nc ftp://roy.marples.name/pub/dhcpcd/dhcpcd-6.11.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --libexecdir=/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20160602.tar.xz -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602.tar.xz
make install-dhcpcd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602.tar.xz
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "dhcpcd=>`date`" | sudo tee -a $INSTALLED_LIST

