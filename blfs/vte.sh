#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:vte:0.44.2

#REQ:gtk3
#REQ:libxml2
#REC:gobject-introspection
#OPT:gnutls
#OPT:gtk-doc
#OPT:vala


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/vte/0.44/vte-0.44.2.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.44.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.44.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/vte/0.44/vte-0.44.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vte/vte-0.44.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vte/0.44/vte-0.44.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vte/vte-0.44.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vte/vte-0.44.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/Werror/d' configure.ac &&
autoreconf                      &&
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --disable-static       \
            --enable-introspection &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "vte=>`date`" | sudo tee -a $INSTALLED_LIST

