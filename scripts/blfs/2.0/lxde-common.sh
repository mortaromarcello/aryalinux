#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:lxde-icon-theme
#DEP:lxpanel
#DEP:lxsession
#DEP:openbox
#DEP:pcmanfm
#DEP:systemd
#DEP:desktop-file-utils
#DEP:hicolor-icon-theme
#DEP:shared-mime-info


cd $SOURCE_DIR

wget -nc http://downloads.sourceforge.net/lxde/lxde-common-0.99.0.tar.xz


TARBALL=lxde-common-0.99.0.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc &&
make

cat > 1434987998827.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998827.sh
sudo ./1434987998827.sh
sudo rm -rf 1434987998827.sh

cat > 1434987998827.sh << "ENDOFFILE"
update-mime-database /usr/share/mime &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&
update-desktop-database -q
ENDOFFILE
chmod a+x 1434987998827.sh
sudo ./1434987998827.sh
sudo rm -rf 1434987998827.sh

cat > ~/.xinitrc << "EOF"
startlxde
EOF

startx


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lxde-common=>`date`" | sudo tee -a $INSTALLED_LIST