#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:enchant:1.6.0

#REQ:glib2
#REC:aspell
#OPT:dbus-glib


cd $SOURCE_DIR

URL=http://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz

wget -nc http://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz || wget -nc ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/enchant-1.6.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -svfn ../../lib/aspell /usr/share/enchant/aspell

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat > /tmp/test-enchant.txt << "EOF"
Tel me more abot linux
Ther ar so many commads
EOF
enchant -d en_GB -l /tmp/test-enchant.txt &&
enchant -d en_GB -a /tmp/test-enchant.txt


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "enchant=>`date`" | sudo tee -a $INSTALLED_LIST

