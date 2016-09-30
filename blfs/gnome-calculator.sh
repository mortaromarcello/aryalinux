#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-calculator:3.20.2

#REQ:gtk3
#REQ:gtksourceview
#REQ:itstool
#REC:vala


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.20/gnome-calculator-3.20.2.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-calculator/gnome-calculator-3.20.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-calculator/gnome-calculator-3.20.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-calculator/gnome-calculator-3.20.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.20/gnome-calculator-3.20.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-calculator/gnome-calculator-3.20.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-calculator/gnome-calculator-3.20.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-calculator/3.20/gnome-calculator-3.20.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

cp -v ../history-{entry,view}.ui data/


./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gnome-calculator=>`date`" | sudo tee -a $INSTALLED_LIST

