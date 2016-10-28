#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libdaemon package is abr3ak lightweight C library that eases the writing of UNIX daemons.br3ak
#SECTION:general

#OPT:doxygen
#OPT:lynx


#VER:libdaemon:0.14


NAME="libdaemon"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz || wget -nc http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libdaemon/libdaemon-0.14.tar.gz


URL=http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --disable-static &&
make

make -C doc doxygen


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/libdaemon-0.14 install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/libdaemon-0.14/api &&
install -v -m644 doc/reference/html/* /usr/share/doc/libdaemon-0.14/api &&
install -v -m644 doc/reference/man/man3/* /usr/share/man/man3
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
