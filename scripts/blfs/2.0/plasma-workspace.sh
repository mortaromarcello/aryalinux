#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:baloo
#DEP:kdesu
#DEP:kdewebkit
#DEP:kjsembed
#DEP:knotifyconfig
#DEP:krunner
#DEP:kwayland
#DEP:kwin
#DEP:libkscreen
#DEP:libksysguard
#DEP:ktexteditor


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/plasma/5.2.0/plasma-workspace-5.2.0.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/plasma/5.2.0/plasma-workspace-5.2.0.tar.xz


TARBALL=plasma-workspace-5.2.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KF5_PREFIX \
      -DCMAKE_BUILD_TYPE=Release         \
      -DLIB_INSTALL_DIR=lib              \
      -DBUILD_TESTING=OFF                \
      -DQML_INSTALL_DIR=lib/qt5/qml           \
      -DQT_PLUGIN_INSTALL_DIR=lib/qt5/plugins \
      .. &&
make

cat > 1434987998810.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998810.sh
sudo ./1434987998810.sh
sudo rm -rf 1434987998810.sh

cat > 1434987998810.sh << "ENDOFFILE"
sed -i "s:qtpaths:&-qt5:g" $KF5_PREFIX/bin/startkde
ENDOFFILE
chmod a+x 1434987998810.sh
sudo ./1434987998810.sh
sudo rm -rf 1434987998810.sh

cat > 1434987998810.sh << "ENDOFFILE"
cat > /etc/pam.d/kde << "EOF"
# Begin /etc/pam.d/kde

auth     include        system-auth
account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde
EOF
ENDOFFILE
chmod a+x 1434987998810.sh
sudo ./1434987998810.sh
sudo rm -rf 1434987998810.sh

cat > 1434987998810.sh << "ENDOFFILE"
cat > $KF5_PREFIX/bin/startkde-wrapper << "EOF"
#!/bin/sh -e

. /etc/profile.d/qt5.sh
. /etc/profile.d/kf5.sh

exec $KF5_PREFIX/bin/startkde "$@"
EOF
chmod -v 755 $KF5_PREFIX/bin/startkde-wrapper
ENDOFFILE
chmod a+x 1434987998810.sh
sudo ./1434987998810.sh
sudo rm -rf 1434987998810.sh

cat > 1434987998810.sh << "ENDOFFILE"
install -v -dm755 /usr/share/xsessions
sed -i "s:startkde:&-wrapper:g" $KF5_PREFIX/share/xsessions/plasma.desktop
ln -sfv $KF5_PREFIX/share/xsessions/plasma.desktop /usr/share/xsessions/kf5-plasma.desktop
ENDOFFILE
chmod a+x 1434987998810.sh
sudo ./1434987998810.sh
sudo rm -rf 1434987998810.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "plasma-workspace=>`date`" | sudo tee -a $INSTALLED_LIST