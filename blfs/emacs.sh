#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The Emacs package contains anbr3ak extensible, customizable, self-documenting real-time displaybr3ak editor.br3ak
#SECTION:postlfs

#OPT:installing
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


#VER:emacs:25.1


NAME="emacs"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/emacs/emacs-25.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/emacs/emacs-25.1.tar.xz || wget -nc ftp://ftp.gnu.org/pub/gnu/emacs/emacs-25.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/emacs/emacs-25.1.tar.xz || wget -nc https://ftp.gnu.org/pub/gnu/emacs/emacs-25.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/emacs/emacs-25.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/emacs/emacs-25.1.tar.xz


URL=https://ftp.gnu.org/pub/gnu/emacs/emacs-25.1.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./autogen.sh                                   &&
./configure --prefix=/usr --localstatedir=/var &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
chown -v -R root:root /usr/share/emacs/25.1
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
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
