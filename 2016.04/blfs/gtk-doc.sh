#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gtk-doc:1.24

#REQ:docbook
#REQ:docbook-xsl
#REQ:itstool
#REQ:libxslt
#OPT:fop
#OPT:glib2
#OPT:general_which
#OPT:openjade
#OPT:sgml-dtd
#OPT:docbook-dsssl
#OPT:python2
#OPT:rarian


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.24/gtk-doc-1.24.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk-doc/gtk-doc-1.24.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.24.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.24.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.24.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.24.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.24/gtk-doc-1.24.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.24/gtk-doc-1.24.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gtk-doc=>`date`" | sudo tee -a $INSTALLED_LIST

