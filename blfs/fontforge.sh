#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:fontforge-dist:20160404

#REQ:freetype2
#REQ:glib2
#REQ:libxml2
#REC:cairo
#REC:gtk2
#REC:harfbuzz
#REC:pango
#REC:desktop-file-utils
#REC:shared-mime-info
#REC:x7lib
#OPT:giflib
#OPT:libjpeg
#OPT:libpng
#OPT:libtiff
#OPT:python2
#OPT:wget


cd $SOURCE_DIR

URL=https://github.com/fontforge/fontforge/releases/download/20160404/fontforge-dist-20160404.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fontforge/fontforge-dist-20160404.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fontforge/fontforge-dist-20160404.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontforge/fontforge-dist-20160404.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontforge/fontforge-dist-20160404.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fontforge/fontforge-dist-20160404.tar.gz || wget -nc https://github.com/fontforge/fontforge/releases/download/20160404/fontforge-dist-20160404.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/20140101/20160404/g' configure inc/fontforge-config.h \
  tests/package.m4 tests/testsuite &&
./configure --prefix=/usr     \
            --enable-gtk2-use \
            --disable-static  \
            --docdir=/usr/share/doc/fontforge-20160404 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "fontforge=>`date`" | sudo tee -a $INSTALLED_LIST

