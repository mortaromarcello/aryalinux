#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Links is a text and graphics modebr3ak WWW browser. It includes support for rendering tables and frames,br3ak features background downloads, can display colors and has manybr3ak other features.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REC:openssl
#OPT:gpm
#OPT:xorg-server


#VER:links:2.13


NAME="links"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/links/links-2.13.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/links/links-2.13.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/links/links-2.13.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/links/links-2.13.tar.bz2 || wget -nc http://links.twibright.com/download/links-2.13.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/links/links-2.13.tar.bz2


URL=http://links.twibright.com/download/links-2.13.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --mandir=/usr/share/man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -d -m755 /usr/share/doc/links-2.13 &&
install -v -m644 doc/links_cal/* KEYS BRAILLE_HOWTO \
    /usr/share/doc/links-2.13

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
