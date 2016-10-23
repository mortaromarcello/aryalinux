#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The keybinder2 package contains abr3ak utility library registering global X keyboard shortcuts.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:gtk2
#REC:gobject-introspection
#REC:python-modules#pygtk
#OPT:gtk-doc
#OPT:lua


#VER:keybinder:0.3.0


NAME="keybinder2"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://pkgs.fedoraproject.org/repo/pkgs/keybinder/keybinder-0.3.0.tar.gz/2a0aed62ba14d1bf5c79707e20cb4059/keybinder-0.3.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz


URL=http://pkgs.fedoraproject.org/repo/pkgs/keybinder/keybinder-0.3.0.tar.gz/2a0aed62ba14d1bf5c79707e20cb4059/keybinder-0.3.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-lua &&
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
