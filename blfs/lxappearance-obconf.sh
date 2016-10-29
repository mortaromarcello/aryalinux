#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The LXAppearance OBconf packagebr3ak contains a plugin for LXAppearancebr3ak to configure OpenBox.br3ak"
SECTION="lxde"
VERSION=0.2.3
NAME="lxappearance-obconf"

#REQ:lxappearance
#REQ:openbox


wget -nc http://downloads.sourceforge.net/lxde/lxappearance-obconf-0.2.3.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxappearance/lxappearance-obconf-0.2.3.tar.xz


URL=http://downloads.sourceforge.net/lxde/lxappearance-obconf-0.2.3.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
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
