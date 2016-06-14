#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:xchat:2.8.8

#REQ:glib2
#REC:gtk2
#OPT:enchant
#OPT:dbus-glib
#OPT:GConf
#OPT:openssl
#OPT:python2
#OPT:tcl


cd $SOURCE_DIR

URL=http://www.xchat.org/files/source/2.8/xchat-2.8.8.tar.bz2

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xchat/xchat-2.8.8.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xchat/xchat-2.8.8.tar.bz2 || wget -nc ftp://mirror.ovh.net/gentoo-distfiles/distfiles/xchat-2.8.8.tar.bz2 || wget -nc http://www.xchat.org/files/source/2.8/xchat-2.8.8.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xchat/xchat-2.8.8.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xchat/xchat-2.8.8.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xchat/xchat-2.8.8.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xchat-2.8.8-glib-2.31-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/xchat/xchat-2.8.8-glib-2.31-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

patch -Np1 -i ../xchat-2.8.8-glib-2.31-1.patch &&
LIBS+="-lgmodule-2.0"         \
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-shm &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/xchat-2.8.8 &&
install -v -m644    README faq.html \
                    /usr/share/doc/xchat-2.8.8

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "xchat=>`date`" | sudo tee -a $INSTALLED_LIST

