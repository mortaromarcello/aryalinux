#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:br3ak Qca aims to provide abr3ak straightforward and cross-platform crypto API, using Qt datatypes and conventions. Qca separates the API from the implementation,br3ak using plugins known as Providers.br3ak
#SECTION:general

whoami > /tmp/currentuser

#REQ:cacerts
#REQ:cmake
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


#VER:qca:2.1.1


NAME="qca"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qca/qca-2.1.1.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qca/qca-2.1.1.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qca/qca-2.1.1.tar.xz || wget -nc http://download.kde.org/stable/qca/2.1.1/src/qca-2.1.1.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qca/qca-2.1.1.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qca/qca-2.1.1.tar.xz


URL=http://download.kde.org/stable/qca/2.1.1/src/qca-2.1.1.tar.xz
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir -xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

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
mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$QT5DIR            \
      -DCMAKE_BUILD_TYPE=Release                \
      -DQCA_MAN_INSTALL_DIR:PATH=/usr/share/man \
      ..                                        &&
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

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST
