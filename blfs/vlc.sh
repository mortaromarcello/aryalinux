#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:vlc:2.2.4

#REQ:qt5
#REC:alsa-lib
#REC:ffmpeg
#REC:liba52
#REC:libgcrypt
#REC:libmad
#REC:lua
#REC:xorg-server
#OPT:dbus
#OPT:libdv
#OPT:libdvdcss
#OPT:libdvdread
#OPT:libdvdnav
#OPT:opencv
#OPT:samba
#OPT:v4l-utils
#OPT:libcdio
#OPT:libogg
#OPT:faad2
#OPT:flac
#OPT:libass
#OPT:libmpeg2
#OPT:libpng
#OPT:libtheora
#OPT:x7driver
#OPT:libvorbis
#OPT:opus
#OPT:speex
#OPT:x264
#OPT:aalib
#OPT:fontconfig
#OPT:freetype2
#OPT:fribidi
#OPT:librsvg
#OPT:x7driver
#OPT:sdl
#OPT:pulseaudio
#OPT:libsamplerate
#OPT:qt5
#OPT:avahi
#OPT:gnutls
#OPT:libnotify
#OPT:libxml2
#OPT:taglib
#OPT:xdg-utils


cd $SOURCE_DIR

URL=http://get.videolan.org/vlc/2.2.4/vlc-2.2.4.tar.xz

wget -nc http://www.linuxfromscratch.org/patches/blfs/7.10/vlc-2.2.4-gcc6_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/vlc/vlc-2.2.4-gcc6_fixes-1.patch
wget -nc http://www.linuxfromscratch.org/patches/blfs/7.10/vlc-2.2.4-ffmpeg3-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/vlc/vlc-2.2.4-ffmpeg3-1.patch
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-2.2.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-2.2.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vlc/vlc-2.2.4.tar.xz || wget -nc http://get.videolan.org/vlc/2.2.4/vlc-2.2.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-2.2.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-2.2.4.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i '/seems to be moved/s/^/#/' autotools/ltmain.sh


patch -Np1 -i ../vlc-2.2.4-ffmpeg3-1.patch    &&
patch -Np1 -i ../vlc-2.2.4-gcc6_fixes-1.patch &&
CFLAGS="-DLUA_COMPAT_5_1" \
./configure --prefix=/usr --disable-atmo &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/vlc-2.2.4 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "vlc=>`date`" | sudo tee -a $INSTALLED_LIST

