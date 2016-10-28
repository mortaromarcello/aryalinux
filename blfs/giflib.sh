#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The giflib package containsbr3ak libraries for reading and writing GIFs as well as programs forbr3ak converting and working with GIF files.br3ak
#SECTION:general

#OPT:xmlto


#VER:giflib:5.1.4


NAME="giflib"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/giflib/giflib-5.1.4.tar.bz2 || wget -nc http://downloads.sourceforge.net/giflib/giflib-5.1.4.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/giflib/giflib-5.1.4.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/giflib/giflib-5.1.4.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/giflib/giflib-5.1.4.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/giflib/giflib-5.1.4.tar.bz2


URL=http://downloads.sourceforge.net/giflib/giflib-5.1.4.tar.bz2
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
find doc \( -name Makefile\* -o -name \*.1 \
         -o -name \*.xml \) -exec rm -v {} \; &&

install -v -dm755 /usr/share/doc/giflib-5.1.4 &&
cp -v -R doc/* /usr/share/doc/giflib-5.1.4
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
