#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The uhttpmock package contains abr3ak library for mocking web service APIs which use HTTP or HTTPS.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REQ:libsoup
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


#VER:uhttpmock:0.5.0


NAME="uhttpmock"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/uhttpmock/uhttpmock-0.5.0.tar.xz || wget -nc http://tecnocode.co.uk/downloads/uhttpmock/uhttpmock-0.5.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/uhttpmock/uhttpmock-0.5.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/uhttpmock/uhttpmock-0.5.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/uhttpmock/uhttpmock-0.5.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/uhttpmock/uhttpmock-0.5.0.tar.xz


URL=http://tecnocode.co.uk/downloads/uhttpmock/uhttpmock-0.5.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
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
