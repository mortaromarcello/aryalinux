#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Xapian is an open source search engine library.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:valgrind


#VER:xapian-core:1.4.0


NAME="xapian"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xapian/xapian-core-1.4.0.tar.xz || wget -nc http://oligarchy.co.uk/xapian/1.4.0/xapian-core-1.4.0.tar.xz


URL=http://oligarchy.co.uk/xapian/1.4.0/xapian-core-1.4.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xapian-core-1.4.0 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
