#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:rep-gtk_:0.90.8.3

#REQ:gtk2
#REQ:librep


cd $SOURCE_DIR

URL=http://download.tuxfamily.org/librep/rep-gtk/rep-gtk_0.90.8.3.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rep-gtk/rep-gtk_0.90.8.3.tar.xz || wget -nc http://download.tuxfamily.org/librep/rep-gtk/rep-gtk_0.90.8.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./autogen.sh --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "rep-gtk=>`date`" | sudo tee -a $INSTALLED_LIST

