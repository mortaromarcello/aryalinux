#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libsecret:0.18.4

#REQ:glib2
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
#OPT:gnome-keyring


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.4.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsecret/libsecret-0.18.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libsecret/libsecret-0.18.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libsecret/libsecret-0.18.4.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libsecret/libsecret-0.18.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libsecret/libsecret-0.18.4.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.4.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
echo "libsecret=>`date`" | sudo tee -a $INSTALLED_LIST

