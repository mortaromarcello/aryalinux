#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:x7lib


cd $SOURCE_DIR

wget -nc http://dbus.freedesktop.org/releases/dbus/dbus-1.8.16.tar.gz


TARBALL=dbus-1.8.16.tar.gz
DIRECTORY=dbus-1.8.16

tar -xf $TARBALL

cd $DIRECTORY

export DBUS_VERSION=$(dbus-daemon --version | head -n1 | awk '{print $5}')

./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --with-console-auth-dir=/run/console \
            --docdir=/usr/share/doc/dbus-${DBUS_VERSION} &&
make

cat > 1434987998771.sh << "ENDOFFILE"
systemctl start rescue.target
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
mv -v /usr/lib/libdbus-1.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh

cat > 1434987998771.sh << "ENDOFFILE"
cat > /etc/dbus-1/session-local.conf << "EOF"
<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>

 <!-- Search for .service files in /usr/local -->
 <servicedir>/usr/local/share/dbus-1/services</servicedir>

</busconfig>
EOF
ENDOFFILE
chmod a+x 1434987998771.sh
sudo ./1434987998771.sh
sudo rm -rf 1434987998771.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "dbus=>`date`" | sudo tee -a $INSTALLED_LIST