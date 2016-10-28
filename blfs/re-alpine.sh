#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Re-alpine is the continuation ofbr3ak Alpine; a text-based email client developed by the University ofbr3ak Washington.br3ak
#SECTION:basicnet

#REC:openssl
#OPT:openldap
#OPT:mitkrb
#OPT:aspell
#OPT:tcl
#OPT:linux-pam


#VER:re-alpine:2.03


NAME="re-alpine"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://sourceforge.net/projects/re-alpine/files/re-alpine-2.03.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/re-alpine/re-alpine-2.03.tar.bz2


URL=http://sourceforge.net/projects/re-alpine/files/re-alpine-2.03.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --without-ldap      \
            --without-krb5      \
            --with-ssl-dir=/usr \
            --with-passfile=.pine-passfile &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
