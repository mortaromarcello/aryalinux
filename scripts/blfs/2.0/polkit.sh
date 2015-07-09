#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:JS
#DEP:linux-pam
#DEP:systemd


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/polkit/releases/polkit-0.112.tar.gz


TARBALL=polkit-0.112.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998749.sh << "ENDOFFILE"
groupadd -fg 127 polkitd &&
useradd -c "PolicyKit Daemon Owner" -d /etc/polkit-1 -u 127 \
        -g polkitd -s /bin/false polkitd
ENDOFFILE
chmod a+x 1434987998749.sh
sudo ./1434987998749.sh
sudo rm -rf 1434987998749.sh

sed -i "s:/sys/fs/cgroup/systemd/:/sys:g" configure

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     &&
make

cat > 1434987998749.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998749.sh
sudo ./1434987998749.sh
sudo rm -rf 1434987998749.sh

cat > 1434987998749.sh << "ENDOFFILE"
cat > /etc/pam.d/polkit-1 << "EOF"
# Begin /etc/pam.d/polkit-1

auth include system-auth
account include system-account
password include system-password
session include system-session

# End /etc/pam.d/polkit-1
EOF
ENDOFFILE
chmod a+x 1434987998749.sh
sudo ./1434987998749.sh
sudo rm -rf 1434987998749.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "polkit=>`date`" | sudo tee -a $INSTALLED_LIST
