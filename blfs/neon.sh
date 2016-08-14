#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:neon:0.30.1

#REC:openssl
#REC:gnutls
#OPT:libxml2
#OPT:mitkrb


cd $SOURCE_DIR

URL=http://www.webdav.org/neon/neon-0.30.1.tar.gz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/neon/neon-0.30.1.tar.gz || wget -nc http://www.webdav.org/neon/neon-0.30.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/neon/neon-0.30.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/neon/neon-0.30.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/neon/neon-0.30.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/neon/neon-0.30.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e 's/client_set/set/'  \
    -e 's/gnutls_retr/&2/'  \
    -e 's/type = t/cert_&/' \
    -i src/ne_gnutls.c


./configure --prefix=/usr    \
            --with-ssl       \
            --enable-shared  \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "neon=>`date`" | sudo tee -a $INSTALLED_LIST

