#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:cmake
#DEP:qt5
#DEP:linux-pam
#DEP:systemd


cd $SOURCE_DIR

wget -nc http://www.linuxfromscratch.org/~krejzi/pkgs/sddm-0.11.0.tar.gz


TARBALL=sddm-0.11.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998811.sh << "ENDOFFILE"
groupadd -g 64 sddm &&
useradd -c "SDDM Daemon Owner" -d /var/lib/sddm -u 64 \
        -g sddm -s /bin/false sddm
ENDOFFILE
chmod a+x 1434987998811.sh
sudo ./1434987998811.sh
sudo rm -rf 1434987998811.sh

mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      .. &&
make

cat > 1434987998811.sh << "ENDOFFILE"
make install &&
install -v -dm755 -o sddm -g sddm /var/lib/sddm
ENDOFFILE
chmod a+x 1434987998811.sh
sudo ./1434987998811.sh
sudo rm -rf 1434987998811.sh

cat > 1434987998811.sh << "ENDOFFILE"
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
ENDOFFILE
chmod a+x 1434987998811.sh
sudo ./1434987998811.sh
sudo rm -rf 1434987998811.sh

cat > 1434987998811.sh << "ENDOFFILE"
systemctl enable sddm
ENDOFFILE
chmod a+x 1434987998811.sh
sudo ./1434987998811.sh
sudo rm -rf 1434987998811.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "sddm=>`date`" | sudo tee -a $INSTALLED_LIST