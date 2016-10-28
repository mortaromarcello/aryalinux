#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The International Components forbr3ak Unicode (ICU) package is a mature, widely used set of C/C++br3ak libraries providing Unicode and Globalization support for softwarebr3ak applications. ICU is widelybr3ak portable and gives applications the same results on all platforms.br3ak
#SECTION:general

#OPT:llvm
#OPT:doxygen


#VER:icu4c-src:58_1


NAME="icu"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/icu/icu4c-58_1-src.tgz || wget -nc http://download.icu-project.org/files/icu4c/58.1/icu4c-58_1-src.tgz


URL=http://download.icu-project.org/files/icu4c/58.1/icu4c-58_1-src.tgz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

cd source &&
./configure --prefix=/usr &&
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
