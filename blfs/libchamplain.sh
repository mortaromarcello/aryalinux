#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libchamplain:0.12.12

#REQ:clutter
#REQ:gtk3
#REQ:libsoup
#REC:clutter-gtk
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.12.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libchamplain/libchamplain-0.12.12.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.12.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libchamplain/0.12/libchamplain-0.12.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libchamplain/libchamplain-0.12.12.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --enable-vala    \
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
echo "libchamplain=>`date`" | sudo tee -a $INSTALLED_LIST

