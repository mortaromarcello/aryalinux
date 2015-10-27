#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:libwnck2
#DEP:libxfce4ui
#DEP:which


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/xfce4-session/4.10/xfce4-session-4.10.1.tar.bz2
wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/xfce4-session-4.10.1-logind_suspend_hibernate-1.patch


TARBALL=xfce4-session-4.10.1.tar.bz2
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

patch -Np1 -i ../xfce4-session-4.10.1-logind_suspend_hibernate-1.patch &&
./configure --prefix=/usr \
            --sysconfdir=/etc \
            --disable-legacy-sm &&
make

cat > 1434987998824.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998824.sh
sudo ./1434987998824.sh
sudo rm -rf 1434987998824.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "xfce4-session=>`date`" | sudo tee -a $INSTALLED_LIST