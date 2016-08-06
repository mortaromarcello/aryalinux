#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:wget:1.18

#REC:gnutls
#OPT:libidn
#OPT:openssl
#OPT:pcre
#OPT:valgrind


cd $SOURCE_DIR

URL=http://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc ftp://ftp.gnu.org/gnu/wget/wget-1.18.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.18.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/wget/wget-1.18.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr      \
            --sysconfdir=/etc  &&
make "-j`nproc`"



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

sudo rm -rf $DIRECTORY
echo "wget=>`date`" | sudo tee -a $INSTALLED_LIST
