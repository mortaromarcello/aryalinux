#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Gucharmap is a Unicode characterbr3ak map and font viewer. It allows you to browse through all thebr3ak available Unicode characters and categories for the installedbr3ak fonts, and to examine their detailed properties. It is an easy waybr3ak to find the character you might only know by its Unicode name orbr3ak code point.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:appstream-glib
#REQ:desktop-file-utils
#REQ:gtk3
#REQ:itstool
#REQ:wget
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


#VER:gucharmap:9.0.1


NAME="gucharmap"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gucharmap/9.0/gucharmap-9.0.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gucharmap/9.0/gucharmap-9.0.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gucharmap/gucharmap-9.0.1.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gucharmap/9.0/gucharmap-9.0.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --enable-vala \
            --with-unicode-data=download &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
