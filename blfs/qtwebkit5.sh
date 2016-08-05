#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:qtwebkit-opensource-src:5.7.0

#REQ:icu
#REQ:libjpeg
#REQ:libpng
#REQ:libwebp
#REQ:libxslt
#REQ:qt5
#REQ:ruby
#REQ:sqlite
#REC:gst10-plugins-base


cd $SOURCE_DIR

URL=http://download.qt.io/community_releases/5.7/5.7.0/qtwebkit-opensource-src-5.7.0.tar.xz

wget -nc http://download.qt.io/community_releases/5.7/5.7.0/qtwebkit-opensource-src-5.7.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.7.0.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.7.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.7.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.7.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qtwebkit/qtwebkit-opensource-src-5.7.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

SAVEPATH=$PATH             &&
export PATH=$PWD/bin:$PATH &&
mkdir -p build        &&
cd       build        &&
qmake ../WebKit.pro   &&
make                  &&
export PATH=$SAVEPATH &&
unset SAVEPATH



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find $QT5DIR/lib/pkgconfig -name "*.pc" -exec perl -pi -e "s, -L$PWD/?\S+,,g" {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find $QT5DIR/ -name qt_lib_bootstrap_private.pri \
   -exec sed -i -e "s:$PWD/qtbase:/$QT5DIR/lib/:g" {} \; &&
find $QT5DIR/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "qtwebkit5=>`date`" | sudo tee -a $INSTALLED_LIST

