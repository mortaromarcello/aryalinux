#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libglade
#DEP:x7app
#DEP:glu


cd $SOURCE_DIR

wget -nc http://www.jwz.org/xscreensaver/xscreensaver-5.32.tar.gz


TARBALL=xscreensaver-5.32.tar.gz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998831.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998831.sh
sudo ./1434987998831.sh
sudo rm -rf 1434987998831.sh

cat > 1434987998831.sh << "ENDOFFILE"
cat > /etc/pam.d/xscreensaver << "EOF"
# Begin /etc/pam.d/xscreensaver

auth include system-auth
account include system-account

# End /etc/pam.d/xscreensaver
EOF
ENDOFFILE
chmod a+x 1434987998831.sh
sudo ./1434987998831.sh
sudo rm -rf 1434987998831.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xscreensaver=>`date`" | sudo tee -a $INSTALLED_LIST