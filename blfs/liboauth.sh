#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak liboauth is a collection ofbr3ak POSIX-C functions implementing the OAuth Core RFC 5849 standard.br3ak Liboauth provides functions to escape and encode parametersbr3ak according to OAuth specification and offers high-levelbr3ak functionality to sign requests or verify OAuth signatures as wellbr3ak as perform HTTP requests.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser

#REQ:curl
#REQ:openssl
#REQ:nss
#OPT:doxygen


#VER:liboauth:1.0.3


NAME="liboauth"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz || wget -nc http://sourceforge.net/projects/liboauth/files/liboauth-1.0.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz


URL=http://sourceforge.net/projects/liboauth/files/liboauth-1.0.3.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
