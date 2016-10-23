#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libxklavier package contains abr3ak utility library for X keyboard.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:glib2
#REQ:iso-codes
#REQ:libxml2
#REQ:x7lib
#REC:gobject-introspection
#OPT:gtk-doc
#OPT:vala


#VER:libxklavier:5.4


NAME="libxklavier"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2 || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/libxklavier/libxklavier-5.4.tar.bz2/13af74dcb6011ecedf1e3ed122bd31fa/libxklavier-5.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libxklavier/libxklavier-5.4.tar.bz2


URL=http://pkgs.fedoraproject.org/repo/pkgs/libxklavier/libxklavier-5.4.tar.bz2/13af74dcb6011ecedf1e3ed122bd31fa/libxklavier-5.4.tar.bz2
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
