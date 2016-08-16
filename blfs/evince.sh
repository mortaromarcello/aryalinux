#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:evince:3.20.1

#REQ:adwaita-icon-theme
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:itstool
#REQ:libxml2
#REC:gnome-keyring
#REC:gobject-introspection
#REC:libsecret
#REC:nautilus
#REC:poppler
#OPT:cups
#OPT:gnome-desktop
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:libtiff
#OPT:texlive
#OPT:tl-installer


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/evince/3.20/evince-3.20.1.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/evince/evince-3.20.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/evince/evince-3.20.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/evince/3.20/evince-3.20.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/evince/evince-3.20.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/evince/evince-3.20.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/evince/3.20/evince-3.20.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/evince/evince-3.20.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                     \
            --enable-compile-warnings=minimum \
            --enable-introspection            \
            --disable-static                  &&
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

