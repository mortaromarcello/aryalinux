#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak OpenJPEG is an open-sourcebr3ak implementation of the JPEG-2000 standard. OpenJPEG fully respectsbr3ak the JPEG-2000 specifications and can compress/decompress losslessbr3ak 16-bit images.br3ak"
SECTION="general"
VERSION=1.5.2
NAME="openjpeg"

#OPT:lcms2
#OPT:libpng
#OPT:libtiff
#OPT:doxygen


wget -nc http://downloads.sourceforge.net/openjpeg.mirror/openjpeg-1.5.2.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/openjpeg/openjpeg-1.5.2.tar.gz


URL=http://downloads.sourceforge.net/openjpeg.mirror/openjpeg-1.5.2.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

autoreconf -f -i &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
