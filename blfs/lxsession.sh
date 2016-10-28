#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The LXSession package contains thebr3ak default session manager for LXDE.br3ak
#SECTION:lxde

#REQ:dbus-glib
#REQ:libunique
#REQ:lsb-release
#REQ:polkit
#REQ:vala
#OPT:gtk3
#OPT:libxslt
#OPT:docbook
#OPT:docbook-xsl


#VER:lxsession:0.5.2


NAME="lxsession"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxsession/lxsession-0.5.2.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/lxsession-0.5.2.tar.xz


URL=http://downloads.sourceforge.net/lxde/lxsession-0.5.2.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-man &&
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
