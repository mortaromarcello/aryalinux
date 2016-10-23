#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GLib package containsbr3ak low-level libraries useful for providing data structure handlingbr3ak for C, portability wrappers and interfaces for such runtimebr3ak functionality as an event loop, threads, dynamic loading and anbr3ak object system.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libffi
#REQ:python2
#REQ:python3
#REC:pcre
#OPT:dbus
#OPT:elfutils
#OPT:gtk-doc
#OPT:shared-mime-info
#OPT:desktop-file-utils


#VER:glib:2.50.0


NAME="glib2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-2.50.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/glib/glib-2.50.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-2.50.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/glib/2.50/glib-2.50.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST