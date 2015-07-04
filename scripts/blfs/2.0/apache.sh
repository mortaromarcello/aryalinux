#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:apr-util
#DEP:pcre
#DEP:openssl


cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/httpd/httpd-2.4.12.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/httpd-2.4.12-blfs_layout-1.patch


TARBALL=httpd-2.4.12.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998786.sh << "ENDOFFILE"
groupadd -g 25 apache &&
useradd -c "Apache Server" -d /srv/www -g apache \
        -s /bin/false -u 25 apache
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh

patch -Np1 -i ../httpd-2.4.12-blfs_layout-1.patch &&
sed '/dir.*CFG_PREFIX/s@^@#@' -i support/apxs.in &&
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
make

cat > 1434987998786.sh << "ENDOFFILE"
make install                                 &&

mv -v /usr/sbin/suexec /usr/lib/httpd/suexec &&
chgrp -v apache        /usr/lib/httpd/suexec &&
chmod -v 4754          /usr/lib/httpd/suexec &&

chown -v -R apache:apache /srv/www
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh

cat > 1434987998786.sh << "ENDOFFILE"
wget -nc http://www.linuxfromscratch.org/blfs/downloads/systemd/blfs-systemd-units-20150210.tar.bz2 -O ../blfs-systemd-units-20150210.tar.bz2
tar -xf ../blfs-systemd-units-20150210.tar.bz2 -C .
cd blfs-systemd-units-20150210
make install-httpd
cd ..
ENDOFFILE
chmod a+x 1434987998786.sh
sudo ./1434987998786.sh
sudo rm -rf 1434987998786.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "apache=>`date`" | sudo tee -a $INSTALLED_LIST