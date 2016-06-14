#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:apr-util:1.5.4

#REQ:apr
#REC:openssl
#OPT:db
#OPT:mariadb
#OPT:openldap
#OPT:postgresql
#OPT:sqlite
#OPT:unixodbc


cd $SOURCE_DIR

URL=http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.bz2

wget -nc http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/apr/apr-util-1.5.4.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/apr/apr-util-1.5.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/apr/apr-util-1.5.4.tar.bz2 || wget -nc ftp://ftp.mirrorservice.org/sites/ftp.apache.org/apr/apr-util-1.5.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/apr/apr-util-1.5.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/apr/apr-util-1.5.4.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr       \
            --with-apr=/usr     \
            --with-gdbm=/usr    \
            --with-openssl=/usr \
            --with-crypto &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "apr-util=>`date`" | sudo tee -a $INSTALLED_LIST

