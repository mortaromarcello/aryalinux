#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The rest package contains abr3ak library that was designed to make it easier to access web servicesbr3ak that claim to be "RESTful". It includes convenience wrappers forbr3ak libsoup and libxml to ease remote use of the RESTful API.br3ak
#SECTION:gnome

whoami > /tmp/currentuser

#REQ:cacerts
#REQ:libsoup
#REC:gobject-introspection
#OPT:gtk-doc


#VER:rest:0.8.0


NAME="rest"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/rest/rest-0.8.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/rest/rest-0.8.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/rest/rest-0.8.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/rest/rest-0.8.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/rest/rest-0.8.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/rest/0.8/rest-0.8.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" build/ltmain.sh &&
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
