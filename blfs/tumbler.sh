#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Tumbler package contains abr3ak D-Bus thumbnailing service basedbr3ak on the thumbnail management D-Busbr3ak specification. This is useful for generating thumbnail images ofbr3ak files.br3ak
#SECTION:xfce

whoami > /tmp/currentuser

#REQ:dbus-glib
#OPT:curl
#OPT:freetype2
#OPT:gdk-pixbuf
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:libjpeg
#OPT:libgsf
#OPT:libpng
#OPT:poppler


#VER:tumbler:0.1.31


NAME="tumbler"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/tumbler/0.1/tumbler-0.1.31.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2


URL=http://archive.xfce.org/src/xfce/tumbler/0.1/tumbler-0.1.31.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
