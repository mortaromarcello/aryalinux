#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Gedit package contains abr3ak lightweight UTF-8 text editor for the GNOME Desktop.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:gsettings-desktop-schemas
#REQ:gtksourceview
#REQ:itstool
#REQ:libpeas
#REC:gvfs
#REC:iso-codes
#REC:libsoup
#REC:python-modules#pygobject3
#OPT:gtk-doc
#OPT:vala


#VER:gedit:3.22.0


NAME="gedit"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.gnome.org/pub/gnome/sources/gedit/3.22/gedit-3.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gedit/gedit-3.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gedit/gedit-3.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gedit/gedit-3.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gedit/gedit-3.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gedit/gedit-3.22.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gedit/3.22/gedit-3.22.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gedit/3.22/gedit-3.22.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-spell &&
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