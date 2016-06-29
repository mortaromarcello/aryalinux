#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:freetype-doc:2.6.3
#VER:freetype:2.6.3

#REC:libpng
#REC:general_which


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/freetype/freetype-2.6.3.tar.bz2

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-2.6.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.6.3.tar.bz2 || wget -nc http://downloads.sourceforge.net/freetype/freetype-2.6.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.6.3.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.6.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.6.3.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.6.3.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.6.3.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.6.3.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.6.3.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-doc-2.6.3.tar.bz2 || wget -nc http://downloads.sourceforge.net/freetype/freetype-doc-2.6.3.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../freetype-doc-2.6.3.tar.bz2 --strip-components=2 -C docs


sed -e "/AUX.*.gxvalid/s@^# @@" \
    -e "/AUX.*.otvalid/s@^# @@" \
    -i modules.cfg              &&
sed -r -e 's:.*(#.*SUBPIXEL.*) .*:\1:' \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --without-harfbuzz --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/freetype-2.6.3 &&
cp -v -R docs/*     /usr/share/doc/freetype-2.6.3

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "freetype2-without-harfbuzz=>`date`" | sudo tee -a $INSTALLED_LIST

