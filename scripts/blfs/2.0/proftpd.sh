#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR

wget -nc ftp://ftp.proftpd.org/distrib/source/proftpd-1.3.5.tar.gz


TARBALL=proftpd-1.3.5.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998786.sh << "ENDOFFILE"
groupadd -g 46 proftpd                             &&
useradd -c proftpd -d /srv/ftp -g proftpd \
        -s /usr/bin/proftpdshell -u 46 proftpd     &&

install -v -d -m775 -o proftpd -g proftpd /srv/ftp &&
ln -sfv /bin/false /usr/bin/proftpdshell           &&
echo /usr/bin/proftpdshell >> /etc/shells
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var/run &&
make

cat > 1434987998786.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh

cat > 1434987998786.sh << "ENDOFFILE"
cat > /etc/proftpd.conf << "EOF"
# This is a basic ProFTPD configuration file
# It establishes a single server and a single anonymous login.

ServerName "ProFTPD Default Installation"
ServerType standalone
DefaultServer on

# Port 21 is the standard FTP port.
Port 21
# Umask 022 is a good standard umask to prevent new dirs and files
# from being group and world writable.
Umask 022

# To prevent DoS attacks, set the maximum number of child processes
# to 30. If you need to allow more than 30 concurrent connections
# at once, simply increase this value. Note that this ONLY works
# in standalone mode, in inetd mode you should use an inetd server
# that allows you to limit maximum number of processes per service

MaxInstances 30

# Set the user and group that the server normally runs at.
User proftpd
Group proftpd

# To cause every FTP user to be "jailed" (chrooted) into their home
# directory, uncomment this line.
#DefaultRoot ~


# Normally, files should be overwritable.
<Directory /*>
 AllowOverwrite on
</Directory>

# A basic anonymous configuration, no upload directories.
<Anonymous ~proftpd>
 User proftpd
 Group proftpd
 # Clients should be able to login with "anonymous" as well as "proftpd"
 UserAlias anonymous proftpd

 # Limit the maximum number of anonymous logins
 MaxClients 10

 # 'welcome.msg' should be displayed at login, and '.message' displayed
 # in each newly chdired directory.
 DisplayLogin welcome.msg
 DisplayChdir .message

 # Limit WRITE everywhere in the anonymous chroot
 <Limit WRITE>
 DenyAll
 </Limit>
</Anonymous>
EOF
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh

cat > 1434987998786.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-proftpd
cd ..
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "proftpd=>`date`" | sudo tee -a $INSTALLED_LIST