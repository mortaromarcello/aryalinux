#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:qtchooser-39-g:4717841

#OPT:qt4


cd $SOURCE_DIR

URL=http://macieira.org/qtchooser/qtchooser-39-g4717841.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtchooser/qtchooser-39-g4717841.tar.gz || wget -nc http://macieira.org/qtchooser/qtchooser-39-g4717841.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtchooser/qtchooser-39-g4717841.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qtchooser/qtchooser-39-g4717841.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qtchooser/qtchooser-39-g4717841.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qtchooser/qtchooser-39-g4717841.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/qtchooser-39-upstream_fixes-2.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/qt/qtchooser-39-upstream_fixes-2.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

patch -Np1 -i ../qtchooser-39-upstream_fixes-2.patch &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /etc/xdg/qtchooser &&
cat > /etc/xdg/qtchooser/qt4.conf << "EOF"
/usr/lib/qt4/bin
/usr/lib
EOF
cat > /etc/xdg/qtchooser/qt5.conf << "EOF"
/usr/lib/qt5/bin
/usr/lib
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /etc/xdg/qtchooser &&
cat > /etc/xdg/qtchooser/qt4.conf << "EOF"
/opt/qt4/lib/qt4/bin
/opt/qt4/lib
EOF
cat > /etc/xdg/qtchooser/qt5.conf << "EOF"
/opt/qt5/lib/qt5/bin
/opt/qt5/lib
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -sfv qt4.conf /etc/xdg/qtchooser/default.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ln -sfv qt5.conf /etc/xdg/qtchooser/default.conf

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


export QT_SELECT=qt4


export QT_SELECT=qt5


cd $SOURCE_DIR

echo "qtchooser=>`date`" | sudo tee -a $INSTALLED_LIST

