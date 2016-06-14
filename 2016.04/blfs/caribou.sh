#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:caribou:0.4.19

#REQ:clutter
#REQ:gtk3
#REQ:libgee
#REQ:libxklavier
#REQ:python-modules#pygobject3
#REC:vala
#OPT:gtk2
#OPT:python-modules#dbus-python
#OPT:dconf
#OPT:python-modules#pyatspi2


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.19.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/caribou/caribou-0.4.19.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/caribou/caribou-0.4.19.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.19.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/caribou/caribou-0.4.19.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.19.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/caribou/caribou-0.4.19.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/caribou/caribou-0.4.19.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr         \
            --sysconfdir=/etc     \
            --disable-gtk2-module \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "caribou=>`date`" | sudo tee -a $INSTALLED_LIST

