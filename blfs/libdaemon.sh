#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libdaemon package is abr3ak lightweight C library that eases the writing of UNIX daemons.br3ak
#SECTION:general

whoami > /tmp/currentuser

#OPT:doxygen
#OPT:lynx


#VER:libdaemon:0.14


NAME="libdaemon"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz || wget -nc http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz


URL=http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/libdaemon-0.14 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
