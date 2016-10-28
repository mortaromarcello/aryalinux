#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Gvfs package is a userspacebr3ak virtual filesystem designed to work with the I/O abstractions ofbr3ak GLib's GIO library.br3ak
#SECTION:gnome

#REQ:dbus
#REQ:glib2
#REC:gtk3
#REC:libgudev
#REC:libsecret
#REC:libsoup
#REC:systemd
#REC:udisks2
#OPT:apache
#OPT:avahi
#OPT:bluez
#OPT:dbus-glib
#OPT:fuse
#OPT:gcr
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


#VER:gvfs:1.30.0


NAME="gvfs"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gvfs/gvfs-1.30.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gvfs/gvfs-1.30.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gvfs/gvfs-1.30.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gvfs/gvfs-1.30.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gvfs/gvfs-1.30.0.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gvfs/1.30/gvfs-1.30.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gvfs/1.30/gvfs-1.30.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gvfs/1.30/gvfs-1.30.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-gphoto2 &&
make


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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
