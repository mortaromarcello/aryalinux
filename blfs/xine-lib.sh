#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xine-lib:1.2.6

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
#OPT:libva
#OPT:libvdpau
#OPT:libvorbis
#OPT:libvpx
#OPT:mesa
#OPT:samba
#OPT:sdl
#OPT:speex
#OPT:doxygen
#OPT:v4l-utils


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/xine/xine-lib-1.2.6.tar.xz

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz || wget -nc http://downloads.sourceforge.net/xine/xine-lib-1.2.6.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz || wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/xine-lib-1.2.6.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xine-lib/xine-lib-1.2.6.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

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
echo "xine-lib=>`date`" | sudo tee -a $INSTALLED_LIST

