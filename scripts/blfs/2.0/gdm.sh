#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:accountsservice
#DEP:gtk3
#DEP:iso-codes
#DEP:itstool
#DEP:libcanberra
#DEP:linux-pam
#DEP:gnome-session
#DEP:gnome-shell
#DEP:systemd


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gdm/3.14/gdm-3.14.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gdm/3.14/gdm-3.14.1.tar.xz


TARBALL=gdm-3.14.1.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

cat > 1434987998818.sh << "ENDOFFILE"
groupadd -g 21 gdm &&
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
        -g gdm -s /bin/false gdm
ENDOFFILE
chmod a+x 1434987998818.sh
sudo ./1434987998818.sh
sudo rm -rf 1434987998818.sh

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --disable-static     &&
make

cat > 1434987998818.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998818.sh
sudo ./1434987998818.sh
sudo rm -rf 1434987998818.sh

cat > 1434987998818.sh << "ENDOFFILE"
install -v -m644 data/gdm.service /lib/systemd/system/gdm.service
ENDOFFILE
chmod a+x 1434987998818.sh
sudo ./1434987998818.sh
sudo rm -rf 1434987998818.sh

cat > 1434987998818.sh << "ENDOFFILE"
systemctl enable gdm
ENDOFFILE
chmod a+x 1434987998818.sh
sudo ./1434987998818.sh
sudo rm -rf 1434987998818.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "gdm=>`date`" | sudo tee -a $INSTALLED_LIST