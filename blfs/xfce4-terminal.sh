#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Xfce4 Terminal is a GTK+3 terminal emulator. This is useful forbr3ak running commands or programs in the comfort of an Xorg window; youbr3ak can drag and drop files into the Xfce4br3ak Terminal or copy and paste text with your mouse.br3ak
#SECTION:xfce

whoami > /tmp/currentuser

#REQ:libxfce4ui
#REQ:vte


#VER:xfce4-terminal:0.8.0


NAME="xfce4-terminal"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://archive.xfce.org/src/apps/xfce4-terminal/0.8/xfce4-terminal-0.8.0.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-terminal-0.8.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-terminal-0.8.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-terminal-0.8.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-terminal-0.8.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-terminal-0.8.0.tar.bz2


URL=http://archive.xfce.org/src/apps/xfce4-terminal/0.8/xfce4-terminal-0.8.0.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

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