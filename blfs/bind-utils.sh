#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:bind-9.10.-P:3

#OPT:libcap
#OPT:libxml2
#OPT:openssl


cd $SOURCE_DIR

URL=ftp://ftp.isc.org/isc/bind9/9.10.3-P3/bind-9.10.3-P3.tar.gz

wget -nc ftp://ftp.isc.org/isc/bind9/9.10.3-P3/bind-9.10.3-P3.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/bind/bind-9.10.3-P3.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/bind/bind-9.10.3-P3.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/bind/bind-9.10.3-P3.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/bind/bind-9.10.3-P3.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/bind/bind-9.10.3-P3.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make -C lib/dns &&
make -C lib/isc &&
make -C lib/bind9 &&
make -C lib/isccfg &&
make -C lib/lwres &&
make -C bin/dig



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make -C bin/dig install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "bind-utils=>`date`" | sudo tee -a $INSTALLED_LIST

