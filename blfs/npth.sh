#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The NPth package contains a verybr3ak portable POSIX/ANSI-C based library for Unix platforms whichbr3ak provides non-preemptive priority-based scheduling for multiplebr3ak threads of execution (multithreading) inside event-drivenbr3ak applications. All threads run in the same address space of thebr3ak server application, but each thread has its own individualbr3ak program-counter, run-time stack, signal mask and errno variable.br3ak
#SECTION:general

whoami > /tmp/currentuser



#VER:npth:1.2


NAME="npth"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/npth/npth-1.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/npth/npth-1.2.tar.bz2 || wget -nc ftp://ftp.gnupg.org/gcrypt/npth/npth-1.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/npth/npth-1.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/npth/npth-1.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/npth/npth-1.2.tar.bz2


URL=ftp://ftp.gnupg.org/gcrypt/npth/npth-1.2.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr &&
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