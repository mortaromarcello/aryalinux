#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:alsa-lib
#DEP:mesalib
#DEP:xcb-util-image
#DEP:xcb-util-keysyms
#DEP:xcb-util-renderutil
#DEP:xcb-util-wm
#DEP:cacerts
#DEP:cups
#DEP:dbus
#DEP:glib2
#DEP:gst-plugins-base
#DEP:gst10-plugins-base
#DEP:harfbuzz
#DEP:icu
#DEP:jasper
#DEP:libjpeg
#DEP:libmng
#DEP:libpng
#DEP:libtiff
#DEP:libwebp
#DEP:libxkbcommon
#DEP:libxslt
#DEP:mtdev
#DEP:nss
#DEP:openssl
#DEP:pcre
#DEP:ruby
#DEP:sqlite
#DEP:wayland


cd $SOURCE_DIR

wget -nc http://download.qt-project.org/official_releases/qt/5.4/5.4.0/single/qt-everywhere-opensource-src-5.4.0.tar.xz


TARBALL=qt-everywhere-opensource-src-5.4.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

export QT5PREFIX=/usr

export QT5PREFIX=/opt/qt5

cat > 1434987998795.sh << "ENDOFFILE"
mv /opt/qt{5,-5.4.0}
ln -sfv qt-5.4.0 /opt/qt5
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

export QT5BINDIR=$QT5PREFIX/lib/qt5/bin

export QT5BINDIR=$QT5PREFIX/bin

sed -e "$ a !contains(QT_CONFIG, pulseaudio): GYP_CONFIG += use_pulseaudio=0" \
    -i qtwebengine/src/core/config/desktop_linux.pri

sed -i "/^QMAKE_LFLAGS_RPATH/s| -Wl,-rpath,||g" \
       qtbase/mkspecs/common/gcc-base-unix.conf &&

./configure -prefix         $QT5PREFIX                        \
            -sysconfdir     /etc/xdg                          \
            -bindir         $QT5BINDIR                        \
            -headerdir      $QT5PREFIX/include/qt5            \
            -archdatadir    $QT5PREFIX/lib/qt5                \
            -datadir        $QT5PREFIX/share/qt5              \
            -docdir         $QT5PREFIX/share/doc/qt5          \
            -translationdir $QT5PREFIX/share/qt5/translations \
            -examplesdir    $QT5PREFIX/share/doc/qt5/examples \
            -confirm-license  \
            -opensource       \
            -dbus-linked      \
            -openssl-linked   \
            -journald         \
            -system-harfbuzz  \
            -system-sqlite    \
            -nomake examples  \
            -no-rpath         \
            -optimized-qmake  \
            -skip qtwebengine &&
make

find . -name "*.pc" -exec perl -pi -e "s, -L$PWD/?\S+,,g" {} \;

cat > 1434987998795.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
sed -e "s:$PWD/qtbase:$QT5PREFIX/lib/qt5:g" \
    -i $QT5PREFIX/lib/qt5/mkspecs/modules/qt_lib_bootstrap_private.pri &&

find $QT5PREFIX/lib/lib{Enginio,qgsttools_p,Qt5*}.prl -exec sed -i -r \
     '/^QMAKE_PRL_BUILD_DIR/d;s/(QMAKE_PRL_LIBS =).*/\1/' {} \;
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
install -v -Dm644 qttools/src/assistant/assistant/images/assistant-128.png \
                  /usr/share/pixmaps/assistant-qt5.png &&

install -v -Dm644 qttools/src/designer/src/designer/images/designer.png \
                  /usr/share/pixmaps/designer-qt5.png &&

install -v -Dm644 qttools/src/linguist/linguist/images/icons/linguist-128-32.png \
                  /usr/share/pixmaps/linguist-qt5.png &&

install -v -Dm644 qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png \
                  /usr/share/pixmaps/qdbusviewer-qt5.png &&

install -v -dm755 /usr/share/applications &&

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
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
for file in assistant designer lconvert linguist lrelease lupdate   \
            moc pixeltool qcollectiongenerator qdbus qdbuscpp2xml   \
            qdbusviewer qdbusxml2cpp qdoc qhelpconverter            \
            qhelpgenerator qlalr qmake qml qml1plugindump qmlbundle \
            qmleasing qmlimportscanner qmllint qmlmin qmlplugindump \
            qmlprofiler qmlscene qmltestrunner qmlviewer qtdiag     \
            qtpaths qtwaylandscanner rcc sdpscanner syncqt.pl uic   \
            xmlpatterns xmlpatternsvalidator
do
  ln -sfrv $QT5BINDIR/$file /usr/bin/$file-qt5
done
unset file
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
cat > /etc/profile.d/qt5.sh << EOF
# Begin /etc/profile.d/qt5.sh

export QT5DIR=$QT5PREFIX
export QT5BINDIR=$QT5BINDIR

# End /etc/profile.d/qt5.sh
EOF
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
cat >> /etc/ld.so.conf << EOF
# Begin Qt5 addition

$QT5PREFIX/lib

# End Qt5 addition
EOF

ldconfig
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
cat > /etc/profile.d/qt5.sh << EOF
# Begin /etc/profile.d/qt5.sh

export QT5DIR=$QT5PREFIX
export QT5BINDIR=$QT5BINDIR

pathappend $QT5PREFIX CMAKE_PREFIX_PATH
pathappend $QT5PREFIX/lib/pkgconfig PKG_CONFIG_PATH

# End /etc/profile.d/qt5.sh
EOF
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh

cat > 1434987998795.sh << "ENDOFFILE"
cat > /etc/profile.d/qt5.sh << EOF
# Begin /etc/profile.d/qt5.sh

export QT5DIR=$QT5PREFIX
export QT5BINDIR=$QT5BINDIR

pathappend $QT5PREFIX CMAKE_PREFIX_PATH
pathappend $QT5BINDIR PATH
pathappend $QT5PREFIX/lib/pkgconfig PKG_CONFIG_PATH

# End /etc/profile.d/qt5.sh
EOF
ENDOFFILE
chmod a+x 1434987998795.sh
sudo ./1434987998795.sh
sudo rm -rf 1434987998795.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "qt5=>`date`" | sudo tee -a $INSTALLED_LIST