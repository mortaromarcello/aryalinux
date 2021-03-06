#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Xdg-user-dirs is a tool to helpbr3ak manage “<span class=\"quote\">well known” userbr3ak directories like the desktop folder and the music folder. It alsobr3ak handles localization (i.e. translation) of the filenames.br3ak"
SECTION="general"
VERSION=0.15
NAME="xdg-user-dirs"



cd $SOURCE_DIR

URL=http://user-dirs.freedesktop.org/releases/xdg-user-dirs-0.15.tar.gz

if [ ! -z $URL ]
then
wget -nc http://user-dirs.freedesktop.org/releases/xdg-user-dirs-0.15.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xdg-user-dirs/xdg-user-dirs-0.15.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xdg-user-dirs/xdg-user-dirs-0.15.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xdg-user-dirs/xdg-user-dirs-0.15.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xdg-user-dirs/xdg-user-dirs-0.15.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xdg-user-dirs/xdg-user-dirs-0.15.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
