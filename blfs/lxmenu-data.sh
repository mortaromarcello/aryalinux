#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The LXMenu Data package providesbr3ak files required to build freedesktop.org menu spec-compliant desktopbr3ak menus for LXDE.br3ak"
SECTION="lxde"
VERSION=0.1.5
NAME="lxmenu-data"



cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/lxde/lxmenu-data-0.1.5.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxmenu-data/lxmenu-data-0.1.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxmenu-data/lxmenu-data-0.1.5.tar.xz || wget -nc http://downloads.sourceforge.net/lxde/lxmenu-data-0.1.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxmenu-data/lxmenu-data-0.1.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxmenu-data/lxmenu-data-0.1.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxmenu-data/lxmenu-data-0.1.5.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
