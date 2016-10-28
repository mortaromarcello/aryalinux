#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Audacious is an audio player.br3ak
#SECTION:multimedia

#REQ:gtk2
#REQ:qt5
#REQ:libxml2
#REQ:xorg7#xorg-env
#REQ:installing
#OPT:alsa
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


#VER:audacious:3.8
#VER:audacious-plugins:3.8


NAME="audacious"

wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/audacious/audacious-3.8.tar.bz2 || wget -nc http://distfiles.audacious-media-player.org/audacious-3.8.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/audacious/audacious-3.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/audacious/audacious-3.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious/audacious-3.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious/audacious-3.8.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/audacious-plugins/audacious-plugins-3.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.8.tar.bz2 || wget -nc http://distfiles.audacious-media-player.org/audacious-plugins-3.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/audacious-plugins/audacious-plugins-3.8.tar.bz2


URL=http://distfiles.audacious-media-player.org/audacious-3.8.tar.bz2
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

TPUT=/bin/true ./configure --prefix=/usr \
                           --with-buildstamp="BLFS" &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


TPUT=/bin/true ./configure --prefix=/usr --disable-wavpack &&
make


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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
