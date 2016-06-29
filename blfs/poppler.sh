#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:poppler-data:0.4.7
#VER:poppler:0.44.0

#REQ:fontconfig
#REC:cairo
#REC:libjpeg
#REC:libpng
#REC:openjpeg
#OPT:curl
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:gtk2
#OPT:lcms
#OPT:lcms2
#OPT:libtiff
#OPT:openjpeg2
#OPT:qt5


cd $SOURCE_DIR

URL=http://poppler.freedesktop.org/poppler-0.44.0.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/poppler/poppler-0.44.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/poppler/poppler-0.44.0.tar.xz || wget -nc http://poppler.freedesktop.org/poppler-0.44.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/poppler/poppler-0.44.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/poppler/poppler-0.44.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/poppler/poppler-0.44.0.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/poppler-data/poppler-data-0.4.7.tar.gz || wget -nc http://poppler.freedesktop.org/poppler-data-0.4.7.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/poppler-data/poppler-data-0.4.7.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/poppler-data/poppler-data-0.4.7.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/poppler-data/poppler-data-0.4.7.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/poppler-data/poppler-data-0.4.7.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr               \
            --sysconfdir=/etc           \
            --disable-static            \
            --enable-build-type=release \
            --enable-cmyk               \
            --enable-xpdf-headers       \
            --with-testdatadir=$PWD/testfiles &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d        /usr/share/doc/poppler-0.44.0 &&
install -v -m644 README*   /usr/share/doc/poppler-0.44.0 &&
cp -vr glib/reference/html /usr/share/doc/poppler-0.44.0

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


tar -xf ../poppler-data-0.4.7.tar.gz &&
cd poppler-data-0.4.7



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make prefix=/usr install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "poppler=>`date`" | sudo tee -a $INSTALLED_LIST

