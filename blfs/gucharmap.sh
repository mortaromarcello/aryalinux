#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Gucharmap is a Unicode characterbr3ak map and font viewer. It allows you to browse through all thebr3ak available Unicode characters and categories for the installedbr3ak fonts, and to examine their detailed properties. It is an easy waybr3ak to find the character you might only know by its Unicode name orbr3ak code point.br3ak"
SECTION="gnome"
VERSION=9.0.1
NAME="gucharmap"

#REQ:appstream-glib
#REQ:desktop-file-utils
#REQ:gtk3
#REQ:itstool
#REQ:wget
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gucharmap/9.0/gucharmap-9.0.1.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gucharmap/9.0/gucharmap-9.0.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gucharmap/9.0/gucharmap-9.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --enable-vala \
            --with-unicode-data=download &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
