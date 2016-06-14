#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:qca:2.1.1

#REQ:cacerts
#REQ:cmake
#REQ:qt4
#REQ:qt5
#REQ:general_which
#OPT:cyrus-sasl
#OPT:gnupg
#OPT:libgcrypt
#OPT:libgpg-error
#OPT:nss
#OPT:nspr
#OPT:openssl
#OPT:p11-kit
#OPT:doxygen
#OPT:general_which


cd $SOURCE_DIR

URL=http://download.kde.org/stable/qca/2.1.1/src/qca-2.1.1.tar.xz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qca/qca-2.1.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qca/qca-2.1.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qca/qca-2.1.1.tar.xz || wget -nc http://download.kde.org/stable/qca/2.1.1/src/qca-2.1.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qca/qca-2.1.1.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qca/qca-2.1.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
sed -i 's/BSD/DEFAULT/' CMakeLists.txt


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
QT_DIR=$QT4DIR &&
QT4_BUILD=ON


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
QT_DIR=$QT5DIR &&
QT4_BUILD=OFF


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$QT_DIR            \
      -DCMAKE_BUILD_TYPE=Release                \
      -DQT4_BUILD=$QT4_BUILD                    \
      -DQCA_MAN_INSTALL_DIR:PATH=/usr/share/man \
      ..                                        &&
unset QT_DIR QT4_BUILD                          &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "qca=>`date`" | sudo tee -a $INSTALLED_LIST

