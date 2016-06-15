#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:pidgin:2.10.11

#REQ:gtk2
#REC:libgcrypt
#REC:gstreamer10
#REC:gnutls
#REC:nss
#OPT:avahi
#OPT:check
#OPT:cyrus-sasl
#OPT:dbus
#OPT:evolution-data-server
#OPT:GConf
#OPT:libidn
#OPT:networkmanager
#OPT:sqlite
#OPT:startup-notification
#OPT:tcl
#OPT:tk
#OPT:mitkrb
#OPT:xdg-utils


cd $SOURCE_DIR

URL=http://downloads.sourceforge.net/pidgin/pidgin-2.10.11.tar.bz2

wget -nc http://www.linuxfromscratch.org/patches/downloads/pidgin/pidgin-2.10.11-gstreamer1-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/pidgin-2.10.11-gstreamer1-1.patch
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pidgin/pidgin-2.10.11.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pidgin/pidgin-2.10.11.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pidgin/pidgin-2.10.11.tar.bz2 || wget -nc http://downloads.sourceforge.net/pidgin/pidgin-2.10.11.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pidgin/pidgin-2.10.11.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pidgin/pidgin-2.10.11.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../pidgin-2.10.11-gstreamer1-1.patch &&
autoreconf -fi


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --with-gstreamer=1.0 \
            --disable-avahi      \
            --disable-gtkspell   \
            --disable-meanwhile  \
            --disable-idn        \
            --disable-nm         \
            --disable-vv         \
            --disable-tcl        &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
mkdir -pv /usr/share/doc/pidgin-2.10.11 &&
cp -v README doc/gtkrc-2.0 /usr/share/doc/pidgin-2.10.11

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
echo "pidgin=>`date`" | sudo tee -a $INSTALLED_LIST

