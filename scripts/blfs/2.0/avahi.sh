#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:glib2
#DEP:gobject-introspection
#DEP:gtk2
#DEP:gtk3
#DEP:libdaemon
#DEP:libglade


cd $SOURCE_DIR

wget -nc http://avahi.org/download/avahi-0.6.31.tar.gz


TARBALL=avahi-0.6.31.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998782.sh << "ENDOFFILE"
groupadd -fg 84 avahi &&
useradd -c "Avahi Daemon Owner" -d /var/run/avahi-daemon -u 84 \
        -g avahi -s /bin/false avahi
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
groupadd -fg 86 netdev
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

sed -i 's/\(CFLAGS=.*\)-Werror \(.*\)/\1\2/' configure &&
sed -i -e 's/-DG_DISABLE_DEPRECATED=1//' \
 -e '/-DGDK_DISABLE_DEPRECATED/d' avahi-ui/Makefile.in &&
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     \
            --disable-mono       \
            --disable-monodoc    \
            --disable-python     \
            --disable-qt3        \
            --disable-qt4        \
            --enable-core-docs   \
            --with-distro=none   \
            --with-systemdsystemunitdir=/lib/systemd/system &&
make

cat > 1434987998782.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
systemctl enable avahi-daemon
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh

cat > 1434987998782.sh << "ENDOFFILE"
systemctl enable avahi-dnsconfd
ENDOFFILE
chmod a+x 1434987998782.sh
sudo ./1434987998782.sh
sudo rm -rf 1434987998782.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "avahi=>`date`" | sudo tee -a $INSTALLED_LIST