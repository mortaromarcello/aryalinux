#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Xfconf is the configurationbr3ak storage system for Xfce.br3ak"
SECTION="xfce"
VERSION=4.12.0
NAME="xfconf"

#REQ:dbus-glib
#REQ:libxfce4util
#OPT:gtk-doc
#OPT:perl-modules#perl-standard-install
#OPT:perl-modules#perl-auto-install


wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfconf/xfconf-4.12.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfconf/xfconf-4.12.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfconf/xfconf-4.12.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfconf/xfconf-4.12.0.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/xfconf/4.12/xfconf-4.12.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfconf/xfconf-4.12.0.tar.bz2


URL=http://archive.xfce.org/src/xfce/xfconf/4.12/xfconf-4.12.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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
