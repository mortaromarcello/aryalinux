#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The libffi library provides abr3ak portable, high level programming interface to various callingbr3ak conventions. This allows a programmer to call any functionbr3ak specified by a call interface description at run time.br3ak
#SECTION:general

#OPT:dejagnu


#VER:libffi:3.2.1


NAME="libffi"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libffi/libffi-3.2.1.tar.gz || wget -nc ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz


URL=ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
    -i include/Makefile.in &&

sed -e '/^includedir/ s/=.*$/=@includedir@/' \
    -e 's/^Cflags: -I${includedir}/Cflags:/' \
    -i libffi.pc.in        &&

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
