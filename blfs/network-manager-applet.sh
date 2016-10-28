#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The NetworkManager Applet providesbr3ak a tool and a panel applet used to configure wired and wirelessbr3ak network connections through GUI. It's designed for use with anybr3ak desktop environment that uses GTK+br3ak like Xfce and LXDE.br3ak
#SECTION:gnome

#REQ:gtk3
#REQ:iso-codes
#REQ:libsecret
#REQ:libnotify
#REQ:networkmanager
#REQ:polkit-gnome
#REC:gobject-introspection
#OPT:gnome-bluetooth
#OPT:ModemManager


#VER:network-manager-applet:1.4.2


NAME="network-manager-applet"

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/network-manager-applet/network-manager-applet-1.4.2.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.4/network-manager-applet-1.4.2.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.4/network-manager-applet-1.4.2.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/network-manager-applet/network-manager-applet-1.4.2.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/network-manager-applet/network-manager-applet-1.4.2.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/network-manager-applet/network-manager-applet-1.4.2.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/network-manager-applet/network-manager-applet-1.4.2.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.4/network-manager-applet-1.4.2.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr       \
            --sysconfdir=/etc   \
            --disable-static    \
            --without-team      &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
