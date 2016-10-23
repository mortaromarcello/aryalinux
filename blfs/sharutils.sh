#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Sharutils package containsbr3ak utilities that can create 'shell' archives.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:sharutils:4.15.2


NAME="sharutils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc http://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sharutils/sharutils-4.15.2.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz


URL=http://ftp.gnu.org/gnu/sharutils/sharutils-4.15.2.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
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
