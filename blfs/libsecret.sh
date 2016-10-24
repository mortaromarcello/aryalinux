#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The libsecret package contains abr3ak GObject based library for accessing the Secret Service API.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:glib2
#REQ:gnome-keyring
#REC:gobject-introspection
#REC:libgcrypt
#REC:vala
#OPT:gtk-doc
#OPT:docbook
#OPT:docbook-xsl
#OPT:libxslt
#OPT:python-modules#dbus-python
#OPT:gjs
#OPT:python-modules#pygobject2


#VER:libsecret:0.18.5


NAME="libsecret"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsecret/libsecret-0.18.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsecret/libsecret-0.18.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsecret/libsecret-0.18.5.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsecret/libsecret-0.18.5.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.5.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsecret/libsecret-0.18.5.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.5.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
