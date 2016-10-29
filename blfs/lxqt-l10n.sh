#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The lxqt-l10n package providesbr3ak translations for all components of the LXQt desktop.br3ak"
SECTION="lxqt"
VERSION=0.11.0
NAME="lxqt-l10n"

#REQ:liblxqt


wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.11.0.tar.xz || wget -nc http://downloads.lxqt.org/lxqt/0.11.0/lxqt-l10n-0.11.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.11.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.11.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.11.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-l10n/lxqt-l10n-0.11.0.tar.xz


URL=http://downloads.lxqt.org/lxqt/0.11.0/lxqt-l10n-0.11.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
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
