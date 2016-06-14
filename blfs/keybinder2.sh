#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:keybinder:0.3.0

#REQ:gtk2
#REC:gobject-introspection
#REC:python-modules#pygtk
#OPT:gtk-doc


cd $SOURCE_DIR

URL=http://pkgs.fedoraproject.org/repo/pkgs/keybinder/keybinder-0.3.0.tar.gz/2a0aed62ba14d1bf5c79707e20cb4059/keybinder-0.3.0.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/keybinder/keybinder-0.3.0.tar.gz/2a0aed62ba14d1bf5c79707e20cb4059/keybinder-0.3.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/keybinder/keybinder-0.3.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-lua &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "keybinder2=>`date`" | sudo tee -a $INSTALLED_LIST

