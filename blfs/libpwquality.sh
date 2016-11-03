#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The libpwquality package providesbr3ak common functions for password quality checking and also scoringbr3ak them based on their apparent randomness. The library also providesbr3ak a function for generating random passwords with goodbr3ak pronounceability.br3ak"
SECTION="postlfs"
VERSION=1.3.0
NAME="libpwquality"

#REQ:cracklib
#REC:linux-pam


cd $SOURCE_DIR

URL=https://fedorahosted.org/releases/l/i/libpwquality/libpwquality-1.3.0.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc https://fedorahosted.org/releases/l/i/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libpwquality/libpwquality-1.3.0.tar.bz2

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
