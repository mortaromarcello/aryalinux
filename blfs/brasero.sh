#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:brasero:3.12.0

#REQ:gst10-plugins-base
#REQ:itstool
#REQ:libcanberra
#REQ:libnotify
#REC:gobject-introspection
#REC:libburn
#REC:libisofs
#REC:nautilus
#REC:totem-pl-parser
#REC:dvd-rw-tools
#REC:gvfs
#OPT:gtk-doc
#OPT:cdrdao
#OPT:libdvdcss


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.0.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/brasero/brasero-3.12.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/brasero/brasero-3.12.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/brasero/brasero-3.12.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/brasero/brasero-3.12.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/brasero/brasero-3.12.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.0.tar.xz

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
echo "brasero=>`date`" | sudo tee -a $INSTALLED_LIST

