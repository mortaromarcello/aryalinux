#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The xine User Interface packagebr3ak contains a multimedia player. It plays back CDs, DVDs and VCDs. Itbr3ak also decodes multimedia files like AVI, MOV, WMV, MPEG and MP3 frombr3ak local disk drives, and displays multimedia streamed over thebr3ak Internet.br3ak
#SECTION:multimedia

#REQ:xine-lib
#REQ:shared-mime-info
#OPT:curl
#OPT:aalib


#VER:xine-ui:0.99.9


NAME="xine-ui"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://downloads.sourceforge.net/xine/xine-ui-0.99.9.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz


URL=http://downloads.sourceforge.net/xine/xine-ui-0.99.9.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docsdir=/usr/share/doc/xine-ui-0.99.9 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
