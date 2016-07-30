#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:sysstat:11.3.5



cd $SOURCE_DIR

URL=http://perso.wanadoo.fr/sebastien.godard/sysstat-11.3.5.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sysstat/sysstat-11.3.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sysstat/sysstat-11.3.5.tar.xz || wget -nc http://perso.wanadoo.fr/sebastien.godard/sysstat-11.3.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sysstat/sysstat-11.3.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sysstat/sysstat-11.3.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sysstat/sysstat-11.3.5.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sa_lib_dir=/usr/lib/sa    \
sa_dir=/var/log/sa        \
conf_dir=/etc/sysconfig   \
./configure --prefix=/usr \
            --disable-file-attr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 sysstat.service /lib/systemd/system/sysstat.service

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable sysstat

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "sysstat=>`date`" | sudo tee -a $INSTALLED_LIST

