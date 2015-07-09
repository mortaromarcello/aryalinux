#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:mail


cd $SOURCE_DIR

wget -nc http://ftp.de.debian.org/debian/pool/main/a/at/at_3.1.16.orig.tar.gz
wget -nc ftp://ftp.de.debian.org/debian/pool/main/a/at/at_3.1.16.orig.tar.gz


TARBALL=at_3.1.16.orig.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998770.sh << "ENDOFFILE"
groupadd -g 17 atd                                                  &&
useradd -d /dev/null -c "atd daemon" -g atd -s /bin/false -u 17 atd &&
mkdir -p /var/spool/cron
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

sed -i '/docdir/s/=.*/= @docdir@/' Makefile.in

./configure --docdir=/usr/share/doc/at-3.1.16 \
            --with-daemon_username=atd        \
            --with-daemon_groupname=atd       \
            SENDMAIL=/usr/sbin/sendmail       \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make -j1

cat > 1434987998770.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

cat > 1434987998770.sh << "ENDOFFILE"
systemctl enable atd
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "at=>`date`" | sudo tee -a $INSTALLED_LIST