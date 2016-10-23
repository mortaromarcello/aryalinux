#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libnfsidmap package contains abr3ak library to help mapping id's, mainly for NFSv4.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:openldap


#VER:libnfsidmap:0.26


NAME="libnfsidmap"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2 || wget -nc https://fedorapeople.org/~steved/libnfsidmap/0.26/libnfsidmap-0.26.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libnfsidmap/libnfsidmap-0.26.tar.bz2


URL=https://fedorapeople.org/~steved/libnfsidmap/0.26/libnfsidmap-0.26.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-static  &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                         &&
mv -v /usr/lib/libnfsidmap.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libnfsidmap.so) /usr/lib/libnfsidmap.so

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
