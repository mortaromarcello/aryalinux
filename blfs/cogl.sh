#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Cogl is a modern 3D graphics APIbr3ak with associated utility APIs designed to expose the features of 3Dbr3ak graphics hardware using a direct state access API design, asbr3ak opposed to the state-machine style of OpenGL.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:cairo
#REQ:gdk-pixbuf
#REQ:glu
#REQ:mesa
#REQ:pango
#REC:gobject-introspection
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:sdl
#OPT:wayland


#VER:cogl:1.22.2


NAME="cogl"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cogl/cogl-1.22.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --enable-gles1 --enable-gles2 &&
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