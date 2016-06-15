#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:ptlib:2.10.11

#REC:alsa-lib
#REC:openssl
#OPT:cyrus-sasl
#OPT:lua
#OPT:openldap
#OPT:pulseaudio
#OPT:sdl
#OPT:unixodbc
#OPT:v4l-utils


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/ptlib/2.10/ptlib-2.10.11.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/ptlib/ptlib-2.10.11.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/ptlib-2.10.11-bison_fixes-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/ptlib/ptlib-2.10.11-bison_fixes-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../ptlib-2.10.11-bison_fixes-1.patch &&
./configure --prefix=/usr &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chmod -v 755 /usr/lib/libpt.so.2.10.11

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "ptlib=>`date`" | sudo tee -a $INSTALLED_LIST

