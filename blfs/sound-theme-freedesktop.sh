#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The Sound Theme Freedesktopbr3ak package contains sound themes for the desktop.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser



#VER:sound-theme-freedesktop:0.8


NAME="sound-theme-freedesktop"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc http://people.freedesktop.org/~mccann/dist/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2


URL=http://people.freedesktop.org/~mccann/dist/sound-theme-freedesktop-0.8.tar.bz2
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
