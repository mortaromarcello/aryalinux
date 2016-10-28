#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libwacom package contains abr3ak library used to identify wacom tablets and their model-specificbr3ak features.br3ak
#SECTION:general

#REQ:libgudev
#REC:libxml2
#OPT:gtk2
#OPT:librsvg


#VER:libwacom:0.22


NAME="libwacom"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2 || wget -nc http://downloads.sourceforge.net/linuxwacom/libwacom/libwacom-0.22.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libwacom/libwacom-0.22.tar.bz2


URL=http://downloads.sourceforge.net/linuxwacom/libwacom/libwacom-0.22.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
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
