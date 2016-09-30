#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:freetype-doc:2.6.5
#VER:freetype:2.6.5

#REC:harfbuzz
#REC:libpng
#REC:general_which


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/freetype/freetype-2.6.5.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.6.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.6.5.tar.bz2 || wget -nc http://downloads.sourceforge.net/freetype/freetype-2.6.5.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.6.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.6.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-2.6.5.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.6.5.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-doc-2.6.5.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.6.5.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.6.5.tar.bz2 || wget -nc http://downloads.sourceforge.net/freetype/freetype-doc-2.6.5.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.6.5.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

tar -xf ../freetype-doc-2.6.5.tar.bz2 --strip-components=2 -C docs


sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_(RENDERING|HINTING 2)) .*:\1:g" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/freetype-2.6.5 &&
cp -v -R docs/*     /usr/share/doc/freetype-2.6.5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../freetype-doc-2.6.5.tar.bz2 --strip-components=2 -C docs


sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_(RENDERING|HINTING 2)) .*:\1:g" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/freetype-2.6.5 &&
cp -v -R docs/*     /usr/share/doc/freetype-2.6.5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "freetype2=>`date`" | sudo tee -a $INSTALLED_LIST

