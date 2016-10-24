#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#DESCRIPTION:br3ak The FontForge package contains anbr3ak outline font editor that lets you create your own postscript,br3ak truetype, opentype, cid-keyed, multi-master, cff, svg and bitmapbr3ak (bdf, FON, NFNT) fonts, or edit existing ones.br3ak
#SECTION:xsoft

whoami > /tmp/currentuser

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


#VER:fontforge-dist:20161004


NAME="fontforge"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/fontforge/fontforge-dist-20161004.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontforge/fontforge-dist-20161004.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/fontforge/fontforge-dist-20161004.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/fontforge/fontforge-dist-20161004.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/fontforge/fontforge-dist-20161004.tar.gz || wget -nc https://github.com/fontforge/fontforge/releases/download/20161005/fontforge-dist-20161004.tar.gz


URL=https://github.com/fontforge/fontforge/releases/download/20161005/fontforge-dist-20161004.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --enable-gtk2-use \
            --disable-static  \
            --docdir=/usr/share/doc/fontforge-20161004 &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
$DOSUDO rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
