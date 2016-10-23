#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The jfsutils package containsbr3ak administration and debugging tools for the jfs file system.br3ak
#SECTION:postlfs

whoami > /tmp/currentuser



#VER:jfsutils:1.1.15


NAME="jfsutils"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz || wget -nc http://jfs.sourceforge.net/project/pub/jfsutils-1.1.15.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/jfsutils/jfsutils-1.1.15.tar.gz


URL=http://jfs.sourceforge.net/project/pub/jfsutils-1.1.15.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

sed "s@<unistd.h>@&\n#include <sys/types.h>@g" -i fscklog/extract.c &&
./configure &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST