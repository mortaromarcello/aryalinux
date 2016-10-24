#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

#VER:audacious-plugins:3.7.2
#VER:audacious:3.7.2

#REQ:gtk2
#REQ:libxml2
#REQ:xorg-server
#REQ:mpg123
#REQ:qt5
#OPT:dbus
#OPT:gnome-icon-theme
#OPT:pcre
#OPT:valgrind
#OPT:curl
#OPT:faad2
#OPT:ffmpeg
#OPT:flac
#OPT:lame
#OPT:libcdio
#OPT:libnotify
#OPT:libsamplerate
#OPT:libsndfile
#OPT:libvorbis
#OPT:mpg123
#OPT:neon
#OPT:pulseaudio
#OPT:sdl
#OPT:qt5


cd $SOURCE_DIR

URL=http://distfiles.audacious-media-player.org/audacious-3.7.2.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious/audacious-3.7.2.tar.bz2 || wget -nc http://distfiles.audacious-media-player.org/audacious-3.7.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/audacious/audacious-3.7.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/audacious/audacious-3.7.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious/audacious-3.7.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/audacious/audacious-3.7.2.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.7.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/audacious-plugins/audacious-plugins-3.7.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.7.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.7.2.tar.bz2 || wget -nc http://distfiles.audacious-media-player.org/audacious-plugins-3.7.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.7.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --disable-static"


TPUT=/bin/true ./configure --prefix=/usr \
                           --with-buildstamp="BLFS" &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


tar xf ../audacious-plugins-3.7.2.tar.bz2
cd `tar -tf ../audacious-plugins-3.7.2.tar.bz2 | cut -d ' ' -f1 | uniq`



TPUT=/bin/true ./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

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



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cp -v /usr/share/applications/audacious{,-qt}.desktop &&
sed -e '/^Name/ s/$/ Qt/' \
    -e '/Exec=/ s/audacious/& --qt/' \
    -i /usr/share/applications/audacious-qt.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "audacious=>`date`" | sudo tee -a $INSTALLED_LIST

