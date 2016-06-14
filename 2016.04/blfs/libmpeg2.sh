#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libmpeg2:0.5.1

#OPT:sdl
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz || wget -nc http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz || wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/libmpeg2-0.5.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libmpeg2/libmpeg2-0.5.1.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -i 's/static const/static/' libmpeg2/idct_mmx.c &&
./configure --prefix=/usr    \
            --enable-shared  \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/mpeg2dec-0.5.1 &&
install -v -m644 README doc/libmpeg2.txt \
                    /usr/share/doc/mpeg2dec-0.5.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libmpeg2=>`date`" | sudo tee -a $INSTALLED_LIST

