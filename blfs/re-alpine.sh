#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:re-alpine:2.03

#REC:openssl
#OPT:openldap
#OPT:mitkrb
#OPT:aspell
#OPT:tcl
#OPT:linux-pam


cd $SOURCE_DIR

URL=http://sourceforge.net/projects/re-alpine/files/re-alpine-2.03.tar.bz2

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://sourceforge.net/projects/re-alpine/files/re-alpine-2.03.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --without-ldap      \
            --without-krb5      \
            --with-ssl-dir=/usr \
            --with-passfile=.pine-passfile &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "re-alpine=>`date`" | sudo tee -a $INSTALLED_LIST

