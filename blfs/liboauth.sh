#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak liboauth is a collection ofbr3ak POSIX-C functions implementing the OAuth Core RFC 5849 standard.br3ak Liboauth provides functions to escape and encode parametersbr3ak according to OAuth specification and offers high-levelbr3ak functionality to sign requests or verify OAuth signatures as wellbr3ak as perform HTTP requests.br3ak"
SECTION="postlfs"
VERSION=1.0.3
NAME="liboauth"

#REQ:curl
#REQ:openssl
#REQ:nss
#OPT:doxygen


cd $SOURCE_DIR

URL=http://sourceforge.net/projects/liboauth/files/liboauth-1.0.3.tar.gz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz || wget -nc http://sourceforge.net/projects/liboauth/files/liboauth-1.0.3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/liboauth/liboauth-1.0.3.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=''
	unzip_dirname $TARBALL DIRECTORY
	unzip_file $TARBALL
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
