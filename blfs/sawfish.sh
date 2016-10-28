#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The sawfish package contains abr3ak window manager. This is useful for organizing and displayingbr3ak windows where all window decorations are configurable and allbr3ak user-interface policy is controlled through the extension language.br3ak
#SECTION:x

#REQ:rep-gtk
#REQ:general_which


#VER:sawfish_:1.12.0


NAME="sawfish"

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz || wget -nc http://download.tuxfamily.org/sawfish/sawfish_1.12.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sawfish/sawfish_1.12.0.tar.xz


URL=http://download.tuxfamily.org/sawfish/sawfish_1.12.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --with-pango  &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cat >> ~/.xinitrc << "EOF"
exec sawfish
EOF



cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
