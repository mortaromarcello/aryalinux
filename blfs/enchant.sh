#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The enchant package provide abr3ak generic interface into various existing spell checking libraries.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:glib2
#REC:aspell
#OPT:dbus-glib


#VER:enchant:1.6.0


NAME="enchant"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz || wget -nc ftp://ftp.netbsd.org/pub/pkgsrc/distfiles/enchant-1.6.0.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/enchant/enchant-1.6.0.tar.gz


URL=http://www.abisource.com/downloads/enchant/1.6.0/enchant-1.6.0.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST