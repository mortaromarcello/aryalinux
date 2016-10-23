#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Xine Libraries packagebr3ak contains xine libraries. These are useful for interfacing withbr3ak external plug-ins that allow the flow of information from thebr3ak source to the audio and video hardware.br3ak
#SECTION:multimedia

whoami > /tmp/currentuser

#REQ:ffmpeg
#REQ:pulseaudio
#REQ:xorg-server
#REC:libdvdnav
#OPT:aalib
#OPT:faad2
#OPT:flac
#OPT:gdk-pixbuf
#OPT:glu
#OPT:imagemagick
#OPT:liba52
#OPT:libmad
#OPT:libmng
#OPT:libtheora
#OPT:x7driver
#OPT:libvorbis
#OPT:libvpx
#OPT:mesa
#OPT:samba
#OPT:sdl
#OPT:speex
#OPT:doxygen
#OPT:v4l-utils


#VER:xine-lib:1.2.6


NAME="xine-lib"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz || wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/xine-lib-1.2.6.tar.xz || wget -nc http://downloads.sourceforge.net/xine/xine-lib-1.2.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz


URL=http://downloads.sourceforge.net/xine/xine-lib-1.2.6.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e 's/avcodec_alloc_frame/av_frame_alloc/'        \
    -e 's/avcodec_free_frame/av_frame_free/'          \
    -i src/combined/ffmpeg/ff_{audio,video}_decoder.c \
       src/dxr3/ffmpeg_encoder.c &&
sed -e 's|wand/magick_wand.h|ImageMagick-6/wand/MagickWand.h|' \
    -i src/video_dec/image.c &&
sed -e '/xineplug_vo_out_xcbxv_la_LIBADD/s/$(XCB_LIBS)/$(XCBSHM_LIBS) $(XCB_LIBS)/' \
    -i src/video_out/Makefile.in &&
sed -e 's/\(xcb-shape >= 1.0\)/xcb \1/' \
    -i m4/video_out.m4 &&
./configure --prefix=/usr          \
            --disable-vcd          \
            --with-external-dvdnav \
            --docdir=/usr/share/doc/xine-lib-1.2.6 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
