#!/bin/bash

set -e
set +h

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/bin

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2
#DEP:iso-codes
#DEP:librsvg
#DEP:consolekit
#DEP:linux-pam


cd $SOURCE_DIR

TARBALL=lxdm-0.5.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

wget -nc http://downloads.sourceforge.net/lxdm/lxdm-0.5.0.tar.xz


tar -xf $TARBALL

cd $DIRECTORY

cat > pam/lxdm << "EOF" &&
#%PAM-1.0
auth required pam_unix.so
auth requisite pam_nologin.so
account required pam_unix.so
password required pam_unix.so
session required pam_unix.so
EOF

sed -i 's:sysconfig/i18n:profile.d/i18n.sh:g' data/lxdm.in &&
sed -i 's:/etc/xprofile:/etc/profile:g' data/Xsession &&
sed -e 's/^bg/#&/'        \
    -e '/reset=1/ s/# //' \
    -e 's/logou$/logout/' \
    -e "/arg=/a arg=$XORG_PREFIX/bin/X" \
    -i data/lxdm.conf.in

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-pam        \
            --with-systemdsystemunitdir=no &&
make

cat > 1434309266797.sh << ENDOFFILE
make install
ENDOFFILE
chmod a+x 1434309266797.sh
sudo ./1434309266797.sh
sudo rm -rf 1434309266797.sh

cat > 1434309266797.sh << ENDOFFILE
make install-lxdm
ENDOFFILE
chmod a+x 1434309266797.sh
sudo ./1434309266797.sh
sudo rm -rf 1434309266797.sh

cat > 1434309266797.sh << ENDOFFILE
/etc/rc.d/init.d/lxdm start
ENDOFFILE
chmod a+x 1434309266797.sh
sudo ./1434309266797.sh
sudo rm -rf 1434309266797.sh

cat > 1434309266797.sh << ENDOFFILE
init 5
ENDOFFILE
chmod a+x 1434309266797.sh
sudo ./1434309266797.sh
sudo rm -rf 1434309266797.sh

cat > 1434309266797.sh << ENDOFFILE
cp -v /etc/inittab{,-orig} &&
sed -i '/initdefault/ s/3/5/' /etc/inittab
ENDOFFILE
chmod a+x 1434309266797.sh
sudo ./1434309266797.sh
sudo rm -rf 1434309266797.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lxdm=>`date`" | sudo tee -a $INSTALLED_LIST