#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Even though D-Bus was built inbr3ak LFS, there are some features provided by the package that otherbr3ak BLFS packages need, but their dependencies didn't fit into LFS.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REC:x7lib
#OPT:dbus-glib
#OPT:python-modules#dbus-python
#OPT:python-modules#pygobject2
#OPT:valgrind
#OPT:doxygen
#OPT:xmlto


#VER:dbus:1.10.10


NAME="dbus"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz || wget -nc http://dbus.freedesktop.org/releases/dbus/dbus-1.10.10.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/db/dbus-1.10.10.tar.gz


URL=http://dbus.freedesktop.org/releases/dbus/dbus-1.10.10.tar.gz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr                  \
            --sysconfdir=/etc              \
            --localstatedir=/var           \
            --disable-doxygen-docs         \
            --disable-xml-docs             \
            --disable-static               \
            --with-console-auth-dir=/run/console/ \
            --docdir=/usr/share/doc/dbus-1.10.10   &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl start rescue.target

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv -v /usr/lib/libdbus-1.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so

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
systemctl daemon-reload
systemctl start multi-user.target

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


make distclean                     &&
./configure --enable-tests         \
            --enable-asserts       \
            --disable-doxygen-docs \
            --disable-xml-docs     &&
make                               &&
make check



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/dbus-1/session-local.conf << "EOF"
<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>
 <!-- Search for .service files in /usr/local -->
 <servicedir>/usr/local/share/dbus-1/services</servicedir>
</busconfig>
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


# Start the D-Bus session daemon
eval `dbus-launch`
export DBUS_SESSION_BUS_ADDRESS


# Kill the D-Bus session daemon
kill $DBUS_SESSION_BUS_PID




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
