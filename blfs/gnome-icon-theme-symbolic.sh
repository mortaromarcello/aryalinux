#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The GNOME Icon Theme Symbolicbr3ak package contains symbolic icons for the default GNOME icon theme.br3ak
#SECTION:x

#REQ:gnome-icon-theme


#VER:gnome-icon-theme-symbolic:3.12.0


NAME="gnome-icon-theme-symbolic"

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-icon-theme-symbolic/3.12/gnome-icon-theme-symbolic-3.12.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/gnome-icon-theme/gnome-icon-theme-symbolic-3.12.0.tar.xz || wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-icon-theme-symbolic/3.12/gnome-icon-theme-symbolic-3.12.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/gnome-icon-theme/gnome-icon-theme-symbolic-3.12.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/gnome-icon-theme/gnome-icon-theme-symbolic-3.12.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-icon-theme/gnome-icon-theme-symbolic-3.12.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/gnome-icon-theme/gnome-icon-theme-symbolic-3.12.0.tar.xz


URL=http://ftp.gnome.org/pub/gnome/sources/gnome-icon-theme-symbolic/3.12/gnome-icon-theme-symbolic-3.12.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr &&
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
