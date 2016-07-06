#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:epiphany:3.14.2

#REQ:avahi
#REQ:gcr
#REQ:gnome-desktop
#REQ:libnotify
#REQ:libwnck
#REQ:webkitgtk
#REC:nss
#OPT:lsb-release
#OPT:gnome-keyring


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/epiphany/3.14/epiphany-3.14.2.tar.xz

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/epiphany/3.14/epiphany-3.14.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/epiphany/epiphany-3.14.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/epiphany/epiphany-3.14.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/epiphany/epiphany-3.14.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/epiphany/3.14/epiphany-3.14.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/epiphany/epiphany-3.14.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/epiphany/epiphany-3.14.2.tar.xz

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
echo "epiphany=>`date`" | sudo tee -a $INSTALLED_LIST

