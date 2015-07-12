#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://linux-pam.org/library/Linux-PAM-1.1.8.tar.bz2
wget -nc http://linux-pam.org/documentation/Linux-PAM-1.1.8-docs.tar.bz2


TARBALL=Linux-PAM-1.1.8.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

tar -xf ../Linux-PAM-1.1.8-docs.tar.bz2 --strip-components=1

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --libdir=/usr/lib \
            --enable-securedir=/lib/security \
            --docdir=/usr/share/doc/Linux-PAM-1.1.8 &&
make

cat > 1434987998748.sh << "ENDOFFILE"
install -v -m755 -d /etc/pam.d &&

cat > /etc/pam.d/other << "EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
make install &&
chmod -v 4755 /sbin/unix_chkpwd &&

for file in pam pam_misc pamc
do
  mv -v /usr/lib/lib${file}.so.* /lib &&
  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
done
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "linux-pam=>`date`" | sudo tee -a $INSTALLED_LIST