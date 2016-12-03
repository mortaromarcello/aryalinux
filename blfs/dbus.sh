#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak Even though D-Bus was built inbr3ak LFS, there are some features provided by the package that otherbr3ak BLFS packages need, but their dependencies didn't fit into LFS.br3ak"
SECTION="general"
VERSION=1.10.10
NAME="dbus"

#REC:x7lib
#OPT:dbus-glib
#OPT:python-modules#dbus-python
#OPT:python-modules#pygobject2
#OPT:valgrind
#OPT:doxygen
#OPT:xmlto


cd $SOURCE_DIR

URL=http://dbus.freedesktop.org/releases/dbus/dbus-1.10.10.tar.gz

if [ ! -z $URL ]
then
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc http://dbus.freedesktop.org/releases/dbus/dbus-1.10.10.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz

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

groupadd -g 18 messagebus &&
useradd -c "D-Bus Message Daemon User" -d /var/run/dbus \
        -u 18 -g messagebus -s /bin/false messagebus


./configure --prefix=/usr                  \
            --sysconfdir=/etc              \
            --localstatedir=/var           \
            --disable-doxygen-docs         \
            --disable-xml-docs             \
            --disable-static               \
            --disable-systemd              \
            --without-systemdsystemunitdir \
            --with-console-auth-dir=/run/console/ \
            --docdir=/usr/share/doc/dbus-1.10.10   &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh





sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
chown -v root:messagebus /usr/libexec/dbus-daemon-launch-helper &&
chmod -v      4750       /usr/libexec/dbus-daemon-launch-helper

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
dbus-uuidgen --ensure

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
