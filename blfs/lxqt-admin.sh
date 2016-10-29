#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The lxqt-admin package providesbr3ak two GUI tools to adjust setiings of the operating systembr3ak LXQt is running on.br3ak"
SECTION="lxqt"
VERSION=0.11.0
NAME="lxqt-admin"

#REQ:liblxqt
#REQ:polkit
#OPT:git
#OPT:lxqt-l10n


wget -nc http://downloads.lxqt.org/lxqt/0.11.0/lxqt-admin-0.11.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-admin/lxqt-admin-0.11.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-admin/lxqt-admin-0.11.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-admin/lxqt-admin-0.11.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-admin/lxqt-admin-0.11.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-admin/lxqt-admin-0.11.0.tar.xz


URL=http://downloads.lxqt.org/lxqt/0.11.0/lxqt-admin-0.11.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DPULL_TRANSLATIONS=no              \
      ..       &&
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
