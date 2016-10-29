#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak If your system has a standard (US) keyboard, you probably do notbr3ak need to install this plugin.br3ak"
SECTION="xfce"
VERSION=0.7.1
NAME="xfce4-xkb-plugin"

#REQ:librsvg
#REQ:libxklavier
#REQ:xfce4-panel


wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc http://archive.xfce.org/src/panel-plugins/xfce4-xkb-plugin/0.7/xfce4-xkb-plugin-0.7.1.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-xkb-plugin-0.7.1.tar.bz2


URL=http://archive.xfce.org/src/panel-plugins/xfce4-xkb-plugin/0.7/xfce4-xkb-plugin-0.7.1.tar.bz2
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e 's|xfce4/panel-plugins|xfce4/panel/plugins|' \
    -i panel-plugin/{Makefile.in,xkb-plugin.desktop.in.in} &&
./configure --prefix=/usr         \
            --libexecdir=/usr/lib \
            --disable-debug       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
