#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The FreeType2 package contains abr3ak library which allows applications to properly render TrueType fonts.br3ak"
SECTION="general"
VERSION=2.7
NAME="freetype2-without-harfbuzz"

#REC:libpng
#REC:general_which


wget -nc http://downloads.sourceforge.net/freetype/freetype-2.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-2.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.7.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.7.tar.bz2 || wget -nc http://downloads.sourceforge.net/freetype/freetype-doc-2.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-doc-2.7.tar.bz2


URL=http://downloads.sourceforge.net/freetype/freetype-2.7.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../freetype-doc-2.7.tar.bz2 --strip-components=2 -C docs


sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_(RENDERING|HINTING 2)) .*:\1:g" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --without-harfbuzz --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/freetype-2.7 &&
cp -v -R docs/*     /usr/share/doc/freetype-2.7

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
