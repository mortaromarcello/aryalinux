#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Compface provides utilities and abr3ak library to convert from/to X-Face format, a 48x48 bitmap formatbr3ak used to carry thumbnails of email authors in a mail header.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:compface:1.5.2


NAME="compface"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc http://ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/compface/compface-1.5.2.tar.gz


URL=http://ftp.xemacs.org/pub/xemacs/aux/compface-1.5.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --mandir=/usr/share/man &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -m755 -v xbm2xface.pl /usr/bin

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
