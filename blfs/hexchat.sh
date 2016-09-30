#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:hexchat:2.12.1

#REQ:glib2
#REC:gtk2
#REC:lua
#OPT:dbus-glib
#OPT:iso-codes
#OPT:libcanberra
#OPT:libnotify
#OPT:openssl
#OPT:pciutils


cd $SOURCE_DIR

URL=https://dl.hexchat.net/hexchat/hexchat-2.12.1.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/hexchat/hexchat-2.12.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/hexchat/hexchat-2.12.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/hexchat/hexchat-2.12.1.tar.xz || wget -nc https://dl.hexchat.net/hexchat/hexchat-2.12.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/hexchat/hexchat-2.12.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/hexchat/hexchat-2.12.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "hexchat=>`date`" | sudo tee -a $INSTALLED_LIST

