#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gedit:3.14.3

#REQ:gsettings-desktop-schemas
#REQ:gtksourceview
#REQ:itstool
#REQ:libpeas
#REC:enchant
#REC:iso-codes
#REC:libsoup
#REC:python-modules#pygobject3
#REC:vala
#REC:gvfs
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gedit/3.14/gedit-3.14.3.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gedit/gedit-3.14.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gedit/gedit-3.14.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gedit/gedit-3.14.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gedit/3.14/gedit-3.14.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gedit/gedit-3.14.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gedit/gedit-3.14.3.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gedit/3.14/gedit-3.14.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
echo "gedit=>`date`" | sudo tee -a $INSTALLED_LIST

