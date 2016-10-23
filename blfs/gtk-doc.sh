#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GTK-Doc package contains abr3ak code documenter. This is useful for extracting specially formattedbr3ak comments from the code to create API documentation. This package isbr3ak <span class="emphasis"><em>optional</em>; if it is notbr3ak installed, packages will not build the documentation. This does notbr3ak mean that you will not have any documentation. If GTK-Doc is not available, the install processbr3ak will copy any pre-built documentation to your system.br3ak
#SECTION:general

whoami > /tmp/currentuser

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


#VER:gtk-doc:1.25


NAME="gtk-doc"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk-doc/gtk-doc-1.25.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.25.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.25.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.25/gtk-doc-1.25.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.25/gtk-doc-1.25.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.25.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk-doc/gtk-doc-1.25.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.25/gtk-doc-1.25.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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
