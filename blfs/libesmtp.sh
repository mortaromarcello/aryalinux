#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libESMTP package contains thebr3ak libESMTP libraries which are usedbr3ak by some programs to manage email submission to a mail transportbr3ak layer.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:openssl


#VER:libesmtp:1.0.6


NAME="libesmtp"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://pkgs.fedoraproject.org/repo/pkgs/libesmtp/libesmtp-1.0.6.tar.bz2/bf3915e627fd8f35524a8fdfeed979c8/libesmtp-1.0.6.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://www.stafford.uklinux.net/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libesmtp/libesmtp-1.0.6.tar.bz2


URL=http://www.stafford.uklinux.net/libesmtp/libesmtp-1.0.6.tar.bz2
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
