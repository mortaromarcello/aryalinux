#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Telepathy Logger package is abr3ak headless observer client that logs information received by thebr3ak Telepathy framework. It featuresbr3ak pluggable backends to log different sorts of messages in differentbr3ak formats.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:sqlite
#REQ:telepathy-glib
#REC:gobject-introspection
#OPT:gtk-doc


#VER:telepathy-logger:0.8.2


NAME="telepathy-logger"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-logger/telepathy-logger-0.8.2.tar.bz2


URL=http://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-0.8.2.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
