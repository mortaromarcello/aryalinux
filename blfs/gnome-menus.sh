#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The GNOME Menus package containsbr3ak an implementation of the draft <a class="ulink" href="http://www.freedesktop.org/Standards/menu-spec">Desktop Menubr3ak Specification</a> from freedesktop.org. It also contains thebr3ak GNOME menu layout configurationbr3ak files, <code class="filename">.directory files and a menubr3ak related utility program.br3ak"
SECTION="gnome"
VERSION=3.13.3
NAME="gnome-menus"

#REQ:glib2
#REC:gobject-introspection


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gnome-menus/3.13/gnome-menus-3.13.3.tar.xz

if [ ! -z $URL ]
then
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-menus/3.13/gnome-menus-3.13.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-menus/3.13/gnome-menus-3.13.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-menus/gnome-menus-3.13.3.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
