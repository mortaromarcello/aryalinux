#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gtksourceview:3.20.4

#REQ:gtk3
#REC:gobject-introspection
#OPT:vala
#OPT:gtk-doc
#OPT:itstool
#OPT:fop


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.20/gtksourceview-3.20.4.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.20.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.20.4.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.20/gtksourceview-3.20.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.20.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtksourceview/gtksourceview-3.20.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtksourceview/gtksourceview-3.20.4.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtksourceview/3.20/gtksourceview-3.20.4.tar.xz

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
echo "gtksourceview=>`date`" | sudo tee -a $INSTALLED_LIST

