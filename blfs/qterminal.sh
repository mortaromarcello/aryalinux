#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

DESCRIPTION="br3ak The qterminal package contains abr3ak Qt widget based terminal emulator for Qt with support for multiple tabs.br3ak"
SECTION="lxqt"
VERSION=0.7.0
NAME="qterminal"

#REQ:liblxqt
#REQ:qtermwidget
#OPT:doxygen
#OPT:texlive
#OPT:tl-installer
#OPT:git
#OPT:lxqt-l10n


wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qterminal/qterminal-0.7.0.tar.xz || wget -nc https://downloads.lxqt.org/qterminal/0.7.0/qterminal-0.7.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qterminal/qterminal-0.7.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qterminal/qterminal-0.7.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qterminal/qterminal-0.7.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qterminal/qterminal-0.7.0.tar.xz


URL=https://downloads.lxqt.org/qterminal/0.7.0/qterminal-0.7.0.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DPULL_TRANSLATIONS=no      \
      ..       &&
make "-j`nproc`" || make


make -C docs/latex



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ "$LXQT_PREFIX" != /usr ]; then
  ln -s $LXQT_PREFIX/share/qterminal /usr/share
fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
