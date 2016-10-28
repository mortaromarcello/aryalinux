#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GConf package contains abr3ak configuration database system used by many GNOME applications.br3ak
#SECTION:gnome

#REQ:dbus-glib
#REQ:libxml2
#REC:gobject-introspection
#REC:gtk3
#REC:polkit
#OPT:gtk-doc
#OPT:openldap


#VER:GConf:3.2.6


NAME="GConf"

wget -nc http://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gc/GConf-3.2.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gc/GConf-3.2.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gc/GConf-3.2.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gc/GConf-3.2.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gc/GConf-3.2.6.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-orbit \
            --disable-static &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
ln -s gconf.xml.defaults /etc/gconf/gconf.xml.system
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
