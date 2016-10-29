#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

cd $SOURCE_DIR

wget -nc "aryalinux.org/releases/2016.04/Ambiance&Radiance-Flat-Colors-16-04-1-LTS-GTK-3-18Theme.tar.gz"
wget -nc aryalinux.org/releases/2016.04/Vibrancy-Colors-GTK-Icon-Theme-v-2-7.tar.gz
wget -nc aryalinux.org/releases/2016.04/Vivacious-Colors-GTK-Icon-Theme-v-1-4.tar.gz
wget -nc aryalinux.org/releases/2016.04/wall.png
wget -nc aryalinux.org/releases/2016.04/start-here.svg
wget -nc aryalinux.org/releases/2016.04/arya-plymouth-theme.tar.gz
wget -nc aryalinux.org/releases/2016.04/aryalinux-font.tar.xz
wget -nc aryalinux.org/releases/2016.04/aryalinux-wallpapers-2016.04.tar.gz

sudo tar xf aryalinux-wallpapers-2016.04.tar.gz -C /
sudo cp -v wall.png /usr/share/backgrounds/

sudo tar xf "Ambiance&Radiance-Flat-Colors-16-04-1-LTS-GTK-3-18Theme.tar.gz" -C /usr/share/themes
sudo tar xf Vibrancy-Colors-GTK-Icon-Theme-v-2-7.tar.gz -C /usr/share/icons
sudo tar xf Vivacious-Colors-GTK-Icon-Theme-v-1-4.tar.gz -C /usr/share/icons

tar xf aryalinux-font.tar.xz
cd aryalinux-fonts
sudo tar xf fonts.tar.gz -C /

cd $SOURCE_DIR
rm -rf aryalinux-fonts

for f in `find /usr/share/icons/Vivacious-* -name start-here.svg`
do
	sudo cp -v start-here.svg $f
done

sudo tar xf arya-plymouth-theme.tar.gz -C /usr/share/plymouth/themes/

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
