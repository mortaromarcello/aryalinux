#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc http://www.dovecot.org/releases/2.2/dovecot-2.2.15.tar.gz


TARBALL=dovecot-2.2.15.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998787.sh << "ENDOFFILE"
groupadd -g 42 dovecot &&
useradd -c "Dovecot unprivileged user" -d /dev/null -u 42 \
        -g dovecot -s /bin/false dovecot &&
groupadd -g 43 dovenull &&
useradd -c "Dovecot login user" -d /dev/null -u 43 \
        -g dovenull -s /bin/false dovenull
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --localstatedir=/var \
            --docdir=/usr/share/doc/dovecot-2.2.15 \
            --disable-static \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make

cat > 1434987998787.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
cp -rv /usr/share/doc/dovecot-2.2.15/example-config/* /etc/dovecot
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
sed -i '/^\!include / s/^/#/' /etc/dovecot/dovecot.conf &&
chmod -v 1777 /var/mail &&
cat > /etc/dovecot/local.conf << "EOF"
protocols = imap
ssl = no
# The next line is only needed if you have no IPv6 network interfaces
listen = *
mail_location = mbox:~/Mail:INBOX=/var/mail/%u
userdb {
 driver = passwd
}
passdb {
 driver = shadow
}
EOF
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
systemctl enable dovecot
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "dovecot=>`date`" | sudo tee -a $INSTALLED_LIST