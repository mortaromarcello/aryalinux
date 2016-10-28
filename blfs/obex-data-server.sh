#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak OBEX Data Server package containsbr3ak D-Bus service providing high-level OBEX client and server sidebr3ak functionality.br3ak
#SECTION:general

#REQ:bluez
#REQ:dbus-glib
#REQ:imagemagick
#REQ:gdk-pixbuf
#REQ:libusb-compat
#REQ:openobex


#VER:obex-data-server:0.4.6


NAME="obex-data-server"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz || wget -nc http://tadas.dailyda.com/software/obex-data-server-0.4.6.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/obex-data-server/obex-data-server-0.4.6.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/obex-data-server-0.4.6-build-fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/obex-data-server/obex-data-server-0.4.6-build-fixes-1.patch


URL=http://tadas.dailyda.com/software/obex-data-server-0.4.6.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../obex-data-server-0.4.6-build-fixes-1.patch &&

./configure --prefix=/usr --sysconfdir=/etc &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
