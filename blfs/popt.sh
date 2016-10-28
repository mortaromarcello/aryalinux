#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The popt package contains thebr3ak popt libraries which are used bybr3ak some programs to parse command-line options.br3ak
#SECTION:general



#VER:popt:1.16


NAME="popt"

wget -nc http://rpm5.org/files/popt/popt-1.16.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc ftp://anduin.linuxfromscratch.org/BLFS/popt/popt-1.16.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/popt/popt-1.16.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/popt/popt-1.16.tar.gz


URL=http://rpm5.org/files/popt/popt-1.16.tar.gz
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
install -v -m755 -d /usr/share/doc/popt-1.16 &&
install -v -m644 doxygen/html/* /usr/share/doc/popt-1.16
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
