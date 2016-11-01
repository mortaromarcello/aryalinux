#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Wget package contains abr3ak utility useful for non-interactive downloading of files from thebr3ak Web.br3ak"
SECTION="basicnet"
VERSION=1.18
NAME="wget"

#REC:gnutls
#OPT:libidn
#OPT:openssl
#OPT:pcre
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz

if [ ! -z $URL ]
then
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.18.tar.xz

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

./configure --prefix=/usr      \
            --sysconfdir=/etc  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
echo ca-directory=/etc/ssl/certs >> /etc/wgetrc

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
