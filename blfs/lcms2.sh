#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Little Color Management System is a small-footprint colorbr3ak management engine, with special focus on accuracy and performance.br3ak It uses the International Color Consortium standard (ICC), which isbr3ak the modern standard for color management.br3ak
#SECTION:general

#OPT:libjpeg
#OPT:libtiff


#VER:lcms2:2.8


NAME="lcms2"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz || wget -nc http://downloads.sourceforge.net/lcms/lcms2-2.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lcms2/lcms2-2.8.tar.gz


URL=http://downloads.sourceforge.net/lcms/lcms2-2.8.tar.gz
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




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
