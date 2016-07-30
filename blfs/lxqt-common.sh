#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lxqt-common:0.10.0

#REQ:liblxqt
#REQ:openbox
#REQ:xfwm4
#REQ:qt5
#REQ:librsvg
#REQ:xdg-utils
#REC:lxdm
#REC:sddm
#REC:desktop-file-utils
#REC:hicolor-icon-theme
#REC:shared-mime-info
#OPT:xscreensaver


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/lxqt/0.10.0/lxqt-common-0.10.0.tar.xz

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-common/lxqt-common-0.10.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-common/lxqt-common-0.10.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-common/lxqt-common-0.10.0.tar.xz || wget -nc http://downloads.lxqt.org/lxqt/0.10.0/lxqt-common-0.10.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-common/lxqt-common-0.10.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-common/lxqt-common-0.10.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      ..       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
update-mime-database /usr/share/mime          &&
xdg-icon-resource forceupdate --theme hicolor &&
update-desktop-database -q

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "lxqt-common=>`date`" | sudo tee -a $INSTALLED_LIST

