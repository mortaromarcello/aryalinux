#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Sound Theme Freedesktopbr3ak package contains sound themes for the desktop.br3ak
#SECTION:multimedia



#VER:sound-theme-freedesktop:0.8


NAME="sound-theme-freedesktop"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc http://people.freedesktop.org/~mccann/dist/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sound-theme-freedesktop/sound-theme-freedesktop-0.8.tar.bz2


URL=http://people.freedesktop.org/~mccann/dist/sound-theme-freedesktop-0.8.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
