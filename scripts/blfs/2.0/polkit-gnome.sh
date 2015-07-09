#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#DEP:gtk3
#DEP:polkit


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz


TARBALL=polkit-gnome-0.105.tar.xz
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./configure --prefix=/usr &&
make

cat > 1434987998823.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998823.sh
sudo ./1434987998823.sh
sudo rm -rf 1434987998823.sh

cat > 1434987998823.sh << "ENDOFFILE"
mkdir -pv /etc/xdg/autostart &&
cat > /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop << "EOF"
[Desktop Entry]
Name=PolicyKit Authentication Agent
Comment=PolicyKit Authentication Agent
Exec=/usr/libexec/polkit-gnome-authentication-agent-1
Terminal=false
Type=Application
Categories= NoDisplay=true
OnlyShowIn=GNOME;XFCE;Unity;
AutostartCondition=GNOME3 unless-session gnome
EOF
ENDOFFILE
chmod a+x 1434987998823.sh
sudo ./1434987998823.sh
sudo rm -rf 1434987998823.sh


 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "polkit-gnome=>`date`" | sudo tee -a $INSTALLED_LIST