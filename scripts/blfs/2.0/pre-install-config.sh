#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf



cd $SOURCE_DIR






cat > 1434987998797.sh << "ENDOFFILE"
ln -sv $XORG_PREFIX /usr/X11R6
ENDOFFILE
chmod a+x 1434987998797.sh
sudo ./1434987998797.sh
sudo rm -rf 1434987998797.sh

export KDE_PREFIX=/usr

export KDE_PREFIX=/opt/kde

cat > /etc/profile.d/kde.sh << 'EOF'
# Begin /etc/profile.d/kde.sh

KDE_PREFIX=/opt/kde
KDEDIR=$KDE_PREFIX

pathappend $KDE_PREFIX/bin PATH
pathappend $KDE_PREFIX/lib/pkgconfig PKG_CONFIG_PATH
pathappend $KDE_PREFIX/share/pkgconfig PKG_CONFIG_PATH
pathappend $KDE_PREFIX/share XDG_DATA_DIRS
pathappend $KDE_PREFIX/share/man MANPATH
pathappend /etc/kde/xdg XDG_CONFIG_DIRS

export KDE_PREFIX KDEDIR

# End /etc/profile.d/kde.sh
EOF


cat > 1434987998797.sh << "ENDOFFILE"
cat >> /etc/ld.so.conf << EOF
# Begin kde addition

/opt/kde/lib

# End kde addition
EOF
ENDOFFILE
chmod a+x 1434987998797.sh
sudo ./1434987998797.sh
sudo rm -rf 1434987998797.sh

cat > 1434987998797.sh << "ENDOFFILE"
install -d $KDE_PREFIX/share &&
ln -svf /usr/share/dbus-1 $KDE_PREFIX/share &&
ln -svf /usr/share/polkit-1 $KDE_PREFIX/share
ENDOFFILE
chmod a+x 1434987998797.sh
sudo ./1434987998797.sh
sudo rm -rf 1434987998797.sh

cat > 1434987998797.sh << "ENDOFFILE"
mv /opt/kde{,-4.14.3} &&
ln -svf kde-4.14.3 /opt/kde
ENDOFFILE
chmod a+x 1434987998797.sh
sudo ./1434987998797.sh
sudo rm -rf 1434987998797.sh


 
cd $SOURCE_DIR
 
echo "pre-install-config=>`date`" | sudo tee -a $INSTALLED_LIST