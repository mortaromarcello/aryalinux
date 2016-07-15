#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:vlc-3.0.0:20160606

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
#OPT:x7driver#libva
#OPT:libvorbis
#OPT:opus
#OPT:speex
#OPT:x264
#OPT:aalib
#OPT:fontconfig
#OPT:freetype2
#OPT:fribidi
#OPT:librsvg
#OPT:x7driver#libvdpau
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

URL=http://anduin.linuxfromscratch.org/BLFS/vlc/vlc-3.0.0-20160606.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/vlc/vlc-3.0.0-20160606.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-3.0.0-20160606.tar.xz || wget -nc http://anduin.linuxfromscratch.org/BLFS/vlc/vlc-3.0.0-20160606.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-3.0.0-20160606.tar.xz || wget -nc ftp://anduin.linuxfromscratch.org/BLFS/vlc/vlc-3.0.0-20160606.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/vlc/vlc-3.0.0-20160606.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/vlc/vlc-3.0.0-20160606.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt5/lib/pkgconfig"
export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"

export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt5/lib/pkgconfig"
sed -i '/seems to be moved/s/^/#/' autotools/ltmain.sh


export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt5/lib/pkgconfig"
BUILDCC=gcc                      \
CFLAGS="-I $XORG_PREFIX/include" \
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt5/lib/pkgconfig"
make docdir=/usr/share/doc/vlc-3.0.0-20160606 install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT5PREFIX="/opt/qt5"
export QT5BINDIR="$QT5PREFIX/bin"
export QT5DIR="$QT5PREFIX"
export QTDIR="$QT5PREFIX"
export PATH="$PATH:$QT5BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt5/lib/pkgconfig"
gtk-update-icon-cache &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "vlc=>`date`" | sudo tee -a $INSTALLED_LIST

