#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak FFmpeg is a solution to record,br3ak convert and stream audio and video. It is a very fast video andbr3ak audio converter and it can also acquire from a live audio/videobr3ak source. Designed to be intuitive, the command-line interfacebr3ak (<span class="command"><strong>ffmpeg</strong>) tries tobr3ak figure out all the parameters, when possible. FFmpeg can also convert from any sample ratebr3ak to any other, and resize video on the fly with a high qualitybr3ak polyphase filter. FFmpeg can use abr3ak Video4Linux compatible video source and any Open Sound System audiobr3ak source.br3ak
#SECTION:multimedia

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
#OPT:installing


#VER:ffmpeg:3.1.4


NAME="ffmpeg"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ffmpeg/ffmpeg-3.1.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ffmpeg/ffmpeg-3.1.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ffmpeg/ffmpeg-3.1.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ffmpeg/ffmpeg-3.1.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ffmpeg/ffmpeg-3.1.4.tar.xz || wget -nc http://ffmpeg.org/releases/ffmpeg-3.1.4.tar.xz


URL=http://ffmpeg.org/releases/ffmpeg-3.1.4.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

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
            --docdir=/usr/share/doc/ffmpeg-3.1.4 &&

make &&

gcc tools/qt-faststart.c -o tools/qt-faststart

pushd doc &&
for DOCNAME in `basename -s .html *.html`
do
    texi2pdf -b $DOCNAME.texi &&
    texi2dvi -b $DOCNAME.texi &&

    dvips    -o $DOCNAME.ps   \
                $DOCNAME.dvi
done &&
popd &&
unset DOCNAME


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&

install -v -m755    tools/qt-faststart /usr/bin &&
install -v -m644    doc/*.txt \
                    /usr/share/doc/ffmpeg-3.1.4
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m644 doc/*.pdf \
                 /usr/share/doc/ffmpeg-3.1.4 &&
install -v -m644 doc/*.ps  \
                 /usr/share/doc/ffmpeg-3.1.4
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/ffmpeg-3.1.4/api                     &&
cp -vr doc/doxy/html/* /usr/share/doc/ffmpeg-3.1.4/api                  &&
find /usr/share/doc/ffmpeg-3.1.4/api -type f -exec chmod -c 0644 \{} \; &&
find /usr/share/doc/ffmpeg-3.1.4/api -type d -exec chmod -c 0755 \{} \;
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


make fate-rsync SAMPLES=fate-suite/

<span class="command"><strong>rsync -vrltLW --delete --timeout=60 --contimeout=60 \
 rsync://fate-suite.ffmpeg.org/fate-suite/ fate-suite/</strong></span>

make fate THREADS=<em class="replaceable"><code>N</em> SAMPLES=fate-suite/ | tee ../fate.log &&
grep ^TEST ../fate.log | wc -l



cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
