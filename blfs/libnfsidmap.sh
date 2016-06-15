#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libnfsidmap:0.26

#OPT:openldap


cd $SOURCE_DIR

URL=https://fedorapeople.org/~steved/libnfsidmap/0.26/libnfsidmap-0.26.tar.bz2

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2 || wget -nc https://fedorapeople.org/~steved/libnfsidmap/0.26/libnfsidmap-0.26.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                         &&
mv -v /usr/lib/libnfsidmap.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libnfsidmap.so) /usr/lib/libnfsidmap.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libnfsidmap=>`date`" | sudo tee -a $INSTALLED_LIST

