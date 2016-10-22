#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:lxqt-runner:0.11.0

#REQ:lxqt-globalkeys
#REQ:menu-cache
#OPT:git
#OPT:lxqt-l10n


cd $SOURCE_DIR

URL=http://downloads.lxqt.org/lxqt/0.11.0/lxqt-runner-0.11.0.tar.xz

wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-runner/lxqt-runner-0.11.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-runner/lxqt-runner-0.11.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-runner/lxqt-runner-0.11.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-runner/lxqt-runner-0.11.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-runner/lxqt-runner-0.11.0.tar.xz || wget -nc http://downloads.lxqt.org/lxqt/0.11.0/lxqt-runner-0.11.0.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/lxqt-runner-0.11.0-fix_endif-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/lxqt-runner/lxqt-runner-0.11.0-fix_endif-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -p1 -i ../lxqt-runner-0.11.0-fix_endif-1.patch &&
mkdir -v build &&
cd       build &&
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DRUNNER_MATH=OFF                   \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DPULL_TRANSLATIONS=no              \
      ..       &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "lxqt-runner=>`date`" | sudo tee -a $INSTALLED_LIST

