#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The PCManFM package contains anbr3ak extremely fast, lightweight, yet feature-rich file manager withbr3ak tabbed browsing.br3ak
#SECTION:lxde

#REQ:libfm
#REC:adwaita-icon-theme
#REC:oxygen-icons5
#REC:lxde-icon-theme


#VER:pcmanfm:1.2.4


NAME="pcmanfm"

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/pcmanfm/pcmanfm-1.2.4.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcmanfm/pcmanfm-1.2.4.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/pcmanfm/pcmanfm-1.2.4.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/pcmanfm/pcmanfm-1.2.4.tar.xz || wget -nc http://downloads.sourceforge.net/pcmanfm/pcmanfm-1.2.4.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/pcmanfm/pcmanfm-1.2.4.tar.xz


URL=http://downloads.sourceforge.net/pcmanfm/pcmanfm-1.2.4.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
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
