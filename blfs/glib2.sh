#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:glib:2.46.2

#REQ:libffi
#REQ:python2
#REQ:python3
#REC:pcre
#OPT:elfutils
#OPT:gtk-doc
#OPT:shared-mime-info
#OPT:desktop-file-utils


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/glib/2.46/glib-2.46.2.tar.xz

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib/2.46/glib-2.46.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glib/glib-2.46.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib/glib-2.46.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glib/glib-2.46.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/glib/2.46/glib-2.46.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glib/glib-2.46.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib/glib-2.46.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --with-pcre=system &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "glib2=>`date`" | sudo tee -a $INSTALLED_LIST

