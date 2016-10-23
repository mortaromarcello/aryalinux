#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Wget package contains abr3ak utility useful for non-interactive downloading of files from thebr3ak Web.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REC:gnutls
#OPT:libidn
#OPT:openssl
#OPT:pcre
#OPT:valgrind


#VER:wget:1.18


NAME="wget"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.18.tar.xz


URL=http://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

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




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
