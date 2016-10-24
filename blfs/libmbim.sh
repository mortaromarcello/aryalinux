#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The libmbim package contains abr3ak GLib-based library for talking to WWAN modems and devices whichbr3ak speak the Mobile Interface Broadband Model (MBIM) protocol.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libgudev
#OPT:gtk-doc


#VER:libmbim:1.14.0


NAME="libmbim"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmbim/libmbim-1.14.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmbim/libmbim-1.14.0.tar.xz || wget -nc http://www.freedesktop.org/software/libmbim/libmbim-1.14.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmbim/libmbim-1.14.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmbim/libmbim-1.14.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmbim/libmbim-1.14.0.tar.xz


URL=http://www.freedesktop.org/software/libmbim/libmbim-1.14.0.tar.xz
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
