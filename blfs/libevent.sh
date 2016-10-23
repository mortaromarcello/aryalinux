#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libevent is an asynchronous eventbr3ak notification software library. The libevent API provides a mechanism to execute abr3ak callback function when a specific event occurs on a file descriptorbr3ak or after a timeout has been reached. Furthermore, libevent also supports callbacks due tobr3ak signals or regular timeouts.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REC:openssl
#OPT:doxygen


#VER:libevent-stable:2.0.22


NAME="libevent"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc http://downloads.sourceforge.net/levent/libevent-2.0.22-stable.tar.gz


URL=http://downloads.sourceforge.net/levent/libevent-2.0.22-stable.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
