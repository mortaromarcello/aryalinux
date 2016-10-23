#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Vala is a new programming languagebr3ak that aims to bring modern programming language features tobr3ak GNOME developers without imposingbr3ak any additional runtime requirements and without using a differentbr3ak ABI compared to applications and libraries written in C.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#OPT:dbus
#OPT:libxslt


#VER:vala:0.34.1


NAME="vala"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vala/vala-0.34.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vala/vala-0.34.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vala/vala-0.34.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/vala/0.34/vala-0.34.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vala/vala-0.34.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vala/vala-0.34.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vala/0.34/vala-0.34.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/vala/0.34/vala-0.34.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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
