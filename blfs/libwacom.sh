#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The libwacom package contains abr3ak library used to identify wacom tablets and their model-specificbr3ak features.br3ak"
SECTION="general"
VERSION=0.22
NAME="libwacom"

#REQ:libgudev
#REC:libxml2
#OPT:gtk2
#OPT:librsvg


wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2 || wget -nc http://downloads.sourceforge.net/linuxwacom/libwacom/libwacom-0.22.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2


URL=http://downloads.sourceforge.net/linuxwacom/libwacom/libwacom-0.22.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
