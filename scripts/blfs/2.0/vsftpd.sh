#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc https://security.appspot.com/downloads/vsftpd-3.0.2.tar.gz


TARBALL=vsftpd-3.0.2.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998787.sh << "ENDOFFILE"

install -v -dm755 /usr/share/vsftpd/empty &&
install -v -dm755 /home/ftp               &&
groupadd -g 47 vsftpd                     &&
groupadd -g 45 ftp                        &&

useradd -c "vsftpd User"  -d /dev/null -g vsftpd -s /bin/false -u 47 vsftpd &&
useradd -c anonymous_user -d /home/ftp -g ftp    -s /bin/false -u 45 ftp
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

make

install -v -m 755 vsftpd        /usr/sbin/vsftpd    &&
install -v -m 644 vsftpd.8      /usr/share/man/man8 &&
install -v -m 644 vsftpd.conf.5 /usr/share/man/man5 &&
install -v -m 644 vsftpd.conf   /etc

cat > 1434987998787.sh << "ENDOFFILE"
cat >> /etc/vsftpd.conf << "EOF"
background=YES
listen=YES
nopriv_user=vsftpd
secure_chroot_dir=/usr/share/vsftpd/empty
EOF
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-vsftpd
cd ..
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "vsftpd=>`date`" | sudo tee -a $INSTALLED_LIST