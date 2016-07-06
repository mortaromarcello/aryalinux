#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:kde-workspace:4.11.20

#REQ:kactivities
#REQ:qimageblitz
#REQ:xcb-util-image
#REQ:xcb-util-keysyms
#REQ:xcb-util-renderutil
#REQ:xcb-util-wm
#REC:boost
#REC:kdepimlibs
#REC:pciutils
#REC:systemd
#OPT:libusb-compat
#OPT:linux-pam
#OPT:lm_sensors
#OPT:networkmanager
#OPT:qjson
#OPT:wayland


cd $SOURCE_DIR

URL=http://download.kde.org/stable/applications/15.04.2/src/kde-workspace-4.11.20.tar.xz

wget -nc http://download.kde.org/stable/applications/15.04.2/src/kde-workspace-4.11.20.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kde/kde-workspace-4.11.20.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kde/kde-workspace-4.11.20.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kde-workspace-4.11.20.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kde/kde-workspace-4.11.20.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kde/kde-workspace-4.11.20.tar.xz || wget -nc ftp://ftp.kde.org/pub/kde/stable/applications/15.04.2/src/kde-workspace-4.11.20.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser

export KDE_PREFIX=/opt/kde



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 37 kdm &&
useradd -c "KDM Daemon Owner" -d /var/lib/kdm -g kdm \
        -u 37 -s /bin/false kdm &&
install -o kdm -g kdm -dm755 /var/lib/kdm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=$KDE_PREFIX           \
      -DSYSCONF_INSTALL_DIR=/etc                   \
      -DCMAKE_BUILD_TYPE=Release                   \
      -DINSTALL_PYTHON_FILES_IN_PYTHON_PREFIX=TRUE \
      -Wno-dev .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                  &&
mkdir -pv /usr/share/xsessions &&
ln -sfv $KDE_PREFIX/share/apps/kdm/sessions/kde-plasma.desktop \
       /usr/share/xsessions/kde-plasma.desktop

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
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

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "kde-workspace=>`date`" | sudo tee -a $INSTALLED_LIST

