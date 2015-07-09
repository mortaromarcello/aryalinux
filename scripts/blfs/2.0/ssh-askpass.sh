#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk2
#DEP:sudo
#DEP:x7lib
#DEP:installing


cd $SOURCE_DIR

wget -nc http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz
wget -nc ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz


TARBALL=openssh-6.7p1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cd contrib &&
make gnome-ssh-askpass2

cat > 1434987998750.sh << "ENDOFFILE"
install -v -d -m755                  /usr/libexec/openssh/contrib     &&
install -v -m755  gnome-ssh-askpass2 /usr/libexec/openssh/contrib     &&
ln -sv -f contrib/gnome-ssh-askpass2 /usr/libexec/openssh/ssh-askpass
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh

cat > 1434987998750.sh << "ENDOFFILE"
cat >> /etc/sudo.conf << "EOF" &&
# Path to askpass helper program
Path askpass /usr/libexec/openssh/ssh-askpass
EOF
chmod -v 0644 /etc/sudo.conf
ENDOFFILE
chmod a+x 1434987998750.sh
sudo ./1434987998750.sh
sudo rm -rf 1434987998750.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "ssh-askpass=>`date`" | sudo tee -a $INSTALLED_LIST