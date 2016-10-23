#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libcroco package contains abr3ak standalone CSS2 parsing and manipulation library.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#REQ:libxml2
#OPT:gtk-doc


#VER:libcroco:0.6.11


NAME="libcroco"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libcroco/libcroco-0.6.11.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libcroco/libcroco-0.6.11.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/libcroco-0.6.11.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libcroco/libcroco-0.6.11.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcroco/libcroco-0.6.11.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libcroco/libcroco-0.6.11.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/libcroco-0.6.11.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/libcroco-0.6.11.tar.xz
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
