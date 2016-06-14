#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:qtwebkit:2.3.4
#VER:qt-everywhere-opensource-src:4.8.7

#REQ:x7lib
#REC:alsa-lib
#REC:mesa
#REC:cacerts
#REC:dbus
#REC:glib2
#REC:gst10-plugins-base
#REC:icu
#REC:libjpeg
#REC:libmng
#REC:libpng
#REC:libtiff
#REC:ruby
#REC:openssl
#REC:sqlite
#OPT:cups
#OPT:gtk2
#OPT:mariadb
#OPT:postgresql
#OPT:pulseaudio
#OPT:unixodbc


cd $SOURCE_DIR

URL=http://download.qt-project.org/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qt4/qt-everywhere-opensource-src-4.8.7.tar.gz || wget -nc http://download.qt-project.org/official_releases/qt/4.8/4.8.7/qt-everywhere-opensource-src-4.8.7.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qt4/qt-everywhere-opensource-src-4.8.7.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qt4/qt-everywhere-opensource-src-4.8.7.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qt4/qt-everywhere-opensource-src-4.8.7.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qt4/qt-everywhere-opensource-src-4.8.7.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/downloads/qt/qtwebkit-2.3.4-gcc5-1.patch || wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/qtwebkit-2.3.4-gcc5-1.patch
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/qtwebkit/qtwebkit-2.3.4.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/qtwebkit/qtwebkit-2.3.4.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebkit/qtwebkit-2.3.4.tar.gz || wget -nc http://download.kde.org/stable/qtwebkit-2.3/2.3.4/src/qtwebkit-2.3.4.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/qtwebkit/qtwebkit-2.3.4.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/qtwebkit/qtwebkit-2.3.4.tar.gz

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
export QT4PREFIX=/opt/qt4


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
./configure -prefix           $QT4PREFIX \
            -sysconfdir       /etc/xdg   \
            -confirm-license             \
            -opensource                  \
            -release                     \
            -dbus-linked                 \
            -openssl-linked              \
            -system-sqlite               \
            -no-phonon                   \
            -no-phonon-backend           \
            -no-webkit                   \
            -no-openvg                   \
            -nomake demos                \
            -nomake examples             \
            -optimized-qmake             &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
make install &&
rm -rf $QT4PREFIX/tests

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
find $QT4PREFIX/lib/pkgconfig -name "*.pc" -exec perl -pi -e "s, -L$PWD/?\S+,,g" {} \;



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
for file in $QT4PREFIX/lib/libQt*.prl; do
     sed -r -e '/^QMAKE_PRL_BUILD_DIR/d'    \
            -e 's/(QMAKE_PRL_LIBS =).*/\1/' \
            -i $file
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
mkdir qtwebkit-2.3.4 &&
cd    qtwebkit-2.3.4 &&
tar -xf ../../qtwebkit-2.3.4.tar.gz             &&
patch -Np1 -i ../../qtwebkit-2.3.4-gcc5-1.patch &&
Tools/Scripts/build-webkit --qt --no-webkit2 --prefix=$QT4PREFIX



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
make -C WebKitBuild/Release install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
QT4BINDIR=$QT4PREFIX/bin
install -v -Dm644 src/gui/dialogs/images/qtlogo-64.png \
                  /usr/share/pixmaps/qt4logo.png       &&
install -v -Dm644 tools/assistant/tools/assistant/images/assistant-128.png \
                  /usr/share/pixmaps/assistant-qt4.png &&
install -v -Dm644 tools/designer/src/designer/images/designer.png \
                  /usr/share/pixmaps/designer-qt4.png  &&
install -v -Dm644 tools/linguist/linguist/images/icons/linguist-128-32.png \
                  /usr/share/pixmaps/linguist-qt4.png  &&
install -v -Dm644 tools/qdbus/qdbusviewer/images/qdbusviewer-128.png \
                  /usr/share/pixmaps/qdbusviewer-qt4.png &&
install -dm755 /usr/share/applications &&
cat > /usr/share/applications/assistant-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 Assistant
Comment=Shows Qt4 documentation and examples
Exec=$QT4BINDIR/assistant
Icon=assistant-qt4.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF
cat > /usr/share/applications/designer-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 Designer
Comment=Design GUIs for Qt4 applications
Exec=$QT4BINDIR/designer
Icon=designer-qt4.png
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
cat > /usr/share/applications/linguist-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 Linguist
Comment=Add translations to Qt4 applications
Exec=$QT4BINDIR/linguist
Icon=linguist-qt4.png
MimeType=text/vnd.trolltech.linguist;application/x-linguist;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
cat > /usr/share/applications/qdbusviewer-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 QDbusViewer
GenericName=D-Bus Debugger
Comment=Debug D-Bus applications
Exec=$QT4BINDIR/qdbusviewer
Icon=qdbusviewer-qt4.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Debugger;
EOF
cat > /usr/share/applications/qtconfig-qt4.desktop << EOF
[Desktop Entry]
Name=Qt4 Config
Comment=Configure Qt4 behavior, styles, fonts
Exec=$QT4BINDIR/qtconfig
Icon=qt4logo.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Settings;
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
for file in moc uic rcc qmake lconvert lrelease lupdate; do
  ln -sfrvn $QT4BINDIR/$file /usr/bin/$file-qt4
done

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
cat > /etc/profile.d/qt4.sh << EOF
# Begin /etc/profile.d/qt4.sh
QT4DIR=/usr
QTDIR=$QT4DIR
export QT4DIR QTDIR
# End /etc/profile.d/qt4.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
cat >> /etc/ld.so.conf << EOF
# Begin Qt addition
/opt/qt4/lib
# End Qt addition
EOF
ldconfig

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
cat > /etc/profile.d/qt4.sh << EOF
# Begin /etc/profile.d/qt4.sh
QT4DIR=/opt/qt4
QTDIR=$QT4DIR
pathappend $QT4DIR/bin PATH
pathappend $QT4DIR/lib/pkgconfig PKG_CONFIG_PATH
export QT4DIR QTDIR
# End /etc/profile.d/qt4.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
cat > /usr/bin/setqt4 << 'EOF'
if [ "x$QT5DIR" != "x/usr" ]; then pathremove $QT5DIR/bin; fi
if [ "x$QT4DIR" != "x/usr" ]; then pathprepend $QT4DIR/bin; fi
echo $PATH
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
cat > /usr/bin/setqt5 << 'EOF'
if [ "x$QT4DIR" != "x/usr" ]; then pathremove $QT4DIR/bin; fi
if [ "x$QT5DIR" != "x/usr" ]; then pathprepend $QT5DIR/bin; fi
echo $PATH
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
export QT4PREFIX="/opt/qt4"
export QT4BINDIR="$QT4PREFIX/bin"
export QT4DIR="$QT4PREFIX"
export QTDIR="$QT4PREFIX"
export PATH="$PATH:$QT4BINDIR"
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/opt/qt4/lib/pkgconfig"
mkdir /opt/qt-4.8.7
ln -sfnv qt-4.8.7 /opt/qt4

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

echo "qt4=>`date`" | sudo tee -a $INSTALLED_LIST

