#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:GConf:3.2.6

#REQ:dbus-glib
#REQ:libxml2
#REC:gobject-introspection
#REC:gtk3
#REC:polkit
#OPT:gtk-doc
#OPT:openldap


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/GConf/GConf-3.2.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/GConf/GConf-3.2.6.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/GConf/GConf-3.2.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/GConf/GConf-3.2.6.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/GConf/GConf-3.2.6.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-orbit \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -s gconf.xml.defaults /etc/gconf/gconf.xml.system

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "GConf=>`date`" | sudo tee -a $INSTALLED_LIST

