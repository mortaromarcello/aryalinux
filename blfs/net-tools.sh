#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Net-tools package is abr3ak collection of programs for controlling the network subsystem of thebr3ak Linux kernel.br3ak
#SECTION:basicnet



#VER:net-tools-CVS_:20101030


NAME="net-tools"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc ftp://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/net-tools/net-tools-CVS_20101030.tar.gz || wget -nc http://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/net-tools/net-tools-CVS_20101030-remove_dups-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/net-tools-CVS_20101030-remove_dups-1.patch


URL=http://anduin.linuxfromscratch.org/BLFS/net-tools/net-tools-CVS_20101030.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../net-tools-CVS_20101030-remove_dups-1.patch &&

yes "" | make config &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make update
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
