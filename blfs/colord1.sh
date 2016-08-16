#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:colord:1.3.2

#REQ:dbus
#REQ:glib2
#REQ:lcms2
#REQ:sqlite
#REC:gobject-introspection
#REC:libgudev
#REC:libgusb
#REC:polkit
#REC:systemd
#REC:vala
#OPT:docbook-utils
#OPT:gnome-desktop
#OPT:colord-gtk
#OPT:gtk-doc
#OPT:libxslt
#OPT:sane


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/colord/releases/colord-1.3.2.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord/colord-1.3.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/colord/colord-1.3.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord/colord-1.3.2.tar.xz || wget -nc http://www.freedesktop.org/software/colord/releases/colord-1.3.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/colord/colord-1.3.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/colord/colord-1.3.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 71 colord &&
useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
        -g colord -s /bin/false colord

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


./configure --prefix=/usr              \
            --sysconfdir=/etc          \
            --localstatedir=/var       \
            --with-daemon-user=colord  \
            --enable-vala              \
            --enable-daemon            \
            --enable-session-helper    \
            --enable-libcolordcompat   \
            --disable-rpath            \
            --disable-argyllcms-sensor \
            --disable-bash-completion  \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "colord1=>`date`" | sudo tee -a $INSTALLED_LIST

