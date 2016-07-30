#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:emacs:24.5

#OPT:alsa-lib
#OPT:dbus
#OPT:GConf
#OPT:giflib
#OPT:gnutls
#OPT:gobject-introspection
#OPT:gsettings-desktop-schemas
#OPT:gpm
#OPT:gtk2
#OPT:gtk3
#OPT:imagemagick
#OPT:libjpeg
#OPT:libpng
#OPT:librsvg
#OPT:libtiff
#OPT:libxml2
#OPT:mitkrb
#OPT:valgrind
#OPT:xorg-server


cd $SOURCE_DIR

URL=https://ftp.gnu.org/pub/gnu/emacs/emacs-24.5.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/emacs/emacs-24.5.tar.xz || wget -nc https://ftp.gnu.org/pub/gnu/emacs/emacs-24.5.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/emacs/emacs-24.5.tar.xz || wget -nc ftp://ftp.gnu.org/pub/gnu/emacs/emacs-24.5.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/emacs/emacs-24.5.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/emacs/emacs-24.5.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/emacs/emacs-24.5.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --localstatedir=/var &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chown -v -R root:root /usr/share/emacs/24.5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor &&
update-desktop-database

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "emacs=>`date`" | sudo tee -a $INSTALLED_LIST

