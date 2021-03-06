#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="br3ak The Avahi package is a systembr3ak which facilitates service discovery on a local network.br3ak"
SECTION="basicnet"
VERSION=0.6.32
NAME="avahi"

#REQ:glib2
#REC:gobject-introspection
#REC:gtk2
#REC:gtk3
#REC:libdaemon
#REC:libglade
#OPT:python-modules#dbus-python
#OPT:python-modules#pygtk


cd $SOURCE_DIR

URL=https://github.com/lathiat/avahi/releases/download/v0.6.32/avahi-0.6.32.tar.gz

if [ ! -z $URL ]
then
wget -nc https://github.com/lathiat/avahi/releases/download/v0.6.32/avahi-0.6.32.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/avahi/avahi-0.6.32.tar.gz

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
            --with-systemdsystemunitdir=no &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc http://anduin.linuxfromscratch.org/BLFS/blfs-bootscripts/blfs-bootscripts-20160902.tar.xz -O $SOURCE_DIR/blfs-bootscripts-20160902.tar.xz
tar xf $SOURCE_DIR/blfs-bootscripts-20160902.tar.xz -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-bootscripts-20160902
make install-avahi

cd $SOURCE_DIR
rm -rf blfs-bootscripts-20160902

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
