#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:glibmm:2.48.1

#REQ:glib2
#REQ:libsigc
#OPT:doxygen
#OPT:glib-networking
#OPT:gnutls
#OPT:libxslt


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/glibmm/2.48/glibmm-2.48.1.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glibmm/glibmm-2.48.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glibmm/glibmm-2.48.1.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/glibmm/2.48/glibmm-2.48.1.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glibmm/2.48/glibmm-2.48.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glibmm/glibmm-2.48.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glibmm/glibmm-2.48.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glibmm/glibmm-2.48.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/^libdocdir =/ s/$(book_name)/glibmm-2.48.1/' \
    -i docs/Makefile.in


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
echo "glibmm=>`date`" | sudo tee -a $INSTALLED_LIST

