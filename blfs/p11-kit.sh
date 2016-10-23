#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The p11-kit package provides a waybr3ak to load and enumerate PKCS #11 (a Cryptographic Token Interfacebr3ak Standard) modules.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#REC:cacerts
#REC:libtasn1
#REC:libffi
#OPT:nss
#OPT:gtk-doc
#OPT:libxslt


#VER:p11-kit:0.23.2


NAME="p11-kit"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz || wget -nc http://p11-glue.freedesktop.org/releases/p11-kit-0.23.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/p11kit/p11-kit-0.23.2.tar.gz


URL=http://p11-glue.freedesktop.org/releases/p11-kit-0.23.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --sysconfdir=/etc &&
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