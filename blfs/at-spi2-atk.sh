#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The At-Spi2 Atk package contains abr3ak library that bridges ATK tobr3ak At-Spi2 D-Bus service.br3ak"
SECTION="x"
VERSION=2.22.0
NAME="at-spi2-atk"

#REQ:at-spi2-core
#REQ:atk


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.22/at-spi2-atk-2.22.0.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.22/at-spi2-atk-2.22.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/at-spi/at-spi2-atk-2.22.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/at-spi/at-spi2-atk-2.22.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/at-spi/at-spi2-atk-2.22.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/at-spi/at-spi2-atk-2.22.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/at-spi/at-spi2-atk-2.22.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.22/at-spi2-atk-2.22.0.tar.xz

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

sed -i "/seems to be moved/s/^/#/" config/ltmain.sh &&
./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
