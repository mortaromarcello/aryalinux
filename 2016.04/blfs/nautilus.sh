#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:nautilus:3.18.5

#REQ:gnome-desktop
#REQ:libnotify
#REQ:libxml2
#REC:exempi
#REC:gobject-introspection
#REC:libexif
#REC:adwaita-icon-theme
#REC:gvfs
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/nautilus/3.18/nautilus-3.18.5.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nautilus/nautilus-3.18.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nautilus/nautilus-3.18.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nautilus/nautilus-3.18.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nautilus/nautilus-3.18.5.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/nautilus/3.18/nautilus-3.18.5.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/nautilus/3.18/nautilus-3.18.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nautilus/nautilus-3.18.5.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-tracker    \
            --disable-packagekit &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "nautilus=>`date`" | sudo tee -a $INSTALLED_LIST

