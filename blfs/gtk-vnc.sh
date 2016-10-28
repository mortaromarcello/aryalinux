#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Gtk VNC package contains a VNCbr3ak viewer widget for GTK+. It isbr3ak built using coroutines allowing it to be completely asynchronousbr3ak while remaining single threaded.br3ak
#SECTION:x

#REQ:gnutls
#REQ:gtk3
#REQ:libgcrypt
#REC:gobject-introspection
#REC:vala
#OPT:cyrus-sasl
#OPT:pulseaudio


#VER:gtk-vnc:0.5.4


NAME="gtk-vnc"

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.5/gtk-vnc-0.5.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.5/gtk-vnc-0.5.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.5/gtk-vnc-0.5.4.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr  \
            --with-gtk=3.0 \
            --enable-vala  \
            --without-sasl &&
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
