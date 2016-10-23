#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The librsvg package contains abr3ak library and tools used to manipulate, convert and view Scalablebr3ak Vector Graphic (SVG) images.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:gdk-pixbuf
#REQ:libcroco
#REQ:pango
#REC:gobject-introspection
#REC:gtk3
#REC:vala
#OPT:gtk-doc


#VER:librsvg:2.40.16


NAME="librsvg"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/librsvg/librsvg-2.40.16.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/librsvg-2.40.16.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/librsvg/librsvg-2.40.16.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/librsvg/librsvg-2.40.16.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/librsvg-2.40.16.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/librsvg/librsvg-2.40.16.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/librsvg/librsvg-2.40.16.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/librsvg-2.40.16.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
