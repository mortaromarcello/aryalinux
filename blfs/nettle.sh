#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Nettle package contains thebr3ak low-level cryptographic library that is designed to fit easily inbr3ak many contexts.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#OPT:openssl


#VER:nettle:3.3


NAME="nettle"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/nettle/nettle-3.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/nettle/nettle-3.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/nettle/nettle-3.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/nettle/nettle-3.3.tar.gz || wget -nc ftp://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/nettle/nettle-3.3.tar.gz


URL=https://ftp.gnu.org/gnu/nettle/nettle-3.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
sudo make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
install -v -m755 -d /usr/share/doc/nettle-3.3 &&
install -v -m644 nettle.html /usr/share/doc/nettle-3.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
