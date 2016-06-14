#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:transcode:1.1.7

#REQ:ffmpeg
#REC:alsa-lib
#REC:lame
#REC:libdvdread
#REC:libmpeg2
#REC:x7lib
#OPT:faac
#OPT:freetype2
#OPT:imagemagick
#OPT:liba52
#OPT:libdv
#OPT:libjpeg
#OPT:libogg
#OPT:libquicktime
#OPT:libtheora
#OPT:libvorbis
#OPT:libxml2
#OPT:lzo
#OPT:sdl
#OPT:v4l-utils
#OPT:x264
#OPT:xvid


cd $SOURCE_DIR

URL=https://bitbucket.org/france/transcode-tcforge/downloads/transcode-1.1.7.tar.bz2

wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/transcode-1.1.7.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/transcode/transcode-1.1.7.tar.bz2 || wget -nc https://bitbucket.org/france/transcode-tcforge/downloads/transcode-1.1.7.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/transcode-1.1.7-ffmpeg2-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/transcode/transcode-1.1.7-ffmpeg2-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

sed -i "s:#include <freetype/ftglyph.h>:#include FT_GLYPH_H:" filter/subtitler/load_font.c


sed -i 's|doc/transcode|&-$(PACKAGE_VERSION)|' \
       $(find . -name Makefile.in -exec grep -l 'docsdir =' {} \;) &&
sed -i "s:av_close_input_file:avformat_close_input:g" \
       import/probe_ffmpeg.c                                       &&
patch -Np1 -i ../transcode-1.1.7-ffmpeg2-1.patch                   &&
./configure --prefix=/usr \
            --enable-alsa \
            --enable-libmpeg2 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "transcode=>`date`" | sudo tee -a $INSTALLED_LIST

