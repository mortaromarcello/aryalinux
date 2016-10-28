#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak The obconf-qt package is anbr3ak OpenBox Qt based configurationbr3ak tool.br3ak
#SECTION:lxqt

#REQ:gtk2
#REQ:hicolor-icon-theme
#REQ:liblxqt
#REQ:openbox
#OPT:git
#OPT:lxqt-l10n


#VER:obconf-qt:0.11.0


NAME="obconf-qt"

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.11.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.11.0.tar.xz || wget -nc https://downloads.lxqt.org/obconf-qt/0.11.0/obconf-qt-0.11.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.11.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.11.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/obconf-qt/obconf-qt-0.11.0.tar.xz


URL=https://downloads.lxqt.org/obconf-qt/0.11.0/obconf-qt-0.11.0.tar.xz
TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

mkdir -v build &&
cd       build &&

cmake -DCMAKE_BUILD_TYPE=Release  \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DPULL_TRANSLATIONS=no      \
      ..       &&
make


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ "$LXQT_PREFIX" != /usr ]; then
  ln -s $LXQT_PREFIX/share/obconf-qt /usr/share
fi
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
cleanup "$NAME" $DIRECTORY

register_installed "$NAME" "$INSTALLED_LIST"
