#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Telepathy GLib contains abr3ak library used by GLib basedbr3ak Telepathy components. Telepathy isbr3ak a D-Bus framework for unifyingbr3ak real time communication, including instant messaging, voice callsbr3ak and video calls. It abstracts differences between protocols tobr3ak provide a unified interface for applications.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:dbus-glib
#REQ:libxslt
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


#VER:telepathy-glib:0.24.1


NAME="telepathy-glib"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz


URL=http://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --enable-vala-bindings \
            --disable-static &&
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
