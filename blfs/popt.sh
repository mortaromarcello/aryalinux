#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The popt package contains thebr3ak popt libraries which are used bybr3ak some programs to parse command-line options.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:popt:1.16


NAME="popt"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://rpm5.org/files/popt/popt-1.16.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc ftp://anduin.linuxfromscratch.org/BLFS/popt/popt-1.16.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/popt/popt-1.16.tar.gz


URL=http://rpm5.org/files/popt/popt-1.16.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
