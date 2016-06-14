#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ModemManager:1.4.10

#REQ:libgudev
#REC:gobject-introspection
#REC:libmbim
#REC:libqmi
#REC:polkit
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/ModemManager/ModemManager-1.4.10.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ModemManager/ModemManager-1.4.10.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ModemManager/ModemManager-1.4.10.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ModemManager/ModemManager-1.4.10.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ModemManager/ModemManager-1.4.10.tar.xz || wget -nc http://www.freedesktop.org/software/ModemManager/ModemManager-1.4.10.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ModemManager/ModemManager-1.4.10.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable ModemManager

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ModemManager=>`date`" | sudo tee -a $INSTALLED_LIST

