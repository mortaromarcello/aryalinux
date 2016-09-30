#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:qt-everywhere-opensource-src:5.7.0

#REQ:python2
#REQ:x7lib
#REC:alsa-lib
#REC:cacerts
#REC:cups
#REC:glib2
#REC:gst10-plugins-base
#REC:icu
#REC:jasper
#REC:libjpeg
#REC:libmng
#REC:libpng
#REC:libtiff
#REC:libxkbcommon
#REC:mesa
#REC:mtdev
#REC:nss
#REC:openssl
#REC:pcre
#REC:sqlite
#REC:wayland
#REC:xcb-util-image
#REC:xcb-util-keysyms
#REC:xcb-util-renderutil
#REC:xcb-util-wm
#OPT:bluez
#OPT:harfbuzz
#OPT:ibus
#OPT:x7driver#libinput
#OPT:mariadb
#OPT:pciutils
#OPT:postgresql
#OPT:pulseaudio
#OPT:unixodbc


cd $SOURCE_DIR

URL=http://download.qt.io/archive/qt/5.7/5.7.0/single/qt-everywhere-opensource-src-5.7.0.tar.xz

wget -nc http://www.linuxfromscratch.org/patches/downloads/qt/qt-5.7.0-qtwebengine_glibc224-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/7.10/qt-5.7.0-qtwebengine_glibc224-1.patch
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.7.0.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.7.0.tar.xz || wget -nc http://download.qt.io/archive/qt/5.7/5.7.0/single/qt-everywhere-opensource-src-5.7.0.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.7.0.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.7.0.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qt5/qt-everywhere-opensource-src-5.7.0.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export QT5PREFIX=/opt/qt5



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mkdir /opt/qt-5.7.0
ln -sfnv qt-5.7.0 /opt/qt5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


patch -Np1 -i ../qt-5.7.0-qtwebengine_glibc224-1.patch


export CXXFLAGS=-fno-delete-null-pointer-checks &&
./configure -prefix         $QT5PREFIX \
            -sysconfdir     /etc/xdg   \
            -confirm-license           \
            -opensource                \
            -dbus-linked               \
            -openssl-linked            \
            -system-harfbuzz           \
            -system-sqlite             \
            -nomake examples           \
            -no-rpath                  \
            -optimized-qmake           \
            -skip qtwebengine          &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find $QT5PREFIX/lib/pkgconfig -name "*.pc" -exec perl -pi -e "s, -L$PWD/?\S+,,g" {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
find $QT5PREFIX/ -name qt_lib_bootstrap_private.pri \
   -exec sed -i -e "s:$PWD/qtbase:/$QT5PREFIX/lib/:g" {} \; &&
find $QT5PREFIX/ -name \*.prl \
   -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
QT5BINDIR=$QT5PREFIX/bin
install -v -dm755 /usr/share/pixmaps/                  &&
install -v -Dm644 qttools/src/assistant/assistant/images/assistant-128.png \
                  /usr/share/pixmaps/assistant-qt5.png &&
install -v -Dm644 qttools/src/designer/src/designer/images/designer.png \
                  /usr/share/pixmaps/designer-qt5.png  &&
install -v -Dm644 qttools/src/linguist/linguist/images/icons/linguist-128-32.png \
                  /usr/share/pixmaps/linguist-qt5.png  &&
install -v -Dm644 qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png \
                  /usr/share/pixmaps/qdbusviewer-qt5.png &&
install -dm755 /usr/share/applications &&
cat > /usr/share/applications/assistant-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Assistant
Comment=Shows Qt5 documentation and examples
Exec=$QT5BINDIR/assistant
Icon=assistant-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF
cat > /usr/share/applications/designer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Designer
GenericName=Interface Designer
Comment=Design GUIs for Qt5 applications
Exec=$QT5BINDIR/designer
Icon=designer-qt5.png
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
cat > /usr/share/applications/linguist-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Linguist
Comment=Add translations to Qt5 applications
Exec=$QT5BINDIR/linguist
Icon=linguist-qt5.png
MimeType=text/vnd.trolltech.linguist;application/x-linguist;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
cat > /usr/share/applications/qdbusviewer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 QDbusViewer
GenericName=D-Bus Debugger
Comment=Debug D-Bus applications
Exec=$QT5BINDIR/qdbusviewer
Icon=qdbusviewer-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Debugger;
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
for file in moc uic rcc qmake lconvert lrelease lupdate; do
  ln -sfrvn $QT5BINDIR/$file /usr/bin/$file-qt5
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/qt5.sh << EOF
# Begin /etc/profile.d/qt5.sh
QT5DIR=/usr
export QT5DIR
pathappend $QT5DIR/bin/qt5
# End /etc/profile.d/qt5.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << EOF
# Begin Qt addition
/opt/qt5/lib
# End Qt addition
EOF
ldconfig

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/qt5.sh << "EOF"
# Begin /etc/profile.d/qt5.sh
QT5DIR=/opt/qt5
pathappend $QT5DIR/bin PATH
pathappend $QT5DIR/lib/pkgconfig PKG_CONFIG_PATH
export QT5DIR
# End /etc/profile.d/qt5.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "qt5=>`date`" | sudo tee -a $INSTALLED_LIST

