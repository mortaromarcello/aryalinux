#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The UDisks package provides abr3ak storage daemon that implements well-defined D-Bus interfaces thatbr3ak can be used to query and manipulate storage devices.br3ak
#SECTION:general

#REQ:dbus-glib
#REQ:libatasmart
#REQ:libgudev
#REQ:lvm2
#REQ:parted
#REQ:polkit
#REQ:sg3_utils
#REC:systemd
#OPT:gtk-doc
#OPT:libxslt
#OPT:sudo


#VER:udisks:1.0.5


NAME="udisks"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc http://hal.freedesktop.org/releases/udisks-1.0.5.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/udisks/udisks-1.0.5.tar.gz


URL=http://hal.freedesktop.org/releases/udisks-1.0.5.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make profiledir=/etc/bash_completion.d install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
