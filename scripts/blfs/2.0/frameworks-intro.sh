#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






export KF5_PREFIX=/usr

cat > 1434987998800.sh << "ENDOFFILE"
cat > /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh

export KF5_PREFIX=/usr

pathappend /usr/lib/qt5/plugins QT_PLUGIN_PATH
pathappend $QT5DIR/lib/qt5/plugins QT_PLUGIN_PATH

pathappend /usr/lib/qt5/qml QML_IMPORT_PATH
pathappend $QT5DIR/lib/qt5/qml QML_IMPORT_PATH

pathappend /usr/lib/qt5/qml QML2_IMPORT_PATH
pathappend $QT5DIR/lib/qt5/qml QML2_IMPORT_PATH

# End /etc/profile.d/kf5.sh
EOF
ENDOFFILE
chmod a+x 1434987998800.sh
sudo ./1434987998800.sh
sudo rm -rf 1434987998800.sh

export KF5_PREFIX=/opt/kf5

cat > 1434987998800.sh << "ENDOFFILE"
cat > /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh

export KF5_PREFIX=/opt/kf5

pathappend $KF5_PREFIX CMAKE_PREFIX_PATH
pathappend $KF5_PREFIX/bin PATH
pathappend $KF5_PREFIX/lib/pkgconfig PKG_CONFIG_PATH
pathappend $KF5_PREFIX/lib/python2.7/site-packages PYTHONPATH

pathappend /etc/xdg XDG_CONFIG_DIRS
pathappend $KF5_PREFIX/etc/xdg XDG_CONFIG_DIRS
pathappend /usr/share XDG_DATA_DIRS
pathappend $KF5_PREFIX/share XDG_DATA_DIRS

pathappend $QT5DIR/lib/qt5/plugins QT_PLUGIN_PATH
pathappend $KF5_PREFIX/lib/qt5/plugins QT_PLUGIN_PATH

pathappend $QT5DIR/lib/qt5/qml QML_IMPORT_PATH
pathappend $KF5_PREFIX/lib/qt5/qml QML_IMPORT_PATH

pathappend $QT5DIR/lib/qt5/qml QML2_IMPORT_PATH
pathappend $KF5_PREFIX/lib/qt5/qml QML2_IMPORT_PATH

# End /etc/profile.d/kf5.sh
EOF
ENDOFFILE
chmod a+x 1434987998800.sh
sudo ./1434987998800.sh
sudo rm -rf 1434987998800.sh

cat > 1434987998800.sh << "ENDOFFILE"
cat >> /etc/ld.so.conf << "EOF"
# Begin KF5 addition

/opt/kf5/lib

# End KF5 addition
EOF
ENDOFFILE
chmod a+x 1434987998800.sh
sudo ./1434987998800.sh
sudo rm -rf 1434987998800.sh

cat > 1434987998800.sh << "ENDOFFILE"
install -v -dm755 $KF5_PREFIX/{etc,share}     &&
ln -sfv /etc/dbus-1         $KF5_PREFIX/etc   &&
ln -sfv /usr/share/dbus-1   $KF5_PREFIX/share
ENDOFFILE
chmod a+x 1434987998800.sh
sudo ./1434987998800.sh
sudo rm -rf 1434987998800.sh

cat > 1434987998800.sh << "ENDOFFILE"
install -v -dm755 $KF5_PREFIX/share/icons &&
ln -sfv /usr/share/icons/hicolor $KF5_PREFIX/share/icons
ENDOFFILE
chmod a+x 1434987998800.sh
sudo ./1434987998800.sh
sudo rm -rf 1434987998800.sh

cat > 1434987998800.sh << "ENDOFFILE"
mv /opt/kf5{,-5.7.0}
ln -sfv kf5-5.7.0 /opt/kf5
ENDOFFILE
chmod a+x 1434987998800.sh
sudo ./1434987998800.sh
sudo rm -rf 1434987998800.sh


 
cd $SOURCE_DIR
 
echo "frameworks-intro=>`date`" | sudo tee -a $INSTALLED_LIST