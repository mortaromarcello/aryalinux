#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:x7lib
#DEP:alsa-lib
#DEP:mesalib
#DEP:cacerts
#DEP:dbus
#DEP:glib2
#DEP:icu
#DEP:libjpeg
#DEP:libmng
#DEP:libpng
#DEP:libtiff
#DEP:openssl
#DEP:sqlite


cd $SOURCE_DIR

wget -nc http://download.qt-project.org/official_releases/qt/4.8/4.8.6/qt-everywhere-opensource-src-4.8.6.tar.gz
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/qt-4.8.6-fedora_fixes-1.patch


TARBALL=qt-everywhere-opensource-src-4.8.6.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export QT4PREFIX=/usr

export QT4PREFIX=/opt/qt4

cat > 1434987998795.sh << "ENDOFFILE"
mv /opt/qt{4,-4.8.6}
ln -sfv qt-4.8.6 /opt/qt4
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

export QT4BINDIR=$QT4PREFIX/lib/qt4/bin

export QT4BINDIR=$QT4PREFIX/bin

patch -Np1 -i ../qt-4.8.6-fedora_fixes-1.patch

sed -e "631a if (image->isNull()) { state = Error; return -1; }" \
    -i src/gui/image/qgifhandler.cpp

sed -e "/CONFIG -/ a\isEmpty(OUTPUT_DIR): OUTPUT_DIR = ../.." \
    -i src/3rdparty/webkit/Source/WebKit2/DerivedSources.pro  &&

./configure -prefix         $QT4PREFIX                        \
            -sysconfdir     /etc/xdg                          \
            -bindir         $QT4BINDIR                        \
            -plugindir      $QT4PREFIX/lib/qt4/plugins        \
            -importdir      $QT4PREFIX/lib/qt4/imports        \
            -headerdir      $QT4PREFIX/include/qt4            \
            -datadir        $QT4PREFIX/share/qt4              \
            -docdir         $QT4PREFIX/share/doc/qt4          \
            -translationdir $QT4PREFIX/share/qt4/translations \
            -demosdir       $QT4PREFIX/share/doc/qt4/demos    \
            -examplesdir    $QT4PREFIX/share/doc/qt4/examples \
            -confirm-license   \
            -opensource        \
            -release           \
            -dbus-linked       \
            -openssl-linked    \
            -system-sqlite     \
            -no-phonon         \
            -no-phonon-backend \
            -no-openvg         \
            -nomake demos      \
            -nomake examples   \
            -optimized-qmake   &&

make "-j`nproc`"

find . -name "*.pc" -exec perl -pi -e "s, -L$PWD/?\S+,,g" {} \;

cat > 1434987998795.sh << "ENDOFFILE"
make install &&
rm -rf $QT4PREFIX/tests
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
for file in 3Support CLucene Core DBus Declarative DesignerComponents \
            Designer Gui Help Multimedia Network OpenGL Script \
            ScriptTools Sql Svg Test UiTools WebKit XmlPatterns Xml phonon
do
  if [ -e $QT4PREFIX/lib/libQt${file}.prl ]
  then
    sed -r '/^QMAKE_PRL_BUILD_DIR/d;s/(QMAKE_PRL_LIBS =).*/\1/' \
        -i $QT4PREFIX/lib/libQt${file}.prl
  fi
done
unset file
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
install -v -Dm644 src/gui/dialogs/images/qtlogo-64.png \
                  /usr/share/pixmaps/qt4logo.png &&

install -v -Dm644 tools/assistant/tools/assistant/images/assistant-128.png \
                  /usr/share/pixmaps/assistant-qt4.png &&

install -v -Dm644 tools/designer/src/designer/images/designer.png \
                  /usr/share/pixmaps/designer-qt4.png &&

install -v -Dm644 tools/linguist/linguist/images/icons/linguist-128-32.png \
                  /usr/share/pixmaps/linguist-qt4.png &&

install -v -Dm644 tools/qdbus/qdbusviewer/images/qdbusviewer-128.png \
                  /usr/share/pixmaps/qdbusviewer-qt4.png &&

install -v -dm755 /usr/share/applications &&

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
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
for file in assistant designer lconvert linguist lrelease lupdate \
            moc pixeltool qcollectiongenerator qdbus qdbuscpp2xml \
            qdbusviewer qdbusxml2cpp qdoc3 qhelpconverter         \
            qhelpgenerator qmake qmlplugindump qmlviewer qt3to4   \
            qtconfig qttracereplay rcc uic uic3 xmlpatterns       \
            xmlpatternsvalidator
do
  ln -sfrv $QT4BINDIR/$file /usr/bin/$file-qt4
done
unset file
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
cat > /etc/profile.d/qt4.sh << EOF
# Begin /etc/profile.d/qt4.sh

export QT4DIR=$QT4PREFIX
export QT4BINDIR=$QT4BINDIR

# End /etc/profile.d/qt4.sh
EOF
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
cat >> /etc/ld.so.conf << EOF
# Begin Qt4 addition

$QT4PREFIX/lib

# End Qt4 addition
EOF

ldconfig
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
cat > /etc/profile.d/qt4.sh << EOF
# Begin /etc/profile.d/qt4.sh

export QT4DIR=$QT4PREFIX
export QT4BINDIR=$QT4BINDIR

pathappend $QT4PREFIX/lib/pkgconfig PKG_CONFIG_PATH

# End /etc/profile.d/qt4.sh
EOF
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
cat > /etc/profile.d/qt4.sh << EOF
# Begin /etc/profile.d/qt4.sh

export QT4DIR=$QT4PREFIX
export QT4BINDIR=$QT4BINDIR

pathappend $QT4BINDIR PATH
pathappend $QT4PREFIX/lib/pkgconfig PKG_CONFIG_PATH

# End /etc/profile.d/qt4.sh
EOF
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh


 
cd $SOURCE_DIR
#sudo rm -rf $DIRECTORY
 
echo "qt4=>`date`" | sudo tee -a $INSTALLED_LIST
