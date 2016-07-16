#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:vlc:2.2.2

#REQ:qt4
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
#OPT:libva
#OPT:libvorbis
#OPT:opus
#OPT:speex
#OPT:x264
#OPT:aalib
#OPT:fontconfig
#OPT:freetype2
#OPT:fribidi
#OPT:librsvg
#OPT:libvdpau
#OPT:sdl
#OPT:pulseaudio
#OPT:libsamplerate
#OPT:qt4
#OPT:qt5
#OPT:avahi
#OPT:gnutls
#OPT:libnotify
#OPT:libxml2
#OPT:taglib
#OPT:xdg-utils


cd $SOURCE_DIR

URL=http://download.videolan.org/vlc/2.2.2/vlc-2.2.2.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-2.2.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-2.2.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-2.2.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vlc/vlc-2.2.2.tar.xz || wget -nc http://download.videolan.org/vlc/2.2.2/vlc-2.2.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-2.2.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
SAVEPATH=$PKG_CONFIG_PATH &&
PKG_CONFIG_PATH="\
`echo $PKG_CONFIG_PATH | sed 's@:/opt/qt5/lib/pkgconfig@@'`"


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
sed -i 's/ifndef __FAST_MATH__/if 0/g' configure.ac


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
sed -e 's:libsmbclient.h:samba-4.0/&:' \
    -i modules/access/smb.c &&
sed -e '/LUA_C/ i #define LUA_COMPAT_APIINTCASTS' \
    -i modules/lua/vlc.h    &&
sed -e '/core.h/ {
        a #include <opencv2/imgproc/imgproc_c.h>
        a #include <opencv2/imgproc/imgproc.hpp>
    }' \
    -i modules/video_filter/opencv_example.cpp &&
./bootstrap &&
OPENCV_LIBS="-L/usr/share/OpenCV" \
./configure --prefix=/usr &&
sed -e '/seems to be moved/s/^/#/' \
    -i autotools/ltmain.sh libtool &&


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
CFLAGS='-fPIC -O2 -Wall -Wextra -DLUA_COMPAT_5_1' make


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
PKG_CONFIG_PATH=$SAVEPATH &&
unset SAVEPATH



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
make docdir=/usr/share/doc/vlc-2.2.2 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "vlc=>`date`" | sudo tee -a $INSTALLED_LIST

