#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak libevent is an asynchronous eventbr3ak notification software library. The libevent API provides a mechanism to execute abr3ak callback function when a specific event occurs on a file descriptorbr3ak or after a timeout has been reached. Furthermore, libevent also supports callbacks due tobr3ak signals or regular timeouts.br3ak
#SECTION:basicnet

#REC:openssl
#OPT:doxygen


#VER:libevent-stable:2.0.22


NAME="libevent"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libevent/libevent-2.0.22-stable.tar.gz || wget -nc http://downloads.sourceforge.net/levent/libevent-2.0.22-stable.tar.gz


URL=http://downloads.sourceforge.net/levent/libevent-2.0.22-stable.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/libevent-2.0.22/api &&
cp      -v -R       doxygen/html/* \
                    /usr/share/doc/libevent-2.0.22/api
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
