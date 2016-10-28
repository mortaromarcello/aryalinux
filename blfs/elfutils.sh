#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The elfutils package contains abr3ak set of utilities and libraries for handling ELF (Executable andbr3ak Linkable Format) files.br3ak
#SECTION:general

#OPT:valgrind


#VER:elfutils:0.167


NAME="elfutils"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/elfutils/elfutils-0.167.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/elfutils/elfutils-0.167.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/elfutils/elfutils-0.167.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/elfutils/elfutils-0.167.tar.bz2 || wget -nc https://fedorahosted.org/releases/e/l/elfutils/0.167/elfutils-0.167.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/elfutils/elfutils-0.167.tar.bz2


URL=https://fedorahosted.org/releases/e/l/elfutils/0.167/elfutils-0.167.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --program-prefix="eu-" &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
