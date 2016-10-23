#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Folks is a library that aggregatesbr3ak people from multiple sources (e.g, Telepathy connection managers and eventuallybr3ak Evolution Data Server, Facebook,br3ak etc.) to create metacontacts.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:evolution-data-server
#REQ:gobject-introspection
#REQ:libgee
#REQ:telepathy-glib
#REC:python3
#REC:vala


#VER:folks:0.11.3


NAME="folks"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/folks/0.11/folks-0.11.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/folks/folks-0.11.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/folks/folks-0.11.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/folks/folks-0.11.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/folks/folks-0.11.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/folks/folks-0.11.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/folks/0.11/folks-0.11.3.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/folks/0.11/folks-0.11.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-fatal-warnings &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
