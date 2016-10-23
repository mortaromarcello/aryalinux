#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libassuan package contains anbr3ak inter process communication library used by some of the otherbr3ak GnuPG related packages.br3ak libassuan's primary use is tobr3ak allow a client to interact with a non-persistent server.br3ak libassuan is not, however, limitedbr3ak to use with GnuPG servers andbr3ak clients. It was designed to be flexible enough to meet the demandsbr3ak of many transaction based environments with non-persistent servers.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:libgpg-error
#OPT:texlive
#OPT:tl-installer


#VER:libassuan:2.4.3


NAME="libassuan"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libassuan/libassuan-2.4.3.tar.bz2


URL=ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.4.3.tar.bz2
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