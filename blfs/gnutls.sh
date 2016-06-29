#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gnutls:3.5.0

#REQ:nettle
#REC:cacerts
#REC:libtasn1
#REC:p11-kit
#OPT:doxygen
#OPT:gtk-doc
#OPT:guile
#OPT:libidn
#OPT:texlive
#OPT:tl-installer
#OPT:unbound
#OPT:valgrind


cd $SOURCE_DIR

URL=ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-3.5.0.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnutls/gnutls-3.5.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnutls/gnutls-3.5.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnutls/gnutls-3.5.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnutls/gnutls-3.5.0.tar.xz || wget -nc ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-3.5.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnutls/gnutls-3.5.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e 's/gnutls_global/global/' \
    -e 's/gnutls_errors/errors/' \
    -i extra/openssl_compat.c &&
./configure --prefix=/usr \
            --with-default-trust-store-file=/etc/ssl/ca-bundle.crt &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C doc/reference install-data-local

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gnutls=>`date`" | sudo tee -a $INSTALLED_LIST

