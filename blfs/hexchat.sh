#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak HexChat is an IRC chat program. Itbr3ak allows you to join multiple IRC channels (chat rooms) at the samebr3ak time, talk publicly, have private one-on-one conversations, etc.br3ak File transfers are also possible.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

#REQ:glib2
#REC:gtk2
#REC:lua
#OPT:dbus-glib
#OPT:iso-codes
#OPT:libcanberra
#OPT:libnotify
#OPT:openssl
#OPT:pciutils


#VER:hexchat:2.12.2


NAME="hexchat"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/hexchat/hexchat-2.12.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/hexchat/hexchat-2.12.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/hexchat/hexchat-2.12.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/hexchat/hexchat-2.12.2.tar.xz || wget -nc https://dl.hexchat.net/hexchat/hexchat-2.12.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/hexchat/hexchat-2.12.2.tar.xz


URL=https://dl.hexchat.net/hexchat/hexchat-2.12.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
