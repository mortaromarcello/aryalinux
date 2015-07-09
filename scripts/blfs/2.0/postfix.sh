#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:db
#DEP:cyrus-sasl
#DEP:openssl


cd $SOURCE_DIR

wget -nc ftp://ftp.porcupine.org/mirrors/postfix-release/official/postfix-3.0.0.tar.gz


TARBALL=postfix-3.0.0.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998787.sh << "ENDOFFILE"
groupadd -g 32 postfix &&
groupadd -g 33 postdrop &&
useradd -c "Postfix Daemon User" -d /var/spool/postfix -g postfix \
        -s /bin/false -u 32 postfix &&
chown -v postfix:postfix /var/mail
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

sed -i 's/.\x08//g' README_FILES/*

make CCARGS="-DUSE_TLS -I/usr/include/openssl/                     \
             -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/usr/include/sasl" \
     AUXLIBS="-lssl -lcrypto -lsasl2"                              \
     makefiles &&
make

cat > 1434987998787.sh << "ENDOFFILE"
sh postfix-install -non-interactive \
   daemon_directory=/usr/lib/postfix \
   manpage_directory=/usr/share/man \
   html_directory=/usr/share/doc/postfix-3.0.0/html \
   readme_directory=/usr/share/doc/postfix-3.0.0/readme
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
cat >> /etc/aliases << "EOF"
# Begin /etc/aliases

MAILER-DAEMON: postmaster
postmaster: root

root: <em class="replaceable"><code><LOGIN></em>
# End /etc/aliases
EOF
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
/usr/sbin/postfix upgrade-configuration
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
/usr/sbin/postfix check &&
/usr/sbin/postfix start
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh

cat > 1434987998787.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-postfix
cd ..
ENDOFFILE
chmod a+x 1434987998787.sh
sudo ./1434987998787.sh
sudo rm -rf 1434987998787.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "postfix=>`date`" | sudo tee -a $INSTALLED_LIST