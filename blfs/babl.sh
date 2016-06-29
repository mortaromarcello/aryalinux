#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:babl:0.1.16

#OPT:gobject-introspection


cd $SOURCE_DIR

URL=http://download.gimp.org/pub/babl/0.1/babl-0.1.16.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/babl/babl-0.1.16.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/babl/babl-0.1.16.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/babl/babl-0.1.16.tar.bz2 || wget -nc http://download.gimp.org/pub/babl/0.1/babl-0.1.16.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/babl/babl-0.1.16.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/babl/babl-0.1.16.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-docs &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/gtk-doc/html/babl/graphics &&
install -v -m644 docs/*.{css,html} /usr/share/gtk-doc/html/babl &&
install -v -m644 docs/graphics/*.{html,png,svg} /usr/share/gtk-doc/html/babl/graphics

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "babl=>`date`" | sudo tee -a $INSTALLED_LIST

