#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:plasma-workspace:5.3.1

#REQ:kde_baloo
#REQ:kwayland
#REQ:kwin
#REQ:libkscreen
#REQ:libksysguard
#OPT:linux-pam
#OPT:bluedevil
#OPT:breeze
#OPT:khelpcenter
#OPT:kinfocenter
#OPT:kio-extras
#OPT:kmenuedit
#OPT:kde_kmix
#OPT:ksysguard
#OPT:kwrited
#OPT:milou
#OPT:oxygen
#OPT:plasma-desktop
#OPT:plasma-nm
#OPT:plasma-workspace-wallpapers
#OPT:kde_polkit-kde-agent
#OPT:powerdevil
#OPT:systemd
#OPT:systemsettings


cd $SOURCE_DIR

URL=http://download.kde.org/stable/plasma/5.3.1/plasma-workspace-5.3.1.tar.xz

wget -nc http://download.kde.org/stable/plasma/5.3.1/plasma-workspace-5.3.1.tar.xz || wget -nc ftp://ftp.kde.org/pub/kde/stable/plasma/5.3.1/plasma-workspace-5.3.1.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -DQML_INSTALL_DIR=lib/qt5/qml           \
      -DQT_PLUGIN_INSTALL_DIR=lib/qt5/plugins \
      .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sed -i "s:qtpaths:&-qt5:g" $KF5_PREFIX/bin/startkde

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/kde << "EOF"
# Begin /etc/pam.d/kde
auth include system-auth
account include system-account
password include system-password
session include system-session
# End /etc/pam.d/kde
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > $KF5_PREFIX/bin/startkde-wrapper << "EOF"
#!/bin/sh -e
. /etc/profile.d/kf5.sh
exec $KF5_PREFIX/bin/startkde "$@"
EOF
chmod -v 755 $KF5_PREFIX/bin/startkde-wrapper

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/xsessions
sed -i "s:startkde:&-wrapper:g" $KF5_PREFIX/share/xsessions/plasma.desktop
ln -sfv $KF5_PREFIX/share/xsessions/plasma.desktop /usr/share/xsessions/kf5-plasma.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "plasma-workspace=>`date`" | sudo tee -a $INSTALLED_LIST

