#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pulseaudio:8.0

#REQ:json-c
#REQ:libsndfile
#REQ:bluez
#REQ:sbc
#REC:alsa-lib
#REC:dbus
#REC:glib2
#REC:libcap
#REC:openssl
#REC:speex
#REC:x7lib
#OPT:avahi
#OPT:bluez
#OPT:check
#OPT:GConf
#OPT:gtk3
#OPT:libsamplerate
#OPT:sbc
#OPT:valgrind


cd $SOURCE_DIR

URL=http://freedesktop.org/software/pulseaudio/releases/pulseaudio-8.0.tar.xz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pulseaudio/pulseaudio-8.0.tar.xz || wget -nc http://freedesktop.org/software/pulseaudio/releases/pulseaudio-8.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pulseaudio/pulseaudio-8.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pulseaudio/pulseaudio-8.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pulseaudio/pulseaudio-8.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pulseaudio/pulseaudio-8.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -i "/seems to be moved/s/^/#/" build-aux/ltmain.sh


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-bluez5 --enable-bluez5-ofono-headset     \
            --disable-rpath      &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
rm /etc/dbus-1/system.d/pulseaudio-system.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i '/load-module module-console-kit/s/^/#/' /etc/pulse/default.pa

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "pulseaudio=>`date`" | sudo tee -a $INSTALLED_LIST

