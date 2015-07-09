#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:kactivities
#DEP:qimageblitz
#DEP:xcb-util-image
#DEP:xcb-util-keysyms
#DEP:xcb-util-renderutil
#DEP:xcb-util-wm
#DEP:boost
#DEP:kdepimlibs
#DEP:pciutils
#DEP:systemd


cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/4.14.3/src/kde-workspace-4.11.14.tar.xz
wget -nc ftp://ftp.kde.org/pub/kde/stable/4.14.3/src/kde-workspace-4.11.14.tar.xz


TARBALL=kde-workspace-4.11.14.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998799.sh << "ENDOFFILE"
groupadd -g 37 kdm &&
useradd -c "KDM Daemon Owner" -d /var/lib/kdm -g kdm \
        -u 37 -s /bin/false kdm &&
install -o kdm -g kdm -dm755 /var/lib/kdm
ENDOFFILE
chmod a+x 1434987998799.sh
sudo ./1434987998799.sh
sudo rm -rf 1434987998799.sh

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX           \
      -DSYSCONF_INSTALL_DIR=/etc                   \
      -DCMAKE_BUILD_TYPE=Release                   \
      -DINSTALL_PYTHON_FILES_IN_PYTHON_PREFIX=TRUE \
      -Wno-dev .. &&
make

cat > 1434987998799.sh << "ENDOFFILE"
make install                  &&
mkdir -pv /usr/share/xsessions &&
ln -sfv $KDE_PREFIX/share/apps/kdm/sessions/kde-plasma.desktop \
       /usr/share/xsessions/kde-plasma.desktop
ENDOFFILE
chmod a+x 1434987998799.sh
sudo ./1434987998799.sh
sudo rm -rf 1434987998799.sh

cat > 1434987998799.sh << "ENDOFFILE"
cat >> /etc/pam.d/kde << "EOF" &&
# Begin /etc/pam.d/kde

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     include        system-auth

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde
EOF
cat > /etc/pam.d/kde-np << "EOF" &&
# Begin /etc/pam.d/kde-np

auth     requisite      pam_nologin.so
auth     required       pam_env.so

auth     required       pam_succeed_if.so uid >= 1000 quiet
auth     required       pam_permit.so

account  include        system-account
password include        system-password
session  include        system-session

# End /etc/pam.d/kde-np
EOF
cat > /etc/pam.d/kscreensaver << "EOF"
# Begin /etc/pam.d/kscreensaver

auth    include system-auth
account include system-account

# End /etc/pam.d/kscreensaver
EOF
ENDOFFILE
chmod a+x 1434987998799.sh
sudo ./1434987998799.sh
sudo rm -rf 1434987998799.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "kde-workspace=>`date`" | sudo tee -a $INSTALLED_LIST