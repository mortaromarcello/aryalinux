#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ffmpeg:3.0.2

#REC:libass
#REC:fdk-aac
#REC:freetype2
#REC:lame
#REC:libtheora
#REC:libvorbis
#REC:libvpx
#REC:opus
#REC:x264
#REC:x265
#REC:yasm
#OPT:faac
#OPT:fontconfig
#OPT:frei0r
#OPT:libcdio
#OPT:libwebp
#OPT:opencv
#OPT:openjpeg
#OPT:openssl
#OPT:gnutls
#OPT:pulseaudio
#OPT:speex
#OPT:texlive
#OPT:tl-installer
#OPT:v4l-utils
#OPT:xvid
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://ffmpeg.org/releases/ffmpeg-3.0.2.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ffmpeg/ffmpeg-3.0.2.tar.xz || wget -nc http://ffmpeg.org/releases/ffmpeg-3.0.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ffmpeg/ffmpeg-3.0.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ffmpeg/ffmpeg-3.0.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ffmpeg/ffmpeg-3.0.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ffmpeg/ffmpeg-3.0.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i 's/-lflite"/-lflite -lasound"/' configure &&
./configure --prefix=/usr        \
            --enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libopus     \
            --enable-libtheora   \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --enable-x11grab     \
            --docdir=/usr/share/doc/ffmpeg-3.0.2 &&
make &&
gcc tools/qt-faststart.c -o tools/qt-faststart



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755    tools/qt-faststart /usr/bin &&
install -v -m644    doc/*.txt \
                    /usr/share/doc/ffmpeg-3.0.2

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ffmpeg=>`date`" | sudo tee -a $INSTALLED_LIST

