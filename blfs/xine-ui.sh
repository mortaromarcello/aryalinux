#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The xine User Interface packagebr3ak contains a multimedia player. It plays back CDs, DVDs and VCDs. Itbr3ak also decodes multimedia files like AVI, MOV, WMV, MPEG and MP3 frombr3ak local disk drives, and displays multimedia streamed over thebr3ak Internet.br3ak"
SECTION="multimedia"
VERSION=0.99.9
NAME="xine-ui"

#REQ:xine-lib
#REQ:shared-mime-info
#OPT:curl
#OPT:aalib


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/xine/xine-ui-0.99.9.tar.xz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://downloads.sourceforge.net/xine/xine-ui-0.99.9.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xine-ui/xine-ui-0.99.9.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
