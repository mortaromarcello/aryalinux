#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Avahi package is a systembr3ak which facilitates service discovery on a local network.br3ak
#SECTION:basicnet

whoami > /tmp/currentuser

#REQ:glib2
#REC:gobject-introspection
#REC:gtk2
#REC:gtk3
#REC:libdaemon
#REC:libglade
#OPT:python-modules#dbus-python
#OPT:python-modules#pygtk


#VER:avahi:0.6.32


NAME="avahi"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc https://github.com/lathiat/avahi/releases/download/v0.6.32/avahi-0.6.32.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz


URL=https://github.com/lathiat/avahi/releases/download/v0.6.32/avahi-0.6.32.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -fg 84 avahi &&
useradd -c "Avahi Daemon Owner" -d /var/run/avahi-daemon -u 84 \
        -g avahi -s /bin/false avahi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -fg 86 netdev

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     \
            --disable-mono       \
            --disable-monodoc    \
            --disable-python     \
            --disable-qt3        \
            --disable-qt4        \
            --enable-core-docs   \
            --with-distro=none   \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable avahi-daemon

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable avahi-dnsconfd

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
