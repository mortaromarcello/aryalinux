#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-tweak-tool:3.14.2

#REQ:gtk3
#REQ:gsettings-desktop-schemas
#REQ:python-modules#pygobject3


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.14/gnome-tweak-tool-3.14.2.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.14.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.14/gnome-tweak-tool-3.14.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.14.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.14.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.14.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-tweak-tool/gnome-tweak-tool-3.14.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-tweak-tool/3.14/gnome-tweak-tool-3.14.2.tar.xz

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
echo "gnome-tweak-tool=>`date`" | sudo tee -a $INSTALLED_LIST

