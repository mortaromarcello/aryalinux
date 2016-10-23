#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Vte is a library (libvte)br3ak implementing a terminal emulator widget for GTK+ 2, and a minimal demonstrationbr3ak application (vte) that uses libvte.br3ak
#SECTION:xfce

whoami > /tmp/currentuser

#REQ:gtk2
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:python-modules#pygtk


#VER:vte:0.28.2


NAME="vte2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.28.2.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --libexecdir=/usr/lib/vte \
            --disable-static  &&
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