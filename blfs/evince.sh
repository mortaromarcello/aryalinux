#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:evince:3.14.1

#REQ:adwaita-icon-theme
#REQ:gtk3
#REQ:itstool
#REC:gnome-desktop
#REC:gobject-introspection
#REC:gsettings-desktop-schemas
#REC:libsecret
#REC:nautilus
#REC:poppler
#OPT:gtk-doc
#OPT:texlive


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/evince/3.14/evince-3.14.1.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/evince/evince-3.14.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evince/3.14/evince-3.14.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/evince/3.14/evince-3.14.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/evince/evince-3.14.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/evince/evince-3.14.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/evince/evince-3.14.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/evince/evince-3.14.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr           \
            --enable-introspection  \
            --disable-static        &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "evince=>`date`" | sudo tee -a $INSTALLED_LIST

