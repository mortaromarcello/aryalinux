#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:mlt:0.9.8



cd $SOURCE_DIR

URL=http://sourceforge.net/projects/mlt/files/mlt-0.9.8.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/mlt/mlt-0.9.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/mlt/mlt-0.9.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/mlt/mlt-0.9.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/mlt/mlt-0.9.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/mlt/mlt-0.9.8.tar.gz || wget -nc http://sourceforge.net/projects/mlt/files/mlt-0.9.8.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr            \
            --avformat-vdpau         \
            --enable-gpl             \
            --enable-gpl3            \
            --enable-opengl          \
            --disable-gtk2           \
            --qt-libdir=$QT5DIR/lib  \
            --qt-includedir=$QT5DIR/include &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "mlt=>`date`" | sudo tee -a $INSTALLED_LIST

