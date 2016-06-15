#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gdm:3.16.2

#REQ:accountsservice
#REQ:gtk3
#REQ:iso-codes
#REQ:itstool
#REQ:libcanberra
#REQ:linux-pam
#REQ:gnome-session
#REQ:gnome-shell
#REQ:systemd
#OPT:check


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gdm/3.16/gdm-3.16.2.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/gdm/3.16/gdm-3.16.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gdm/gdm-3.16.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gdm/gdm-3.16.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdm/gdm-3.16.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdm/3.16/gdm-3.16.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gdm/gdm-3.16.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdm/gdm-3.16.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 21 gdm &&
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
        -g gdm -s /bin/false gdm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-plymouth   \
            --disable-static     &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 data/gdm.service /lib/systemd/system/gdm.service

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable gdm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gdm=>`date`" | sudo tee -a $INSTALLED_LIST

