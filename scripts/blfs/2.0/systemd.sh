#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:gobject-introspection
#DEP:linux-pam
#DEP:polkit


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/systemd/systemd-213.tar.xz
wget -nc http://patches.clfs.org/dev/systemd-213-compat-1.patch


TARBALL=systemd-213.tar.xz
DIRECTORY=systemd-213

tar -xf $TARBALL

cd $DIRECTORY

export SYSTEMD_VERSION=$(systemctl --version | head -n1 | awk '{print $2}')

patch -Np1 -i ../systemd-${SYSTEMD_VERSION}-compat-1.patch

sed -i "s:test/udev-test.pl ::g" Makefile.in

cc_cv_CFLAGS__flto=no              \
./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --localstatedir=/var   \
            --with-rootprefix=     \
            --with-rootlibdir=/lib \
            --enable-split-usr     \
            --disable-firstboot    \
            --disable-ldconfig     \
            --disable-sysusers     \
            --docdir=/usr/share/doc/systemd-${SYSTEMD_VERSION} &&
make

cat > 1434987998773.sh << "ENDOFFILE"
systemctl start rescue.target
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh

cat > 1434987998773.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh

cat > 1434987998773.sh << "ENDOFFILE"
mv -v /usr/lib/libnss_{myhostname,mymachines,resolve}.so.2 /lib
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh

cat > 1434987998773.sh << "ENDOFFILE"
rm -rfv /usr/lib/rpm
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh

cat > 1434987998773.sh << "ENDOFFILE"
sed -i "s:0775 root lock:0755 root root:g" /usr/lib/tmpfiles.d/legacy.conf
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh

cat > 1434987998773.sh << "ENDOFFILE"
cat >> /etc/pam.d/system-session << "EOF" &&
# Begin Systemd addition
 
session required pam_loginuid.so
-session optional pam_systemd.so

# End Systemd addition
EOF
cat > /etc/pam.d/systemd-user << "EOF"
# Begin /etc/pam.d/systemd-user

account required pam_access.so
account include system-account

session required pam_env.so
session required pam_limits.so
session include system-session

auth required pam_deny.so
password required pam_deny.so

# End /etc/pam.d/systemd-user
EOF
ENDOFFILE
chmod a+x 1434987998773.sh
sudo ./1434987998773.sh
sudo rm -rf 1434987998773.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "systemd=>`date`" | sudo tee -a $INSTALLED_LIST
