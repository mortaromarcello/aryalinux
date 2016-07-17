#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:qt4

cd $SOURCE_DIR

wget -nc http://download.virtualbox.org/virtualbox/5.1.0/VirtualBox-5.1.0-108711-Linux_amd64.run
wget -nc https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.5.tar.xz
tar xf linux-4.5.tar.xz
cp config-64 linux-4.5/.config
if [ `uname -m` == "x86_64" ]
then
	wget -nc aryalinux.org/releases/2016.04/config-64
else
	wget -nc aryalinux.org/releases/2016.04/config-32
fi
pushd linux-4.5
make oldconfig
make prepare
make scripts
popd
chmod a+x VirtualBox-5.1.0-108711-Linux_amd64.run
sudo KERN_DIR="`pwd`/linux-4.5" ./VirtualBox-5.1.0-108711-Linux_amd64.run

sudo ln -svf /opt/VirtualBox/virtualbox.desktop /usr/share/applications/
sudo update-desktop-database
sudo update-mime-database /usr/share/mime

cd $SOURCE_DIR
rm -rf linux-4.5

echo "virtualbox=>`date`" | sudo tee -a $INSTALLED_LIST
