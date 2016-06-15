#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnome-logs:3.14.2

#REQ:gtk3
#REQ:gsettings-desktop-schemas
#REQ:itstool
#OPT:appstream-glib
#OPT:desktop-file-utils
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-logs/3.14/gnome-logs-3.14.2.tar.xz

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-logs/3.14/gnome-logs-3.14.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-logs/3.14/gnome-logs-3.14.2.tar.xz

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
echo "gnome-logs=>`date`" | sudo tee -a $INSTALLED_LIST

