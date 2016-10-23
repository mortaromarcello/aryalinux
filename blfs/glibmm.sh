#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GLibmm package is a set of C++br3ak bindings for GLib.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#REQ:libsigc
#OPT:doxygen
#OPT:glib-networking
#OPT:gnutls
#OPT:libxslt


#VER:glibmm:2.50.0


NAME="glibmm"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glibmm/glibmm-2.50.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glibmm/2.50/glibmm-2.50.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/glibmm/2.50/glibmm-2.50.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glibmm/glibmm-2.50.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glibmm/glibmm-2.50.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glibmm/glibmm-2.50.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glibmm/glibmm-2.50.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/glibmm/2.50/glibmm-2.50.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e '/^libdocdir =/ s/$(book_name)/glibmm-2.50.0/' \
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST