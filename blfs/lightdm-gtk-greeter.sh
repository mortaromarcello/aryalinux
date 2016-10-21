#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf

#REQ:lightdm
#REQ:greybird-gtk-theme
#REQ:aryalinux-wallpapers
#REC:aryalinux-fonts

cd $SOURCE_DIR

wget -nc https://launchpad.net/lightdm-gtk-greeter/2.0/2.0.1/+download/lightdm-gtk-greeter-2.0.1.tar.gz


TARBALL=lightdm-gtk-greeter-2.0.1.tar.gz
DIRECTORY=lightdm-gtk-greeter-2.0.1

tar -xf $TARBALL

cd $DIRECTORY

export CFLAGS="-Wno-error=format-nonliteral"
./configure --prefix=/usr --sysconfdir=/etc --disable-liblightdm-qt &&
make "-j`nproc`"

cat > 1434987998845.sh << "ENDOFFILE"
make install
ENDOFFILE
chmod a+x 1434987998845.sh
sudo ./1434987998845.sh
sudo rm -rf 1434987998845.sh


sudo tee -a /etc/lightdm/lightdm-gtk-greeter.conf << EOF
[greeter]
xft-hintstyle = hintmedium
xft-antialias = true
xft-rgba = rgb
icon-theme-name = Numix-Circle
theme-name = Greybird
background = /usr/share/backgrounds/aryalinux/2016_05_Life-of-Pix-free-peaceful-Lake-mountains-OlivierMiche.jpg
font-name = Droid Sans 10
EOF

 
cd $SOURCE_DIR
sudo rm -rf $DIRECTORY
 
echo "lightdm-gtk-greeter=>`date`" | sudo tee -a $INSTALLED_LIST
