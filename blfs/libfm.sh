#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libfm package contains abr3ak library used to develop file managers providing some filebr3ak management utilities.br3ak
#SECTION:lxde

#REQ:gtk2
#REQ:menu-cache
#REC:libexif
#REC:vala
#REC:lxmenu-data
#OPT:dbus-glib
#OPT:udisks
#OPT:gvfs
#OPT:gtk-doc


#VER:libfm:1.2.4


NAME="libfm"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz || wget -nc http://downloads.sourceforge.net/pcmanfm/libfm-1.2.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libfm/libfm-1.2.4.tar.xz


URL=http://downloads.sourceforge.net/pcmanfm/libfm-1.2.4.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-static  &&
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
