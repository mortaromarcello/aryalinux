#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak ModemManager provides a unifiedbr3ak high level API for communicating with mobile broadband modems,br3ak regardless of the protocol used to communicate with the actualbr3ak device.br3ak
#SECTION:general

#REQ:libgudev
#REC:gobject-introspection
#REC:libmbim
#REC:libqmi
#REC:polkit
#REC:vala
#OPT:gtk-doc


#VER:ModemManager:1.6.2


NAME="ModemManager"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ModemManager/ModemManager-1.6.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ModemManager/ModemManager-1.6.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ModemManager/ModemManager-1.6.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ModemManager/ModemManager-1.6.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ModemManager/ModemManager-1.6.2.tar.xz || wget -nc http://www.freedesktop.org/software/ModemManager/ModemManager-1.6.2.tar.xz


URL=http://www.freedesktop.org/software/ModemManager/ModemManager-1.6.2.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr                 \
            --sysconfdir=/etc             \
            --localstatedir=/var          \
            --enable-more-warnings=no     \
            --with-suspend-resume=systemd \
            --disable-static &&
make


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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
