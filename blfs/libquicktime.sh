#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:libquicktime:1.2.4

#OPT:alsa-lib
#OPT:doxygen
#OPT:faac
#OPT:faad2
#OPT:ffmpeg
#OPT:gtk2
#OPT:lame
#OPT:libdv
#OPT:libjpeg
#OPT:libpng
#OPT:libvorbis
#OPT:x264
#OPT:x7lib


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/libquicktime/libquicktime-1.2.4.tar.gz

wget -nc http://www.linuxfromscratch.org/patches/downloads/libquicktime/libquicktime-1.2.4-ffmpeg2-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/libquicktime-1.2.4-ffmpeg2-1.patch
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc http://downloads.sourceforge.net/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libquicktime/libquicktime-1.2.4.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../libquicktime-1.2.4-ffmpeg2-1.patch &&
./configure --prefix=/usr     \
            --enable-gpl      \
            --without-doxygen \
            --docdir=/usr/share/doc/libquicktime-1.2.4
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/libquicktime-1.2.4 &&
install -v -m644    README doc/{*.txt,*.html,mainpage.incl} \
                    /usr/share/doc/libquicktime-1.2.4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "libquicktime=>`date`" | sudo tee -a $INSTALLED_LIST

