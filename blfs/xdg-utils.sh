#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak xdg-utils is a a set of commandbr3ak line tools that assist applications with a variety of desktopbr3ak integration tasks. It is required for Linux Standards Base (LSB)br3ak conformance.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:xmlto
#REQ:lynx
#REQ:w3m
#REQ:links
#REQ:x7app
#OPT:dbus


#VER:xdg-utils:1.1.1


NAME="xdg-utils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xdg-utils/xdg-utils-1.1.1.tar.gz || wget -nc http://portland.freedesktop.org/download/xdg-utils-1.1.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xdg-utils/xdg-utils-1.1.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xdg-utils/xdg-utils-1.1.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xdg-utils/xdg-utils-1.1.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xdg-utils/xdg-utils-1.1.1.tar.gz


URL=http://portland.freedesktop.org/download/xdg-utils-1.1.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --mandir=/usr/share/man &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST