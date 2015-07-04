#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:python2
#DEP:installing
#DEP:sdl


cd $SOURCE_DIR

wget -nc http://wiki.qemu.org/download/qemu-2.2.0.tar.bz2


TARBALL=qemu-2.2.0.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

egrep '^flags.*(vmx|svm)' /proc/cpuinfo

sed -i '/resource/ i#include <sys/xattr.h>' fsdev/virtfs-proxy-helper.c &&

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/qemu-2.2.0 \
            --target-list=x86_64-softmmu &&
make

cat > 1434987998755.sh << "ENDOFFILE"
make install &&
[ -e  /usr/lib/libcacard.so ] && chmod -v 755 /usr/lib/libcacard.so
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
groupadd -g 61 kvm
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
usermod -a -G kvm <em class="replaceable"><code><username></em>
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
cat > /lib/udev/rules.d/65-kvm.rules << "EOF"
KERNEL=="kvm", GROUP="kvm", MODE="0660"
EOF
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
ln -sv qemu-system-x86_64 /usr/bin/qemu
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

qemu-img create -f qcow2 vdisk.img 10G

qemu -enable-kvm -hda vdisk.img            \
     -cdrom Fedora-16-x86_64-Live-LXDE.iso \
     -boot d                               \
     -m 384

qemu -enable-kvm vdisk.img -m 384

cat > 1434987998755.sh << "ENDOFFILE"
sysctl -w net.ipv4.ip_forward=1
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
cat >> /etc/sysctl.d/60-net-forward.conf << "EOF"
net.ipv4.ip_forward=1
EOF
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
chgrp kvm  /usr/libexec/qemu-bridge-helper &&
chmod 4750 /usr/libexec/qemu-bridge-helper
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh

cat > 1434987998755.sh << "ENDOFFILE"
echo 'allow br0' > /etc/qemu/bridge.conf
ENDOFFILE
chmod a+x 1434987998755.sh
sudo ./1434987998755.sh
sudo rm -rf 1434987998755.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "qemu=>`date`" | sudo tee -a $INSTALLED_LIST