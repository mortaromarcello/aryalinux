#!/bin/bash

set -e

. /etc/alps/alps.conf
. /var/lib/alps/functions

#VER:httpd:2.4.23

#REQ:apr-util
#REQ:pcre
#REC:openssl
#OPT:db
#OPT:doxygen
#OPT:libxml2
#OPT:lynx
#OPT:links
#OPT:openldap
#OPT:apr-util
#OPT:rsync
#OPT:lua


cd $SOURCE_DIR

URL=https://archive.apache.org/dist/httpd/httpd-2.4.23.tar.bz2

wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/httpd/httpd-2.4.23.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/httpd/httpd-2.4.23.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/httpd/httpd-2.4.23.tar.bz2 || wget -nc https://archive.apache.org/dist/httpd/httpd-2.4.23.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/httpd/httpd-2.4.23.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/httpd/httpd-2.4.23.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/7.10/httpd-2.4.23-blfs_layout-1.patch || wget -nc http://www.linuxfromscratch.org/patches/downloads/httpd/httpd-2.4.23-blfs_layout-1.patch

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`

tar xf $TARBALL
cd $DIRECTORY

whoami > /tmp/currentuser


sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
groupadd -g 25 apache &&
useradd -c "Apache Server" -d /srv/www -g apache \
        -s /bin/false -u 25 apache

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


patch -Np1 -i ../httpd-2.4.23-blfs_layout-1.patch           &&
sed '/dir.*CFG_PREFIX/s@^@#@' -i support/apxs.in            &&
./configure --enable-authnz-fcgi                            \
            --enable-layout=BLFS                            \
            --enable-mods-shared="all cgi"                  \
            --enable-mpms-shared=all                        \
            --enable-suexec=shared                          \
            --with-apr=/usr/bin/apr-1-config                \
            --with-apr-util=/usr/bin/apu-1-config           \
            --with-suexec-bin=/usr/lib/httpd/suexec         \
            --with-suexec-caller=apache                     \
            --with-suexec-docroot=/srv/www                  \
            --with-suexec-logfile=/var/log/httpd/suexec.log \
            --with-suexec-uidmin=100                        \
            --with-suexec-userdir=public_html               &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install                                 &&
mv -v /usr/sbin/suexec /usr/lib/httpd/suexec &&
chgrp apache           /usr/lib/httpd/suexec &&
chmod 4754             /usr/lib/httpd/suexec &&
chown -v -R apache:apache /srv/www

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
. /etc/alps/alps.conf
wget -nc null -O $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2
tar xf $SOURCE_DIR/blfs-systemd-units-20160602.tar.bz2 -C $SOURCE_DIR
cd $SOURCE_DIR/blfs-systemd-units-20160602
make install-httpd

cd $SOURCE_DIR
rm -rf blfs-systemd-units-20160602
ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

sudo rm -rf $DIRECTORY
echo "apache=>`date`" | sudo tee -a $INSTALLED_LIST

