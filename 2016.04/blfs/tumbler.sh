#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:tumbler:0.1.31

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


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/xfce/tumbler/0.1/tumbler-0.1.31.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/tumbler/tumbler-0.1.31.tar.bz2 || wget -nc http://archive.xfce.org/src/xfce/tumbler/0.1/tumbler-0.1.31.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "tumbler=>`date`" | sudo tee -a $INSTALLED_LIST

