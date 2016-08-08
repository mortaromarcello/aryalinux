#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:openssl:1.0.2h

#OPT:mitkrb


cd $SOURCE_DIR

URL=https://openssl.org/source/openssl-1.0.2h.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openssl/openssl-1.0.2h.tar.gz || wget -nc ftp://openssl.org/source/openssl-1.0.2h.tar.gz || wget -nc https://openssl.org/source/openssl-1.0.2h.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openssl/openssl-1.0.2h.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssl/openssl-1.0.2h.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openssl/openssl-1.0.2h.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openssl/openssl-1.0.2h.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic &&
make depend           &&
make "-j`nproc`"


sed -i 's# libcrypto.a##;s# libssl.a##' Makefile



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make MANDIR=/usr/share/man MANSUFFIX=ssl install &&
install -dv -m755 /usr/share/doc/openssl-1.0.2h  &&
cp -vfr doc/*     /usr/share/doc/openssl-1.0.2h

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "openssl=>`date`" | sudo tee -a $INSTALLED_LIST

