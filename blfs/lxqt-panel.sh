#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lxqt-panel:0.10.0

#REQ:krameworks5
#REQ:lxqt-kguiaddons
#REQ:lxqt-solid
#REQ:lxqt-globalkeys
#REQ:libdbusmenu-qt
#REQ:liblxqt
#REQ:libxkbcommon
#REQ:lxmenu-data
#REQ:menu-cache
#REC:alsa-lib
#REC:pulseaudio
#REC:libstatgrab
#REC:libsysstat
#REC:lm_sensors


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/lxqt/0.10.0/lxqt-panel-0.10.0.tar.xz

wget -nc http://downloads.lxqt.org/lxqt/0.10.0/lxqt-panel-0.10.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.10.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.10.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-panel/lxqt-panel-0.10.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.10.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.10.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

sed -e 's:<KF5/KWindowSystem/:<:' \
    -i plugin-taskbar/lxqttaskgroup.{h,cpp} &&
mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_LIBDIR=lib          \
      ..                                  &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "lxqt-panel=>`date`" | sudo tee -a $INSTALLED_LIST

