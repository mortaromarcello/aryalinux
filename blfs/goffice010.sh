#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:goffice:0.10.32

#REQ:gtk3
#REQ:libgsf
#REQ:librsvg
#REQ:libxslt
#REQ:general_which
#OPT:gobject-introspection
#OPT:gs
#OPT:gsettings-desktop-schemas
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/goffice/0.10/goffice-0.10.32.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/goffice/0.10/goffice-0.10.32.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/goffice/goffice-0.10.32.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/goffice/0.10/goffice-0.10.32.tar.xz

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
echo "goffice010=>`date`" | sudo tee -a $INSTALLED_LIST

