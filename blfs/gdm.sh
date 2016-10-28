#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak GDM is a system service that isbr3ak responsible for providing graphical logins and managing local andbr3ak remote displays.br3ak
#SECTION:gnome

#REQ:accountsservice
#REQ:gtk3
#REQ:iso-codes
#REQ:itstool
#REQ:libcanberra
#REQ:libdaemon
#REQ:linux-pam
#REQ:gnome-session
#REQ:gnome-shell
#REQ:systemd
#OPT:check


#VER:gdm:3.22.0


NAME="gdm"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gdm/gdm-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gdm/gdm-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdm/3.22/gdm-3.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gdm/3.22/gdm-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdm/gdm-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gdm/gdm-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gdm/gdm-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gdm/3.22/gdm-3.22.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 21 gdm &&
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
        -g gdm -s /bin/false gdm
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --localstatedir=/var  \
            --without-plymouth    \
            --disable-static      \
            --enable-gdm-xsession &&
make


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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
