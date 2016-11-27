#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Colord is a system activatedbr3ak daemon that maps devices to color profiles. It is used bybr3ak GNOME Color Manager for systembr3ak integration and use when there are no users logged in.br3ak"
SECTION="general"
VERSION=1.2.12
NAME="colord"

#REQ:dbus
#REQ:glib2
#REQ:lcms2
#REQ:sqlite
#REQ:valgrind
#REC:gobject-introspection
#REC:libgudev
#REC:libgusb
#REC:polkit
#REC:vala
#OPT:docbook-utils
#OPT:gnome-desktop
#OPT:colord-gtk
#OPT:gtk-doc
#OPT:libxslt
#OPT:sane


cd $SOURCE_DIR

URL=http://www.freedesktop.org/software/colord/releases/colord-1.2.12.tar.xz

if [ ! -z $URL ]
then
wget -nc http://www.freedesktop.org/software/colord/releases/colord-1.2.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/colord/colord-1.2.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/colord/colord-1.2.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord/colord-1.2.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/colord/colord-1.2.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/colord/colord-1.2.12.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 71 colord &&
useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
        -g colord -s /bin/false colord

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


sed -i "/seems to be moved/s/^/#/" ltmain.sh &&
./configure --prefix=/usr                \
            --sysconfdir=/etc            \
            --localstatedir=/var         \
            --with-daemon-user=colord    \
            --enable-vala                \
            --enable-systemd-login=no    \
            --disable-argyllcms-sensor   \
            --disable-bash-completion    \
            --disable-static             \
            --with-systemdsystemunitdir=no &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
