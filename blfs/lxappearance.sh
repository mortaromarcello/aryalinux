#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The LXAppearance package containsbr3ak a desktop-independent theme switcher for GTK+.br3ak"
SECTION="lxde"
VERSION=0.6.2
NAME="lxappearance"

#REQ:gtk2
#REC:dbus-glib
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxappearance/lxappearance-0.6.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxappearance/lxappearance-0.6.2.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/lxappearance-0.6.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxappearance/lxappearance-0.6.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxappearance/lxappearance-0.6.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxappearance/lxappearance-0.6.2.tar.xz


URL=http://downloads.sourceforge.net/lxde/lxappearance-0.6.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  \
            --enable-dbus     &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
