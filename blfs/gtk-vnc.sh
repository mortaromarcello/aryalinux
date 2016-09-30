#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:gtk-vnc:0.5.4

#REQ:gnutls
#REQ:gtk3
#REQ:libgcrypt
#REC:gobject-introspection
#REC:vala
#OPT:cyrus-sasl
#OPT:pulseaudio


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.5/gtk-vnc-0.5.4.tar.xz

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.5/gtk-vnc-0.5.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz || wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.5/gtk-vnc-0.5.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gtk-vnc/gtk-vnc-0.5.4.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr  \
            --with-gtk=3.0 \
            --enable-vala  \
            --without-sasl &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "gtk-vnc=>`date`" | sudo tee -a $INSTALLED_LIST

