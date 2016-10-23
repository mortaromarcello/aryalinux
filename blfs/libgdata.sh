#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libgdata package is abr3ak GLib-based library for accessing online service APIs using thebr3ak GData protocol, most notably, Google's services. It provides APIsbr3ak to access the common Google services and has full asynchronousbr3ak support.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:liboauth
#REQ:libsoup
#REQ:gtk3
#REQ:json-glib
#REQ:uhttpmock
#REQ:vala
#REC:gcr
#REC:git
#REC:gnome-online-accounts
#REC:gobject-introspection
#OPT:gtk-doc


#VER:libgdata:0.17.6


NAME="libgdata"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgdata/libgdata-0.17.6.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgdata/0.17/libgdata-0.17.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgdata/libgdata-0.17.6.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libgdata/0.17/libgdata-0.17.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgdata/libgdata-0.17.6.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgdata/libgdata-0.17.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgdata/libgdata-0.17.6.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libgdata/0.17/libgdata-0.17.6.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
