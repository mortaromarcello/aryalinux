#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:openssl
#DEP:


cd $SOURCE_DIR

wget -nc http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz
wget -nc ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.7p1.tar.gz


TARBALL=openssh-6.7p1.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998748.sh << "ENDOFFILE"
install -v -m700 -d /var/lib/sshd &&
chown   -v root:sys /var/lib/sshd &&

groupadd -g 50 sshd &&
useradd -c 'sshd PrivSep' -d /var/lib/sshd -g sshd -s /bin/false -u 50 sshd
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

./configure --prefix=/usr                     \
            --sysconfdir=/etc/ssh             \
            --with-md5-passwords              \
            --with-privsep-path=/var/lib/sshd &&
make

cat > 1434987998748.sh << "ENDOFFILE"
make install                                  &&
install -v -m755 contrib/ssh-copy-id /usr/bin &&
install -v -m644 contrib/ssh-copy-id.1 /usr/share/man/man1 &&
install -v -m755 -d /usr/share/doc/openssh-6.7p1           &&
install -v -m644 INSTALL LICENCE OVERVIEW README* /usr/share/doc/openssh-6.7p1
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
echo "PermitRootLogin no" >> /etc/ssh/sshd_config
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

ssh-keygen &&
ssh-copy-id -i ~/.ssh/id_rsa.pub <em class="replaceable"><code>REMOTE_USERNAME</em>@<em class="replaceable"><code>REMOTE_HOSTNAME</em>

cat > 1434987998748.sh << "ENDOFFILE"
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config &&
echo "ChallengeResponseAuthentication no" >> /etc/ssh/sshd_config
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
sed 's@d/login@d/sshd@g' /etc/pam.d/login > /etc/pam.d/sshd &&
chmod 644 /etc/pam.d/sshd &&
echo "UsePAM yes" >> /etc/ssh/sshd_config
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-sshd
cd ..
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh

cat > 1434987998748.sh << "ENDOFFILE"
systemctl stop sshd && 
systemctl disable sshd &&
systemctl enable sshd.socket &&
systemctl start sshd.socket
ENDOFFILE
chmod a+x 1434987998748.sh
sudo ./1434987998748.sh
sudo rm -rf 1434987998748.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "openssh=>`date`" | sudo tee -a $INSTALLED_LIST