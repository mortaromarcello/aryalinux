#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libesmtp:1.0.6

#OPT:openssl


cd $SOURCE_DIR

URL=http://www.stafford.uklinux.net/libesmtp/libesmtp-1.0.6.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://www.stafford.uklinux.net/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://pkgs.fedoraproject.org/repo/pkgs/libesmtp/libesmtp-1.0.6.tar.bz2/bf3915e627fd8f35524a8fdfeed979c8/libesmtp-1.0.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

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
echo "libesmtp=>`date`" | sudo tee -a $INSTALLED_LIST

