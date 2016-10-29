#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak Transmission is a cross-platform,br3ak open source BitTorrent client. This is useful for downloading largebr3ak files (such as Linux ISOs) and reduces the need for thebr3ak distributors to provide server bandwidth.br3ak"
SECTION="xsoft"
VERSION=2.92
NAME="transmission"

#REQ:curl
#REQ:libevent
#REQ:openssl
#REC:gtk3
#REC:qt5
#OPT:doxygen
#OPT:gdb


cd $SOURCE_DIR

URL=https://transmission.cachefly.net/transmission-2.92.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/transmission/transmission-2.92.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/transmission/transmission-2.92.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/transmission/transmission-2.92.tar.xz || wget -nc https://transmission.cachefly.net/transmission-2.92.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/transmission/transmission-2.92.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/transmission/transmission-2.92.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
