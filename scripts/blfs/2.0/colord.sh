#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:dbus
#DEP:glib2
#DEP:lcms2
#DEP:sqlite
#DEP:libgusb
#DEP:gobject-introspection
#DEP:polkit
#DEP:systemd
#DEP:vala


cd $SOURCE_DIR

wget -nc http://www.freedesktop.org/software/colord/releases/colord-1.2.9.tar.xz


TARBALL=colord-1.2.9.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998770.sh << "ENDOFFILE"
groupadd -g 71 colord &&
useradd -c "Color Daemon Owner" -d /var/lib/colord -u 71 \
        -g colord -s /bin/false colord
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh

./configure --prefix=/usr              \
            --sysconfdir=/etc          \
            --localstatedir=/var       \
            --with-daemon-user=colord  \
            --enable-vala              \
            --disable-argyllcms-sensor \
            --disable-bash-completion  \
            --disable-static &&
make

cat > 1434987998770.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998770.sh
sudo ./1434987998770.sh
sudo rm -rf 1434987998770.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "colord=>`date`" | sudo tee -a $INSTALLED_LIST