#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#DESCRIPTION:%DESCRIPTION%
#SECTION:kde

whoami > /tmp/currentuser





NAME="kf5-intro"

if [ "$NAME" != "sudo" ]
then
	DOSUDO="sudo"
fi



URL=
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar --no-overwrite-dir xf $URL
cd $DIRECTORY

whoami > /tmp/currentuser

export KF5_PREFIX=/usr



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/profile.d/qt5.sh << "EOF"
# Begin kf5 extension for /etc/profile.d/qt5.sh
pathappend /usr/lib/qt5/plugins QT_PLUGIN_PATH
pathappend $QT5DIR/lib/plugins QT_PLUGIN_PATH
pathappend /usr/lib/qt5/qml QML2_IMPORT_PATH
pathappend $QT5DIR/lib/qml QML2_IMPORT_PATH
# End extension for /etc/profile.d/qt5.sh
EOF
cat > /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh
export KF5_PREFIX=/usr
# End /etc/profile.d/kf5.sh
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


export KF5_PREFIX=/opt/kf5



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/profile.d/kf5.sh << "EOF"
# Begin /etc/profile.d/kf5.sh
export KF5_PREFIX=/opt/kf5
pathappend $KF5_PREFIX/bin PATH
pathappend $KF5_PREFIX/lib/pkgconfig PKG_CONFIG_PATH
pathappend /etc/xdg XDG_CONFIG_DIRS
pathappend $KF5_PREFIX/etc/xdg XDG_CONFIG_DIRS
pathappend /usr/share XDG_DATA_DIRS
pathappend $KF5_PREFIX/share XDG_DATA_DIRS
pathappend $KF5_PREFIX/lib/plugins QT_PLUGIN_PATH
pathappend $KF5_PREFIX/lib/qml QML2_IMPORT_PATH
pathappend $KF5_PREFIX/lib/python2.7/site-packages PYTHONPATH
# End /etc/profile.d/kf5.sh
EOF
cat >> /etc/profile.d/qt5.sh << "EOF"
# Begin Qt5 changes for KF5
pathappend $QT5DIR/plugins QT_PLUGIN_PATH
pathappend $QT5DIR/qml QML2_IMPORT_PATH
# End Qt5 changes for KF5
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << "EOF"
# Begin KF5 addition
/opt/kf5/lib
# End KF5 addition
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755           $KF5_PREFIX/{etc,share} &&
ln -sfv /etc/dbus-1         $KF5_PREFIX/etc         &&
ln -sfv /usr/share/dbus-1   $KF5_PREFIX/share

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755                $KF5_PREFIX/share/icons &&
ln -sfv /usr/share/icons/hicolor $KF5_PREFIX/share/icons

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
mv /opt/kf5{,-5.25.0}
ln -sfv kf5-5.25.0 /opt/kf5

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh




cd $SOURCE_DIR
sudo rm -rf $DIRECTORY

echo "$NAME=>`date`" | $DOSUDO tee -a $INSTALLED_LIST