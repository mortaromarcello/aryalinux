#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:sddm:0.11.0

#REQ:cmake
#REQ:qt5
#REQ:systemd
#REC:linux-pam


cd $SOURCE_DIR

URL=http://www.linuxfromscratch.org/~krejzi/pkgs/sddm-0.11.0.tar.gz

wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/sddm/sddm-0.11.0.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/sddm/sddm-0.11.0.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/sddm/sddm-0.11.0.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/sddm/sddm-0.11.0.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/sddm/sddm-0.11.0.tar.gz || wget -nc http://www.linuxfromscratch.org/~krejzi/pkgs/sddm-0.11.0.tar.gz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 64 sddm &&
useradd -c "SDDM Daemon Owner" -d /var/lib/sddm -u 64 \
        -g sddm -s /bin/false sddm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      .. &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -dm755 -o sddm -g sddm /var/lib/sddm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
cat > /etc/pam.d/sddm << "EOF"  &&
# Begin /etc/pam.d/sddm
auth requisite pam_nologin.so
auth required pam_env.so
auth required pam_succeed_if.so uid >= 1000 quiet
auth include system-auth
account include system-account
password include system-password
session required pam_limits.so
session include system-session
# End /etc/pam.d/sddm
EOF
cat > /etc/pam.d/sddm-autologin << "EOF" &&
# Begin /etc/pam.d/sddm-autologin
auth requisite pam_nologin.so
auth required pam_env.so
auth required pam_succeed_if.so uid >= 1000 quiet
auth required pam_permit.so
account include system-account
password required pam_deny.so
session required pam_limits.so
session include system-session
# End /etc/pam.d/sddm-autologin
EOF
cat > /etc/pam.d/sddm-greeter << "EOF"
# Begin /etc/pam.d/sddm-greeter
auth required pam_env.so
auth required pam_permit.so
account required pam_permit.so
password required pam_deny.so
session required pam_unix.so
-session optional pam_systemd.so
# End /etc/pam.d/sddm-greeter
EOF

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable sddm

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "sddm=>`date`" | sudo tee -a $INSTALLED_LIST

