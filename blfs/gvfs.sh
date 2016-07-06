#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gvfs:1.26.2

#REQ:dbus
#REQ:glib2
#REC:gtk3
#REC:libgudev
#REC:libsecret
#REC:libsoup
#REC:systemd
#REC:udisks2
#OPT:avahi
#OPT:bluez
#OPT:dbus-glib
#OPT:fuse
#OPT:gnome-online-accounts
#OPT:gtk-doc
#OPT:libarchive
#OPT:libcdio
#OPT:libgcrypt
#OPT:libxml2
#OPT:libxslt
#OPT:openssh
#OPT:samba
#OPT:obex-data-server


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gvfs/1.26/gvfs-1.26.2.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gvfs/gvfs-1.26.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gvfs/gvfs-1.26.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gvfs/gvfs-1.26.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gvfs/1.26/gvfs-1.26.2.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gvfs/gvfs-1.26.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gvfs/1.26/gvfs-1.26.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gvfs/gvfs-1.26.2.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-gphoto2 &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gvfs=>`date`" | sudo tee -a $INSTALLED_LIST

