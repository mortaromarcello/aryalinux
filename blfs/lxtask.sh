#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The LXTask package contains abr3ak lightweight and desktop-independent task manager.br3ak"
SECTION="lxde"
VERSION=0.1.7
NAME="lxtask"

#REQ:gtk2


wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxtask/lxtask-0.1.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxtask/lxtask-0.1.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxtask/lxtask-0.1.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxtask/lxtask-0.1.7.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/lxtask-0.1.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxtask/lxtask-0.1.7.tar.xz


URL=http://downloads.sourceforge.net/lxde/lxtask-0.1.7.tar.xz
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
