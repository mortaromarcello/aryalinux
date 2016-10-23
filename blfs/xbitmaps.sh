#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The xbitmaps package containsbr3ak bitmap images used by multiple applications built in Xorg chapter.br3ak
#SECTION:x

whoami > /tmp/currentuser

#REQ:util-macros


#VER:xbitmaps:1.1.1


NAME="xbitmaps"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xbitmaps/xbitmaps-1.1.1.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xbitmaps/xbitmaps-1.1.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xbitmaps/xbitmaps-1.1.1.tar.bz2 || wget -nc http://ftp.x.org/pub/individual/data/xbitmaps-1.1.1.tar.bz2 || wget -nc ftp://ftp.x.org/pub/individual/data/xbitmaps-1.1.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xbitmaps/xbitmaps-1.1.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xbitmaps/xbitmaps-1.1.1.tar.bz2


URL=http://ftp.x.org/pub/individual/data/xbitmaps-1.1.1.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST